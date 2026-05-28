package overworld;

class OverworldState extends FlxState
{
	public static var roomName:String = "test";
	public static var roomData:RoomData;
    
	public static var previousRoom:String = "";
	
	// CAMERA STUFF
	var camGame:FlxCamera;
	var camUI:FlxCamera;
	var cameraScrollX:Bool = false;
	var cameraScrollY:Bool = false;
	var cameraFollowingTilemap:FlxTilemap;
	
	// CHARACTERS
    var player:Player;
	var characters:FlxTypedSpriteGroup<Character>;

	// CUTSCENE
	public static var inCutscene:Bool = false;
	var dialogueBox:CtDialogueBox;

	// MAP AND TILES
	var map:BetterFlxOgmo3Loader;
	var tileSets:Map<String, FlxTilemap> = [];

	// INTERACTABLES
	var walkInteractables:FlxTypedGroup<Interactable>;
	var interactInteractables:FlxTypedGroup<Interactable>;
	
	// TRANSITION
	public static var lastTransitionTime:Float = 0;
	
	// FACING
	public static var lastFacing:FlxDirectionFlags = DOWN;
	
    override function create():Void{
        super.create();
        
        bgColor = FlxColor.WHITE;
        
		setupCameras();

		setupDialogueBox();
		loadRoom();        
		loadMap();
		doRoomTransition(lastTransitionTime, IN);
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

		handleCollision();
		handleSorting();
		handleCameraScroll();
	}

	/**
	 * call this to add the flxcameras that the game uses hehehe
	 */
	function setupCameras():Void
	{
		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;
		FlxG.cameras.add(camGame, true);

		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;
		FlxG.cameras.add(camUI, false);
	}
	
	/**
	 * Call this to handle the collisions of the characters
	 */
	function handleCollision():Void
	{
		FlxG.worldBounds.set(camGame.scroll.x, camGame.scroll.y, FlxG.width, FlxG.height); // FUCK EVERYTHING 2

		for (tile in tileSets)
		{
			FlxG.collide(tile, player.hitbox);
		}
		for (character in characters.members)
		{
			if (character != player)
			{
				FlxG.collide(character.hitbox, player.hitbox);
			}
		}
		
		if (!inCutscene)
		{
			for (interactable in walkInteractables.members)
			{
				if (FlxG.overlap(interactable, player.hitbox))
				{
					triggerInteractable(interactable);
				}
			}
		}
	}

	/**
	 * Call this to handle the sorting of certain game sprites
	 */
	function handleSorting():Void
	{
		characters.sort(FlxSort.byY, FlxSort.ASCENDING);
	}

	function handleCameraScroll():Void
	{
		if (cameraFollowingTilemap == null)
			return; // what!

		if (player != null)
		{
			camGame.focusOn(new FlxPoint(player.x + player.width / 2, player.y + player.height / 2));
		}

		if (!cameraScrollX)
		{
			camGame.scroll.x = (cameraFollowingTilemap.x + cameraFollowingTilemap.width / 2) - (FlxG.width / 2);
		}

		if (!cameraScrollY)
		{
			camGame.scroll.y = (cameraFollowingTilemap.y + cameraFollowingTilemap.height / 2) - (FlxG.height / 2);
		}
	}
	
	/**
	 * Call this to setup the dialogue box for use in cutscenes
	 */
	function setupDialogueBox():Void
	{
		dialogueBox = new CtDialogueBox();
		dialogueBox.settings.onComplete = endDialogues;
		dialogueBox.camera = camUI;
		dialogueBox.antialiasing = false;
		add(dialogueBox);
	}

	/**
	 * Call this to initialize the roomdata variable
	 */
	function loadRoom():Void
	{
		roomData = new RoomData(roomName);
	}

	/**
	 * Call this to load and add the tiles from the tilemap data!!
	 */
	function loadMap():Void
	{
		map = new BetterFlxOgmo3Loader(Constants.ogmoFilePath, Constants.tilemapsDataPath + roomData.map + ".json");
		for (layer in map.getLevelData().layers)
		{
			if (layer.tileset != null)
			{
				var tilesetData = new TilesetData(layer.tileset);
				var tiles = map.loadTilemap(Constants.tilesetGraphicPath + tilesetData.graphic + ".png", layer.name);
				tiles.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
				tiles.antialiasing = false;
				for (i in 0...tilesetData.collisions.length)
				{
					var val = tilesetData.collisions[i];
					tiles.setTileProperties(i, switch (val)
					{
						case "NONE": NONE;
						case "ANY": ANY;
						default: NONE;
					});
				}
				tiles.camera = camGame;	
				cameraScrollX = tiles.width >= FlxG.width;
				cameraScrollY = tiles.height >= FlxG.height;
				cameraFollowingTilemap = tiles;
				tiles.follow(camGame);
				add(tiles);

				tileSets.set(layer.tileset, tiles);
			}
		}

		if (cameraFollowingTilemap != null)
		{
			if (!cameraScrollX)
			{
				camGame.minScrollX = null;
				camGame.maxScrollX = null;
			}
			if (!cameraScrollY)
			{
				camGame.minScrollY = null;
				camGame.maxScrollY = null;
			}
			handleCameraScroll();
		}
		
		characters = new FlxTypedSpriteGroup<Character>();
		characters.camera = camGame;
		add(characters);
		
		player = new Player();
		// camGame.follow(player.hitbox, LOCKON, 1);
		player.camera = camGame;
		player.facing = lastFacing;
		characters.add(player);
		
		var playerPlacePoints:Array<PlayerPlacePoint> = [];

		walkInteractables = new FlxTypedGroup<Interactable>();
		walkInteractables.camera = camGame;
		add(walkInteractables);

		interactInteractables = new FlxTypedGroup<Interactable>();
		interactInteractables.camera = camGame;
		add(interactInteractables);

		player.interaction.add(function(hb:CtSprite):Void
		{
			if (!inCutscene)
			{
				for (interactable in interactInteractables.members)
				{
					if (FlxG.overlap(interactable, hb))
					{
						triggerInteractable(interactable);
					}
				}	
			}
		});

		map.loadEntities(function(entity:EntityData):Void
		{
			switch (entity.name)
			{
				case "interactable":
					var interactable = new Interactable(entity);

					if (interactable.type == WALK)
					{
						walkInteractables.add(interactable);
					}
					else if (interactable.type == INTERACT)
					{
						interactInteractables.add(interactable);
					}
				case "player":
					playerPlacePoints.push(new PlayerPlacePoint(entity));
				case "character":
					placeCharacter(entity.x * Constants.overworldPixelScale, entity.y * Constants.overworldPixelScale, entity.values.name);
				default:
					//
			}
		}, "entities");
		var placePointsContainsPreviousRoom:Bool = false;

		if (previousRoom != "")
		{
			for (placePoint in playerPlacePoints)
			{
				if (placePoint.entrance == previousRoom)
				{
					placePointsContainsPreviousRoom = true;
					break;
				}
			}
		}

		for (placePoint in playerPlacePoints)
		{
			if (placePoint.entrance == previousRoom || placePoint.entrance == "" && !placePointsContainsPreviousRoom)
			{
				player.positionCharacter(placePoint.position.x * Constants.overworldPixelScale, placePoint.position.y * Constants.overworldPixelScale);
				break;
			}
		}
	}

	/**
	 * Call this to add a character to the map
	 * @param x the x position of the character
	 * @param y the y position of the character
	 * @param name the name of the character
	 * @return the character youre adding
	 */
	function placeCharacter(x:Float, y:Float, name:String):Character
	{
		var char = new Character(name);
		char.positionCharacter(x, y);
		char.camera = camGame;
		characters.add(char);

		return char;
	}
	
	/**
	 * Call this to trigger an interactable object!!
	 * @param interactable the interactable object to trigger
	 */
	function triggerInteractable(interactable:Interactable):Void
	{
		if (interactable.dialogue != "")
		{
			startDialogue([interactable.dialogue]);
		}
		if (interactable.room != "")
		{
			moveRoom(interactable.room, interactable.roomTransitionTime);
		}
	}

	/**
	 * Call this to change which room youre in
	 * @param newRoom the name of the new room
	 * @param transitionTime how long the transition should last
	 */
	function moveRoom(newRoom:String, transitionTime:Float):Void
	{
		previousRoom = roomName;

		roomName = newRoom;
		lastTransitionTime = transitionTime;

		lastFacing = player.facing;
		
		doRoomTransition(transitionTime, OUT, function():Void
		{
			FlxG.resetState();
		});
	}
	/**
	 * Call this to add the room transition animation
	 * @param time how long it should last
	 * @param transitionType in vs out 
	 * @param onComplete what should happen when the transition is done
	 */
	function doRoomTransition(time:Float, transitionType:TransitionType, ?onComplete:Void->Void = null):Void
	{
		if (time <= 0)
		{
			if (onComplete != null)
				onComplete();
		}
		else
		{
			var tranSubState = new RoomTransitionSubState(time, transitionType);
			tranSubState.onComplete.add(function():Void
			{
				if (onComplete != null)
					onComplete();
			});
			openSubState(tranSubState);
			persistentUpdate = false;
		}
	}

	/**
	 * Call this to start a dialogue box cutscene!!
	 * @param dialogues 
	 */
	function startDialogue(dialogues:Array<String>):Void
	{
		inCutscene = true;
		dialogueBox.loadDialogueFiles(dialogues);
		dialogueBox.openBox();
		dialogueBox.playDialogue();
	}

	/**
	 * Call this when a dialogue is finished
	 */
	function endDialogues():Void
	{
		new FlxTimer().start(0.1, function(f):Void
		{
			inCutscene = false;
		});
	}
}
package overworld;

class OverworldState extends FlxState
{
	public static var roomName:String = "test";
	public static var roomData:RoomData;
    
	public static var previousRoom:String = "";
	
	var camGame:FlxCamera;
	var camUI:FlxCamera;
	
    var player:Player;
    
	public static var inCutscene:Bool = false;
	
	var characters:FlxTypedSpriteGroup<Character>;
	
	var map:BetterFlxOgmo3Loader;
	var tileSets:Map<String, FlxTilemap> = [];

	var walkInteractables:FlxTypedGroup<Interactable>;
	var interactInteractables:FlxTypedGroup<Interactable>;
	
	var dialogueBox:CtDialogueBox;
	
    override function create():Void{
        super.create();
        
        bgColor = FlxColor.WHITE;
        
		setupCameras();

		setupDialogueBox();

		loadRoom();        
		loadMap();
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

		handleCollision();
		characters.sort(FlxSort.byY, FlxSort.ASCENDING);
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

	function setupDialogueBox():Void
	{
		dialogueBox = new CtDialogueBox();
		dialogueBox.settings.onComplete = endDialogues;
		dialogueBox.camera = camUI;
		add(dialogueBox);
	}

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
				add(tiles);

				tileSets.set(layer.tileset, tiles);
			}
		}

		characters = new FlxTypedSpriteGroup<Character>();
		characters.camera = camGame;
		add(characters);
		
		placePlayer();
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
	function placePlayer():Player
	{
		player = new Player();
		camGame.follow(player, LOCKON, 1);
		player.camera = camGame;
		characters.add(player);

		return player;
	}
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
			moveRoom(interactable.room);
		}
	}

	function moveRoom(newRoom:String):Void
	{
		previousRoom = roomName;

		roomName = newRoom;
		FlxG.resetState();
	}
	function startDialogue(dialogues:Array<String>):Void
	{
		inCutscene = true;
		dialogueBox.loadDialogueFiles(dialogues);
		dialogueBox.openBox();
		dialogueBox.playDialogue();
	}

	function endDialogues():Void
	{
		new FlxTimer().start(0.1, function(f):Void
		{
			inCutscene = false;
		});
	}
}
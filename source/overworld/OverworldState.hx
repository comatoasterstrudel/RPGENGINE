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
	var lockCamera:Bool = false;
	
	// CHARACTERS
    var player:Player;
	// PROPS
	var props:FlxTypedSpriteGroup<FlxSprite>;

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
	public static var battleTransition:MosaicEffect;
	
	// FACING
	public static var lastFacing:FlxDirectionFlags = DOWN;
	
	// EXIT
	var exitProgress:Float = 0;
	
	// BATTLE
	public static var leftForBattle:Bool = false;
	public static var positionBeforeBattle:FlxPoint = new FlxPoint();
	
	// RANDOM ENCOUNTEr
	var selectedRandomEncounter:String = "";
	var encounterCooldown:Float = 0;
	
    override function create():Void{
        super.create();
        
		inCutscene = false;
		
        bgColor = FlxColor.WHITE;
        
		setupCameras();

		setupDialogueBox();
		loadRoom();        
		loadMap();
		selectRandomEncounter();
		if (leftForBattle)
		{
			player.positionCharacter(positionBeforeBattle.x, positionBeforeBattle.y);
			leftForBattle = false;
			doBattleTransition(OUT);
		}
		else
		{
			doRoomTransition(lastTransitionTime, IN);
		}
	}
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

		handleCollision();
		handleSorting();
		handleCameraScroll();
		handleExit(elapsed);
		handleRandomEncounters(elapsed);
		if (battleTransition != null)
		{
			battleTransition.update();
		}
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
		for (prop in props.members)
		{
			if (prop is Character)
			{
				var character:Character = cast prop;
				
				if (character != player)
				{
					FlxG.collide(character.hitbox, player.hitbox);
				}
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
		props.sort(FlxSort.byY, FlxSort.ASCENDING);
	}

	function handleCameraScroll():Void
	{
		if (cameraFollowingTilemap == null || lockCamera)
			return; // what!

		if (player != null)
		{
			camGame.focusOn(new FlxPoint(player.hitbox.x + player.hitbox.width / 2, player.hitbox.y + player.hitbox.height / 2));
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
	
	function handleExit(elapsed:Float):Void
	{
		if (CtControls.checkInput("exit", PRESSED))
		{
			exitProgress += elapsed;

			if (exitProgress >= Constants.exitTime)
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();

				FlxG.switchState(LevelSelectorState.new);
			}
		}
		else
		{
			exitProgress = 0;
		}
	}
	
	function handleRandomEncounters(elapsed:Float):Void
	{
		if (selectedRandomEncounter == "")
			return;

		if (!inCutscene && player.moving)
		{
			if (encounterCooldown >= Constants.encounterCooldown)
			{
				if (FlxG.random.bool(roomData.encounterChance * elapsed))
				{
					startBattle(selectedRandomEncounter);
				}
			}
			else
			{
				encounterCooldown += elapsed;
			}
		}
	}

	function selectRandomEncounter():Void
	{
		if (roomData.encounters.length == 0 || roomData.encounterChance <= 0)
			return;

		var total:Float = 0;
		var encounterData:Array<Array<Dynamic>> = []; // battle name, low, high

		for (encounter in roomData.encounters)
		{
			encounterData.push([encounter.battleName, total, total + encounter.rarity]);
			total += encounter.rarity;
		}

		var randomNum = FlxG.random.float(0, total);

		for (encounter in encounterData)
		{
			if (randomNum >= encounter[1] && randomNum < encounter[2])
			{
				selectedRandomEncounter = encounter[0];
			}
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
		
		props = new FlxTypedSpriteGroup<FlxSprite>();
		props.camera = camGame;
		add(props);
		
		player = new Player();
		player.camera = camGame;
		player.facing = lastFacing;
		props.add(player);
		
		var playerPlacePoints:Array<PlayerPlacePoint> = [];

		walkInteractables = new FlxTypedGroup<Interactable>();
		walkInteractables.camera = camGame;
		walkInteractables.visible = false;
		add(walkInteractables);

		interactInteractables = new FlxTypedGroup<Interactable>();
		interactInteractables.camera = camGame;
		interactInteractables.visible = false;
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
					var interactable = new Interactable().addByEntity(entity);

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
				case "door":
					var door = new Door(player, Std.int(entity.x * Constants.overworldPixelScale), Std.int(entity.y * Constants.overworldPixelScale),
						entity.values.graphic, entity.values.room, entity.values.transitionTime);

					props.add(door);
					interactInteractables.add(door);
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
		props.add(char);

		return char;
	}
	
	/**
	 * Call this to trigger an interactable object!!
	 * @param interactable the interactable object to trigger
	 */
	function triggerInteractable(interactable:Interactable):Void
	{
		interactable.triggerSignal.dispatch();
		
		if (interactable.dialogue != "")
		{
			startDialogue([interactable.dialogue]);
		}
		if (interactable.room != "")
		{
			moveRoom(interactable.room, interactable.roomTransitionTime);
		}
		if (interactable.encounterName != "")
		{
			startBattle(interactable.encounterName);
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
		
		inCutscene = true;

		new FlxTimer().start(0.1, function(f):Void
		{
			doRoomTransition(transitionTime, OUT, function():Void
			{
				FlxG.resetState();
			});
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
	/**
	 * Call this to start a battle !!
	 * @param name 
	 */
	function startBattle(name:String):Void
	{
		leftForBattle = true;

		lastFacing = player.facing;

		positionBeforeBattle.set(player.x, player.y);

		doBattleTransition(IN, function():Void
		{
			PlayState.setBattle(name, STORY);
			FlxG.switchState(PlayState.new);
		});
	}

	function doBattleTransition(transitionType:TransitionType, ?onComplete:Void->Void):Void
	{
		player.facing = DOWN;

		var startZoom:Float = 1;
		var endZoom:Float = 10;

		camGame.zoom = startZoom;

		handleCameraScroll();

		var startCameraPosition:FlxPoint = FlxPoint.get(camGame.scroll.x, camGame.scroll.y);
		var endCameraPosition:FlxPoint = FlxPoint.get(player.x + player.width / 2 - FlxG.width / 2, player.y + player.height / 2 - FlxG.height / 2);

		var startBlockWidth:Float = 1;
		var endBlockWidth:Float = FlxG.width / 2 * (FlxG.random.float(0.8, 1.2));

		var startBlockHeight:Float = 1;
		var endBlockHeight:Float = FlxG.height / 2 * (FlxG.random.float(0.8, 1.2));

		var startFadeAlpha:Float = 0;
		var endFadeAlpha = 1;

		lockCamera = true;
		inCutscene = true;

		new FlxTimer().start(transitionType == IN ? .5 : 0, function(f):Void
		{
			battleTransition = new MosaicEffect();
			battleTransition.thewidth = transitionType == IN ? startBlockWidth : endBlockWidth;
			battleTransition.theheight = transitionType == IN ? startBlockHeight : endBlockHeight;

			camGame.filters = [(new ShaderFilter(battleTransition))];

			FlxTween.tween(battleTransition, {
				thewidth: transitionType == IN ? endBlockWidth : startBlockWidth,
				theheight: transitionType == IN ? endBlockHeight : startBlockHeight
			}, 1, {
				ease: transitionType == IN ? FlxEase.quartIn : FlxEase.quartOut,
				onComplete: function(f):Void
				{
					if (transitionType == OUT)
					{
						camGame.filters = [];
						battleTransition = null;
					}
				}
			});
		});

		camGame.scroll.set(transitionType == IN ? startCameraPosition.x : endCameraPosition.x,
			transitionType == IN ? startCameraPosition.y : endCameraPosition.y);

		FlxTween.tween(camGame.scroll,
			{x: transitionType == IN ? endCameraPosition.x : startCameraPosition.x, y: transitionType == IN ? endCameraPosition.y : startCameraPosition.y}, 1,
			{startDelay: transitionType == IN ? 0 : .5});

		camGame.zoom = transitionType == IN ? startZoom : endZoom;

		FlxTween.tween(camGame, {zoom: transitionType == IN ? endZoom : startZoom}, 1.5, {
			ease: transitionType == IN ? FlxEase.quartIn : FlxEase.quartOut,
			onComplete: function(f):Void
			{
				if (transitionType == OUT)
				{
					player.facing = lastFacing;
				}

				inCutscene = false;
				lockCamera = false;

				if (onComplete != null)
				{
					onComplete();
				}
			}
		});

		var spr = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.WHITE);
		spr.camera = camUI;
		spr.alpha = transitionType == IN ? startFadeAlpha : endFadeAlpha;
		add(spr);

		new FlxTimer().start(transitionType == IN ? .5 : 0, function(f):Void
		{
			FlxTween.tween(spr, {alpha: transitionType == IN ? endFadeAlpha : startFadeAlpha}, 1, {
				ease: transitionType == IN ? FlxEase.quartIn : FlxEase.quartOut,
				onComplete: function(f):Void
				{
					if (transitionType == OUT)
						spr.destroy();
				}
			});
		});
	}

	public static function resetGlobalVars():Void
	{
		lastTransitionTime = 0;
		lastFacing = DOWN;
		previousRoom = "";
		leftForBattle = false;
		positionBeforeBattle.set(0, 0);
	}
}
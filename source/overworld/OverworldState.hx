package overworld;

class OverworldState extends FlxState
{
	public static var roomName:String = "test";
	public static var roomData:RoomData;
    
	public static var previousRoom:String = "";
	
    var player:Player;
    
	var map:BetterFlxOgmo3Loader;
	var tileSets:Map<String, FlxTilemap> = [];
    
	var walkInteractables:FlxTypedGroup<Interactable>;
	var interactInteractables:FlxTypedGroup<Interactable>;
	
    override function create():Void{
        super.create();
        
        bgColor = FlxColor.WHITE;
        
		loadRoom();
        
		loadMap();
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);
		handleCollision();
	}

	function handleCollision():Void
	{
		FlxG.worldBounds.set(FlxG.camera.scroll.x, FlxG.camera.scroll.y, FlxG.width, FlxG.height); // FUCK EVERYTHING 2

		for (tile in tileSets)
		{
			FlxG.collide(tile, player.hitbox);
		}
		for (interactable in walkInteractables.members)
		{
			if (FlxG.overlap(interactable, player.hitbox))
			{
				triggerInteractable(interactable);
			}
		}
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
				add(tiles);

				tileSets.set(layer.tileset, tiles);
			}
		}

		placePlayer();
		var playerPlacePoints:Array<PlayerPlacePoint> = [];

		walkInteractables = new FlxTypedGroup<Interactable>();
		add(walkInteractables);

		interactInteractables = new FlxTypedGroup<Interactable>();
		add(interactInteractables);

		player.interaction.add(function(hb:CtSprite):Void
		{
			for (interactable in interactInteractables.members)
			{
				trace("!?!");
				if (FlxG.overlap(interactable, hb))
				{
					triggerInteractable(interactable);
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
		FlxG.camera.follow(player.hitbox, LOCKON, 1);
		add(player);

		return player;
	}
	/**
	 * Call this to trigger an interactable object!!
	 * @param interactable the interactable object to trigger
	 */
	function triggerInteractable(interactable:Interactable):Void
	{
		if (interactable.dialogue != "")
		{
			//
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
}
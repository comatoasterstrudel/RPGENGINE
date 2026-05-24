package overworld;

class OverworldState extends FlxState
{
	public static var roomName:String = "test";
	public static var roomData:RoomData;
    
    var player:Player;
    
	var map:BetterFlxOgmo3Loader;
	var tileSets:Map<String, FlxTilemap> = [];
    
    override function create():Void{
        super.create();
        
        bgColor = FlxColor.WHITE;
        
		loadRoom();
        
		loadMap();
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);
		FlxG.worldBounds.set(FlxG.camera.scroll.x, FlxG.camera.scroll.y, FlxG.width, FlxG.height); // FUCK EVERYTHING

		for (tile in tileSets)
		{
			FlxG.collide(tile, player);
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
        
		map.loadEntities(function(entity:EntityData):Void
		{
			switch (entity.name)
			{
				case "player":
					player.char.setPosition(entity.x * Constants.overworldPixelScale, entity.y * Constants.overworldPixelScale);
				default:
					//
			}
		}, "entities");
	}
	function placePlayer():Player
	{
		player = new Player();
		FlxG.camera.follow(player.char, LOCKON, 1);
		add(player);

		return player;
	}
}
package overworld;

class OverworldState extends FlxState
{
    var player:Player;
    
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
    
    override function create():Void{
        super.create();
        
        bgColor = FlxColor.WHITE;
        
		loadMap();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
    }
	function loadMap():Void
	{
		map = new FlxOgmo3Loader("assets/data/tilemaps/RPGENGINE.ogmo", "assets/data/tilemaps/tilemap_test.json");
		walls = map.loadTilemap(Constants.tilesGraphicPath + "placeholder.png", "walls");
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		walls.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
		walls.antialiasing = false;
		add(walls);

		map.loadEntities(function(entity:EntityData):Void
		{
			switch (entity.name)
			{
				case "player":
					if (player == null)
					{
						player = new Player();
						player.char.setPosition(entity.x * Constants.overworldPixelScale, entity.y * Constants.overworldPixelScale);
						FlxG.camera.follow(player.char);
						add(player);
					}
				default:
					//
			}
		}, "entities");
	}
}
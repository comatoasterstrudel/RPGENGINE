package overworld.lighting;

class LightingSprite extends FlxSpriteGroup
{
    var backSprite:CtSprite;
    var lightSources:Array<LightSourceSprite> = [];
    
    public function new(map:BetterFlxOgmo3Loader, roomData:RoomData):Void{
        super();
        
        backSprite = new CtSprite().createColorBlock(Std.int(map.getLevelData().width * Constants.overworldPixelScale), Std.int(map.getLevelData().height * Constants.overworldPixelScale), FlxColor.BLACK);
        add(backSprite);
        
        alpha = roomData.lighting; 
        
        antialiasing = false;        
    }
    
    public function addLightSource(graphic:String, x:Int, y:Int):LightSourceSprite{
        var lightSource = new LightSourceSprite(graphic, x, y);
        add(lightSource);
        
        lightSources.push(lightSource);
        
        return lightSource;
    } 
}
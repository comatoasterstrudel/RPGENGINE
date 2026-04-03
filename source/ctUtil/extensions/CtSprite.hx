package ctUtil.extensions;

/**
 * The replacement for FlxSprite in this project
 */
class CtSprite extends FlxSprite
{
    public var lerpManager:CtLerpManager;
     
    public function new(?x:Float, ?y:Float, ?antialiasing = true):Void{
        super(x,y);
        
	    this.antialiasing = antialiasing;
        
        lerpManager = new CtLerpManager(this);
    }
    
    override function update(elapsed:Float):Void{
		super.update(elapsed);

        lerpManager.updateLerps(elapsed);		
	}
    
    public function createFromImage(key:String, size:Float = 1):CtSprite{
        loadGraphic(key);
        resize(size);
        return this;
    }
    
    public function createColorBlock(width:Int, height:Int, color:FlxColor):CtSprite{
        makeGraphic(width, height, color);
        return this;
    }
    
    public function createFromSparrow(imgKey:String, xmlKey:String, size:Float = 1):CtSprite{
        frames = FlxAtlasFrames.fromSparrow(imgKey, xmlKey);
        resize(size);
        return this;    
    }
    
    public function resize(size:Float):Void{
        setGraphicSize(Std.int(this.width * size));
        updateHitbox();
    }
}
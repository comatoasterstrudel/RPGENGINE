package overworld.lighting;

class LightSourceSprite extends CtSprite
{
	public var tag:String = "";

	public function new(graphic:String, x:Int, y:Int, tag:String):Void
	{
        super();
        
        createFromImage(Constants.lightSourceGraphicPath + graphic + ".png");
        setGraphicSize(width * Constants.overworldPixelScale, height * Constants.overworldPixelScale);
		updateHitbox();
        
        antialiasing = false;
        
        setPosition(x, y);
        
		this.tag = tag;
        
        #if showLightSources
        FlxG.state.add(this);
        #end
    }
}
package overworld.lighting;

class LightSourceSprite extends CtSprite
{
    public function new(graphic:String, x:Int, y:Int):Void{
        super();
        
        createFromImage(Constants.lightSourceGraphicPath + graphic + ".png");
        setGraphicSize(width * Constants.overworldPixelScale, height * Constants.overworldPixelScale);
		updateHitbox();
        
        antialiasing = false;
        
        setPosition(x, y);
        
        #if showLightSources
        FlxG.state.add(this);
        #end
    }
}
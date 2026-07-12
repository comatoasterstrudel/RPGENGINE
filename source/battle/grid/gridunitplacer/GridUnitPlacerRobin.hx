package battle.grid.gridunitplacer;

class GridUnitPlacerRobin extends CtSprite
{
    public function new():Void{
        super();
        
        createFromImage(getGraphicName());
        
        antialiasing = false;
        
        color = FlxColor.GRAY;
    }
    
    function getGraphicName():String{
        var listOfFiles = CtUtil.findFilesInPath(Constants.gridUnitPlacerRobinPath, [".png"], true, false);
        
        return listOfFiles[FlxG.random.int(0, listOfFiles.length - 1)];
    }
    
    public function doAnim():Void{
        screenCenter(X);
        
        x += 80;
        FlxTween.tween(this, {x: x - 80}, 3.3, {ease: FlxEase.quartOut});
    }
}
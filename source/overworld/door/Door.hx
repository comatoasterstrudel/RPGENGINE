package overworld.door;

class Door extends Interactable
{
    public function new(x:Int, y:Int, graphic:String, room:String, transitionTime:Float):Void{
        super();
        addManually(x, y, 32, 32, INTERACT, "", room, transitionTime, "");
        createFromSparrow(Constants.doorGraphicPath + graphic + ".png", Constants.doorGraphicPath + graphic + ".xml");
        animation.addByPrefix("open", "open", 1);
        animation.addByPrefix("closed", "closed", 0);
        animation.play("closed");
        resize(Constants.overworldPixelScale);
        antialiasing = false;
        visible = true;
        triggerSignal.add(function():Void{
           animation.play("open"); 
        });
    }
}
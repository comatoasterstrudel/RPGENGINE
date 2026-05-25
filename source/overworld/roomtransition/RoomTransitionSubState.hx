package overworld.roomtransition;

class RoomTransitionSubState extends FlxSubState
{
    var time:Float = 0;
    
    public var onComplete:FlxSignal = new FlxSignal();
    
    public function new(time:Float, type:TransitionType):Void{
        super();
        
        this.time = time;
        
        var camTransition:FlxCamera = new FlxCamera();
        camTransition.bgColor.alpha = 0;
        FlxG.cameras.add(camTransition, false);
        
        var cover = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        cover.camera = camTransition;
        cover.alpha = (type == OUT ? 0 : 1);
        add(cover);
        
        FlxTween.tween(cover, {alpha: type == IN ? 0 : 1}, time, {onComplete: function(f):Void{
            onComplete.dispatch();
            if(type == IN) close();
        }});
    } 
}
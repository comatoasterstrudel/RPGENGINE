package overworld;

class OverworldState extends FlxState
{
    var player:Player;
    
    override function create():Void{
        super.create();
        
        bgColor = FlxColor.WHITE;
        
        player = new Player();
        player.screenCenter();
        add(player);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
    }
}
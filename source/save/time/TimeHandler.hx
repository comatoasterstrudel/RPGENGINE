package save.time;

class TimeHandler extends FlxBasic
{
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        Save.playtime += elapsed;
    }
}
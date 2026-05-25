package overworld.character;

class PlayerPlacePoint
{
    public var position:FlxPoint;
    
    public var entrance:String;
    
    public function new(entity:EntityData){
        position = new FlxPoint(entity.x, entity.y);
        entrance = entity.values.entrance;
    }
}
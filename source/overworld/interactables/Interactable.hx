package overworld.interactables;

class Interactable extends CtSprite
{
    var entity:EntityData;
    
    public var type:InteractableType;
    
    public var dialogue:String;
    
    public var room:String;

	public var roomTransitionTime:Float;
    
    public function new(entity:EntityData){
        super(entity.x * Constants.overworldPixelScale, entity.y * Constants.overworldPixelScale);
        
        this.entity = entity;
        
        createColorBlock(Std.int(entity.width * Constants.overworldPixelScale), Std.int(entity.height * Constants.overworldPixelScale), FlxColor.BLUE);
        
        if(entity.values.triggerByWalkingOver) type = WALK; else type = INTERACT;
        dialogue = entity.values.dialogue;
        room = entity.values.room;
		roomTransitionTime = entity.values.roomTransitionTime;
        
        immovable = true;        
        
        visible = false;
    }
}
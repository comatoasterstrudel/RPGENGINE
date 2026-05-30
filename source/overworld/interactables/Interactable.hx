package overworld.interactables;

class Interactable extends CtSprite
{    
    public var type:InteractableType;
    
    public var dialogue:String;
    
    public var room:String;

	public var roomTransitionTime:Float;
    
	public var encounterName:String = '';
    
	public var triggerSignal = new FlxSignal();

	public function new()
	{
		super();
        
		immovable = true;

		visible = false;
	}

	public function addByEntity(entity:EntityData):Interactable
	{
		setPosition(entity.x * Constants.overworldPixelScale, entity.y * Constants.overworldPixelScale);
		createColorBlock(Std.int(entity.width * Constants.overworldPixelScale), Std.int(entity.height * Constants.overworldPixelScale), FlxColor.BLUE);

		if (entity.values.triggerByWalkingOver)
			type = WALK;
		else
			type = INTERACT;
		dialogue = entity.values.dialogue;
		room = entity.values.room;
		roomTransitionTime = entity.values.roomTransitionTime;
		encounterName = entity.values.encounterName;

		return this;
	}

	public function addManually(x:Float, y:Float, width:Int, height:Int, ?type:InteractableType, ?dialogue:String, ?room:String, ?roomTransitionTime:Float,
			?encounterName:String):Void
	{
		setPosition(x, y);
		createColorBlock(width, height, FlxColor.BLUE);
    
		this.type = type ?? WALK;
		this.dialogue = dialogue ?? "";
		this.room = room ?? "";
		this.roomTransitionTime = roomTransitionTime ?? .5;
		this.encounterName = encounterName ?? "";
    }
}
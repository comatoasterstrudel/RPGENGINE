package overworld.interactables;

class Interactable extends CtSprite
{    
    public var type:InteractableType;
    
	public var tag:String;
	
    public var dialogue:String;
    
    public var room:String;

	public var roomTransitionTime:Float;
    
	public var encounterName:String = '';
    
	public var scriptFunction:String = "";
	
	public var openSave:Bool = false;

	public var saveName:String = "";
	
	public var saveBgName:String = "";

	public var triggerSignal = new FlxSignal();

	public var disabled:Bool = false;
	
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
		tag = entity.values.tag;
		dialogue = entity.values.dialogue;
		room = entity.values.room;
		roomTransitionTime = entity.values.roomTransitionTime;
		encounterName = entity.values.encounterName;
		scriptFunction = entity.values.scriptFunction;
		openSave = entity.values.openSave;
		saveName = entity.values.saveName;
		saveBgName = entity.values.saveBgName;

		return this;
	}

	public function addManually(x:Float, y:Float, width:Int, height:Int, ?type:InteractableType, ?tag:String, ?dialogue:String, ?room:String,
			?roomTransitionTime:Float,
		?encounterName:String, ?scriptFunction:String, ?openSave:Bool, ?saveName:String, ?saveBgName:String):Void
	{
		setPosition(x, y);
		createColorBlock(width, height, FlxColor.BLUE);
    
		this.type = type ?? WALK;
		this.tag = tag ?? "";
		this.dialogue = dialogue ?? "";
		this.room = room ?? "";
		this.roomTransitionTime = roomTransitionTime ?? .5;
		this.encounterName = encounterName ?? "";
		this.scriptFunction = scriptFunction ?? "";
		this.openSave = openSave ?? false;
		this.saveName = saveName ?? "";
		this.saveBgName = saveBgName ?? "";
    }
}
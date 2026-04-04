package units;

class Unit extends CtSprite
{
    /**
     * the id for this unit, basically its name
     */
    public var unitID:String;
    
	public var data:UnitData;
    
    public var grid:Grid;
    
    public var position:FlxPoint;

	public var controllable:Bool;
	
	public var maxHp:Stat = new Stat("maxHp");
	public var speed:Stat = new Stat("speed");

	var stats:Array<Stat>;

	public var hp:Stat;

	public function new(unitID:String, grid:Grid, position:FlxPoint, controllable:Bool):Void
	{
        super();
        
        this.unitID = unitID;
		this.data = new UnitData(unitID);
        
        this.grid = grid;
        this.position = position;
        
		this.controllable = controllable;
		
		applyStats();
		
        applyGraphic();
        
        lerpManager.lerpX = true;
        lerpManager.lerpY = true;
		lerpManager.lerpSpeed = 8;
	}

	function applyStats():Void
	{
		this.maxHp.value = data.maxHp;
		this.speed.value = data.speed;

		this.hp = new Stat("hp", maxHp.value, 0, maxHp.value);

		stats = [maxHp, speed, hp];
	}
	
    function applyGraphic():Void{
		var path = Constants.unitGridGraphicPath + data.gridGraphic + '.png';

		if (Assets.exists(path))
		{
			createFromImage(path);
		}
		else
		{
			FlxG.log.error("Can't find unit grid graphic \"" + path + "\".");
			createColorBlock(40, 40, FlxColor.BLUE);
		}        
		antialiasing = false;
    }

	public function doEntranceAnimation():Void
	{
		lerpManager.lerpScaleX = true;
		lerpManager.lerpScaleY = true;
		lerpManager.targetScale.set(1, 1);
		scale.set(10, 10);
	}
	public function changeStat(name:String, amount:Int):Void
	{
		for (stat in stats)
		{
			if (stat.name == name)
			{
				stat.changeValue(amount);
				return;
			}
		}

		FlxG.log.error("Can't change stat \"" + name + "\". It doesn't exist!");
	}
}
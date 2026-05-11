package battle.units;

import flixel.effects.FlxFlicker;

class Unit extends CtSprite
{
    /**
     * the id for this unit, basically its name
     */
    public var unitID:String;
    
	public var uniqueUnitID:Int;
	
	public var data:UnitData;
    
    public var grid:Grid;
    
    public var position:FlxPoint;

	public var controllable:Bool;
	
	public var maxHp:Stat = new Stat("maxHp");
	public var speed:Stat = new Stat("speed");

	var stats:Array<Stat>;

	public var hp:Stat;

	public var skills:Array<SkillData> = [];
	
	public static var uniqueUnitIDnum:Int = 0;

	public function new(unitID:String, grid:Grid, position:FlxPoint, controllable:Bool):Void
	{
        super();
        
        this.unitID = unitID;
		this.data = new UnitData(unitID);
        
        this.grid = grid;
        this.position = position;
        
		this.controllable = controllable;
		
		Unit.uniqueUnitIDnum++;

		this.uniqueUnitID = uniqueUnitIDnum;
		
		applyStats();
		
		applySkills();
		
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
	
	function applySkills():Void
	{
		for (i in 0...data.skills.length)
		{
			var skill = new SkillData(data.skills[i]);

			skills.push(skill);
		}
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
	public function takeDamage(amount:Int):Void
	{
		if (amount < 0)
		{
			heal(amount);
			return;
		}
		
		var transaction = PlayState.eventManager.startTransaction(uniqueUnitID + "_" + "damageAnim");
		changeStat("hp", -amount);
		FlxFlicker.flicker(this, .5, 0.03, this.visible, true, function(f):Void
		{
			PlayState.eventManager.finishTransaction(transaction.name);
		});
		cast(FlxG.state, PlayState).damageTextSignal.dispatch(this, "- " + Std.string(amount), FlxColor.RED);
	}

	public function heal(amount:Int):Void
	{
		if (amount < 0)
		{
			takeDamage(amount);
			return;
		}
		
		var transaction = PlayState.eventManager.startTransaction(uniqueUnitID + "_" + "healAnim");
		changeStat("hp", amount);
		FlxFlicker.flicker(this, .2, 0.01, this.visible, function(f):Void // placeholder
		{
			PlayState.eventManager.finishTransaction(transaction.name);
		});
		cast(FlxG.state, PlayState).damageTextSignal.dispatch(this, "+ " + Std.string(amount), FlxColor.LIME);
	}
}
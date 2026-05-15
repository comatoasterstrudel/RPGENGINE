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

	public var dead:Bool = false;
	
	public var statuses:Array<StatusEffect> = [];
	
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
		var transactionName = uniqueUnitID + "_" + "damageAnim";
		
		if (amount < 0)
		{
			heal(amount);
			return;
		}
		
		PlayState.eventManager.finishTransaction(transactionName);
		var transaction = PlayState.eventManager.startTransaction(transactionName);
		changeStat("hp", -amount);
		if (hp.value == 0)
		{
			dead = true;
		}
		FlxFlicker.flicker(this, .5, 0.03, true, true, function(f):Void
		{
			PlayState.eventManager.finishTransaction(transactionName);
		});
		cast(FlxG.state, PlayState).damageTextSignal.dispatch(this, "- " + Std.string(amount), FlxColor.RED);
	}

	public function heal(amount:Int):Void
	{
		if (dead)
			return;
		
		var transactionName = uniqueUnitID + "_" + "healAnim";

		if (amount < 0)
		{
			takeDamage(amount);
			return;
		}
		
		PlayState.eventManager.finishTransaction(transactionName);
		var transaction = PlayState.eventManager.startTransaction(transactionName);
		changeStat("hp", amount);
		FlxFlicker.flicker(this, .2, 0.01, this.visible, function(f):Void // placeholder
		{
			PlayState.eventManager.finishTransaction(transactionName);
		});
		cast(FlxG.state, PlayState).damageTextSignal.dispatch(this, "+ " + Std.string(amount), FlxColor.LIME);
	}
	public function applyStatusEffect(id:String, turns:Int):Void
	{
		var statusData = new StatusEffect(id, turns);

		var previousData = getStatusByName(id);
		if (previousData != null)
		{
			if (previousData.turns < turns)
			{
				previousData.turns = turns;
			}
		}
		else
		{
			statuses.push(statusData);
		}

		doStatusEffectAnim(statusData.id);

		statusData.finished.add(function():Void
		{
			statuses.remove(statusData);
		});
	}

	public function getStatusByName(id:String):StatusEffect
	{
		for (i in statuses)
		{
			if (i.id == id)
			{
				return i;
			}
		}
		return null;
	}

	public function doStatusEffectAnim(id:String):Void
	{
		var status = getStatusByName(id);

		if (status != null)
		{
			var transactionName = uniqueUnitID + "_" + "statusAnim_" + status.id;

			var transaction = PlayState.eventManager.startTransaction(transactionName);

			cast(FlxG.state, PlayState).damageTextSignal.dispatch(this, status.data.text, status.data.color);

			var statusEffectAnim = new StatusEffectAnim(this, status);
			this.shader = statusEffectAnim;
			statusEffectAnim.finished.add(function():Void
			{
				PlayState.eventManager.finishTransaction(transactionName);
				this.shader = null;
			});
		}
	}
}
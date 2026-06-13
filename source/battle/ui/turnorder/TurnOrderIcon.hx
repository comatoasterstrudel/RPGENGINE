package battle.ui.turnorder;

class TurnOrderIcon extends FlxTypedGroup<CtSprite>
{
    public var bg:CtSprite;
    
    public var unitGraphic:CtSprite;
    
	var curUnit:Unit;
    
	var ogColor:FlxColor = FlxColor.WHITE;
	 
    public function new():Void{
        super();
        
        bg = new CtSprite();
		bg.lerpManager.lerpY = true;
		bg.lerpManager.lerpSpeed = 9;
		bg.y = 0;
        add(bg);
        
        unitGraphic = new CtSprite();
        add(unitGraphic);
        
		bg.antialiasing = false;
		unitGraphic.antialiasing = false;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);

		updateSpritePositions();
    }
    
	public function updateTurnOrderIcon(unit:Unit):Void
	{
		this.curUnit = unit;
		bg.createFromImage(curUnit.controllable ? Constants.turnOrderIconAllyPath : Constants.turnOrderIconEnemyPath);
		unitGraphic.loadGraphicFromSprite(curUnit);
		ogColor = curUnit.controllable ? FlxColor.LIME : FlxColor.RED;
		bg.y = -15;
		bg.lerpManager.targetPosition.y = -15;
		updateSpritePositions();
	}

	function updateSpritePositions():Void
	{
		CtUtil.centerSpriteOnSprite(unitGraphic, bg, true, true);
		bg.color = ogColor.getLightened(.8 - (FlxMath.bound(((bg.y + 15) / 15), 0, 1) / 2));
	}

	public function updateCurrentTurn(unit:Unit):Void
	{
		if (curUnit.uniqueUnitID == unit.uniqueUnitID)
		{
			bg.lerpManager.targetPosition.y = 0;
		}
		else
		{
			bg.lerpManager.targetPosition.y = -15;
		}
    }
}
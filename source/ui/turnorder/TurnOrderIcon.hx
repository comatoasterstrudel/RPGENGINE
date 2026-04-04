package ui.turnorder;

class TurnOrderIcon extends FlxTypedGroup<CtSprite>
{
    public var bg:CtSprite;
    
    public var unitGraphic:CtSprite;
    
	var curUnit:Unit;
    
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

		CtUtil.centerSpriteOnSprite(unitGraphic, bg, true, true);
		bg.color = FlxColor.GRAY.getLightened(((bg.y + 15) / 15));
    }
    
    public function updateTurnOrderIcon(unit:Unit):Void{
        bg.createFromImage(unit.controllable ? Constants.turnOrderIconAllyPath : Constants.turnOrderIconEnemyPath);
        unitGraphic.loadGraphicFromSprite(unit);
		this.curUnit = unit;
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
package ui;

class TurnOrderIcon extends FlxTypedGroup<CtSprite>
{
    public var bg:CtSprite;
    
    public var unitGraphic:CtSprite;
    
    public function new():Void{
        super();
        
        bg = new CtSprite();
        add(bg);
        
        unitGraphic = new CtSprite();
        add(unitGraphic);
        
       bg.antialiasing = false;
       unitGraphic.antialiasing = false;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);

        bg.y = 0;
        CtUtil.centerSpriteOnSprite(unitGraphic, bg, true, true);            
    }
    
    public function updateTurnOrderIcon(unit:Unit):Void{
        bg.createFromImage(unit.controllable ? Constants.turnOrderIconAllyPath : Constants.turnOrderIconEnemyPath);
        unitGraphic.loadGraphicFromSprite(unit);
    }
}
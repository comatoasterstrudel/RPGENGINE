package ui;

class MiniHealthBar extends FlxBar
{
    var unit:Unit;
    
    public function new(unit:Unit):Void{                
        super(0, 0, LEFT_TO_RIGHT, Constants.miniHealthBarWidth, Constants.miniHealthBarHeight, unit.hp, "value", 0, unit.maxHp.value, true);

        this.unit = unit;

        createColoredEmptyBar(Constants.miniHealthBarEmptyColor, true, Constants.miniHealthBarOutlineColor, Constants.miniHealthBarOutlineWidth);
        createColoredFilledBar(Constants.miniHealthBarFillColor, true, Constants.miniHealthBarOutlineColor, Constants.miniHealthBarOutlineWidth);
    }
    
    override function update(elapsed:Float):Void{
        CtUtil.centerSpriteOnSprite(this, unit, true, false);
        this.y = unit.y - this.height + Constants.miniHealthBarYSpacing;
    }
}
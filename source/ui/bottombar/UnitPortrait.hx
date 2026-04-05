package ui.bottombar;

class UnitPortrait extends CtSprite
{
    public var unit:Unit;
    
    public function new():Void{
        super();
        
        lerpManager.lerpScaleX = true;
		lerpManager.lerpScaleY = true;
		lerpManager.targetScale.set(1, 1);
		lerpManager.lerpSpeed = 8;
        
        antialiasing = false;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updatePosition();
    }
    
    function updatePosition():Void{
        updateHitbox();
		setPosition(150 - width / 2, FlxG.height - height);
    }
    
    public function applyUnitGraphic(unit):Void{
        this.unit = unit;
        
        var path = Constants.unitUiGraphicPath + unit.data.uiGraphic + '.png';

		if (Assets.exists(path))
		{
			createFromImage(path);
		}
		else
		{
			FlxG.log.error("Can't find unit ui graphic \"" + path + "\".");
			createColorBlock(300, 350, FlxColor.BLUE);
		}        

		scale.set(1.5, .7);

		updateHitbox();
		setPosition(150 - width / 2, FlxG.height - height);
	}
}
package battle.ui.statuseffectbar;

class StatusEffectIcon extends FlxSpriteGroup
{
    var unit:Unit;
    
    public var baseSprite:CtSprite;
    
    public var whiteSprite:CtSprite;
    
    public var iconSprite:CtSprite;

    public function new(unit:Unit):Void{
        super();
        
        this.unit = unit;
        
        baseSprite = new CtSprite().createColorBlock(19, 19, FlxColor.BLACK);
        add(baseSprite);
        
        whiteSprite = new CtSprite().createColorBlock(15, 15, FlxColor.WHITE);
        add(whiteSprite);
        
        iconSprite = new CtSprite(0,0, false);
        add(iconSprite);
        
        kill();
    }
    
    public function updateStatus(status:StatusEffect):Void{
        whiteSprite.color = status.data.color;
        
        var path = Constants.statusEffectIconPath + status.data.iconGraphic + '.png';
        
        if (Assets.exists(path))
        {
            iconSprite.createFromImage(path);
        }
        else
        {
            FlxG.log.error("Can't find status icon graphic \"" + path + "\".");
            iconSprite.createColorBlock(15, 15, FlxColor.BLUE);
        }        
    }
    
    public function updateSpritesPosition():Void{
        CtUtil.centerSpriteOnSprite(whiteSprite, baseSprite, true, true);
        CtUtil.centerSpriteOnSprite(iconSprite, baseSprite, true, true);
    }
}
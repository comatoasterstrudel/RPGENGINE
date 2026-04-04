package ui.bottombar;

class SkillIcon extends FlxSpriteGroup
{
    public var skillSprite:CtSprite;
    public var outlineSprite:CtSprite;
    
    public var currentSkill:String = '';
    
    public function new():Void{
        super();
        
        skillSprite = new CtSprite();
        skillSprite.antialiasing = false;
        add(skillSprite);
        
        outlineSprite = new CtSprite(0, 590).createFromImage(Constants.skillOutlineGraphicPath);
        outlineSprite.antialiasing = false;
        add(outlineSprite);        
    }
    
    public function updateSkill(active:Bool, ?skill:SkillData):Void{
        if(active){
            outlineSprite.color = FlxColor.WHITE;
                
            var path = Constants.skillIconGraphicPath + skill.iconGraphic + '.png';

            if (Assets.exists(path))
            {
                skillSprite.createFromImage(path);
            }
            else
            {
                FlxG.log.error("Can't find skill icon graphic \"" + path + "\".");
                skillSprite.createColorBlock(40, 40, FlxColor.BLUE);
            }        
        } else {
            outlineSprite.color = FlxColor.GRAY;
            skillSprite.createFromImage(Constants.skillBoxEmptyGraphicPath);
        }
        
        CtUtil.centerSpriteOnSprite(skillSprite, outlineSprite, true, true);
    }
}
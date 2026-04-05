package ui.bottombar;

/**
 * Class to display the icon for a skill. Contained inside of an outline and over a background.
 */
class SkillIcon extends FlxSpriteGroup
{
	/**
	 * The background sprite to go behind the other sprites.
	 */
	public var bgSprite:CtSprite;

	/**
	 * The sprite that will change depedning on the skill. If blank, this sprite will be hidden.
	 */
    public var skillSprite:CtSprite;
	/**
	 * The outline to be shown above the other sprites
	 */
    public var outlineSprite:CtSprite;
    
	/**
	 * The skill this box is representing.
	 */
	public var currentSkill:SkillData;
    
	/**
	 * Is this icon displaying a real skill?
	 */
	public var enabled:Bool = false;
	
    public function new():Void{
        super();
        
		bgSprite = new CtSprite(0, 590).createFromImage(Constants.skillBackgroundGraphicPath);
		bgSprite.antialiasing = false;
		add(bgSprite);

		skillSprite = new CtSprite(0, 590);
        skillSprite.antialiasing = false;
        add(skillSprite);
        
        outlineSprite = new CtSprite(0, 590).createFromImage(Constants.skillOutlineGraphicPath);
        outlineSprite.antialiasing = false;
        add(outlineSprite);        
    }
    
	/**
	 * Call this to update the sprites on this icon.
	 * @param enabled Should this icon display a skill? Otherwise this box will display as blank.
	 * @param skill The skill this should display.
	 */
	public function updateSkill(enabled:Bool, ?skill:SkillData):Void
	{
		this.enabled = enabled;

		if (enabled)
		{
			this.currentSkill = skill;

			bgSprite.color = FlxColor.WHITE;
            outlineSprite.color = FlxColor.WHITE;

            var path = Constants.skillIconGraphicPath + skill.iconGraphic + '.png';

			skillSprite.visible = true;
            
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
			bgSprite.color = FlxColor.GRAY;
            outlineSprite.color = FlxColor.GRAY;
			skillSprite.visible = false;
        }
        
		CtUtil.centerSpriteOnSprite(bgSprite, outlineSprite, true, true);
        CtUtil.centerSpriteOnSprite(skillSprite, outlineSprite, true, true);
    }
}
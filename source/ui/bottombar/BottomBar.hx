package ui.bottombar;

class BottomBar extends FlxSpriteGroup
{  
    var bottomCover:CtSprite;
    
    var unitSprite:CtSprite;
    
    var curUnit:Unit;
    
    var skillIcons:Array<SkillIcon> = [];
    
    public function new():Void{
        super();
        
        bottomCover = new CtSprite().createColorBlock(Std.int(FlxG.width * 2), FlxG.height, FlxColor.BLACK);
        bottomCover.y = Constants.bottomBarY;
        bottomCover.angle = Constants.bottomBarAngle;
        bottomCover.alpha = Constants.bottomBarAlpha;
        bottomCover.screenCenter(X);
        bottomCover.antialiasing = false;
        add(bottomCover);
        
        unitSprite = new CtSprite();
        add(unitSprite);
        
        var skillOutlines:Array<FlxSprite> = [];
        
        for(i in 0...Constants.unitMaxSkills){
            var skillIcon = new SkillIcon();
            add(skillIcon);
            
            skillIcons.push(skillIcon);
            
            skillOutlines.push(skillIcon.outlineSprite);
        }
        
        CtUtil.centerGroup(skillOutlines, 20);
    }  
    
    public function updateCurrentUnit(unit:Unit):Void{
        this.curUnit = unit;
        
        applyUnitGraphic();
        
        for(i in 0...Constants.unitMaxSkills){
            skillIcons[i].updateSkill(false);
        }
        
        for(i in 0...unit.skills.length){
            skillIcons[i].updateSkill(true, unit.skills[i]);
        }
    }
    
    function applyUnitGraphic():Void{
        var path = Constants.unitUiGraphicPath + curUnit.data.uiGraphic + '.png';

		if (Assets.exists(path))
		{
			unitSprite.createFromImage(path);
		}
		else
		{
			FlxG.log.error("Can't find unit ui graphic \"" + path + "\".");
			unitSprite.createColorBlock(300, 350, FlxColor.BLUE);
		}        
		unitSprite.antialiasing = false;
        
        unitSprite.setPosition(0, FlxG.height - unitSprite.height);
    }
}
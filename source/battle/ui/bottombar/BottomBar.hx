package battle.ui.bottombar;

class BottomBar extends FlxSpriteGroup
{  
    var bottomCover:CtSprite;
    
	var unitPortrait:UnitPortrait;
        
	public var skillIcons:Array<SkillIcon> = [];
    
	public var endTurn:CtSprite;

	public var inspect:CtSprite;

	var curUnit:Unit;

    public function new():Void{
        super();
        
        bottomCover = new CtSprite().createColorBlock(Std.int(FlxG.width * 2), FlxG.height, FlxColor.BLACK);
        bottomCover.y = Constants.bottomBarY;
        bottomCover.angle = Constants.bottomBarAngle;
        bottomCover.alpha = Constants.bottomBarAlpha;
        bottomCover.screenCenter(X);
        bottomCover.antialiasing = false;
        add(bottomCover);
        
		unitPortrait = new UnitPortrait();
		add(unitPortrait);
        
        var skillOutlines:Array<FlxSprite> = [];
        
        for(i in 0...Constants.unitMaxSkills){
            var skillIcon = new SkillIcon();
            add(skillIcon);
            
            skillIcons.push(skillIcon);
            
            skillOutlines.push(skillIcon.outlineSprite);
        }
        
        CtUtil.centerGroup(skillOutlines, 20);
		inspect = new CtSprite(300, 590).createFromImage(Constants.inspectButtonGraphicPath);
		inspect.kill();
		add(inspect);
		
		endTurn = new CtSprite(1050, 590).createFromImage(Constants.endTurnButtonGraphicPath);
		endTurn.kill();
		add(endTurn);
	}
    
    public function updateCurrentUnit(unit:Unit):Void{
        this.curUnit = unit;
        
		unitPortrait.applyUnitGraphic(curUnit);
        
        for(i in 0...Constants.unitMaxSkills){
            skillIcons[i].updateSkill(false);
        }
        
        for(i in 0...unit.skills.length){
            skillIcons[i].updateSkill(true, unit.skills[i]);
		}
	}

	public function addMenu():Void
	{
		inspect.revive();
		endTurn.revive();
	}

	public function removeMenu():Void
	{
		inspect.kill();
		endTurn.kill();
	}
}
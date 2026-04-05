package ui.bottombar;

class BottomBar extends FlxSpriteGroup
{  
    var bottomCover:CtSprite;
    
	var unitPortrait:UnitPortrait;
        
    var skillIcons:Array<SkillIcon> = [];
    
	var endTurn:CtSprite;

	var menuManager:CtMenuManager;

	var cursor:CtSprite;

	public var signalEndTurn:FlxSignal;
    
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
		endTurn = new CtSprite(1050, 590).createFromImage(Constants.endTurnButtonGraphicPath);
		endTurn.kill();
		add(endTurn);

		menuManager = new CtMenuManager(function():Bool
		{
			return FlxG.keys.justPressed.RIGHT;
		}, function():Bool
		{
			return FlxG.keys.justPressed.LEFT;
		}, function():Bool
		{
			return FlxG.keys.justPressed.Z;
		});
		
		cursor = new CtSprite().createFromImage(Constants.cursorArrowGraphic);
		cursor.lerpManager.lerpX = true;
		cursor.lerpManager.lerpY = true;
		add(menuManager.addCursor(cursor, 20, true));

		signalEndTurn = new FlxSignal();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		menuManager.update();
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
		if (unit.controllable)
		{
			addMenu();
		}
		else
		{
			removeMenu();
		}
	}

	function addMenu():Void
	{
		endTurn.revive();

		var menuOptions:Array<CtMenuOption> = [];

		for (i in skillIcons)
		{
			if (i.enabled)
				menuOptions.push({sprite: i.outlineSprite, cursorDirection: UP});
		}

		menuOptions.push({
			sprite: endTurn,
			cursorDirection: UP,
			clickFunction: function(spr:FlxSprite):Void
			{
				signalEndTurn.dispatch();
			}
		});

		menuManager.setMenuOptions(menuOptions);

		menuManager.enable(true);
	}

	function removeMenu():Void
	{
		menuManager.disable();
		endTurn.kill();
	}
}
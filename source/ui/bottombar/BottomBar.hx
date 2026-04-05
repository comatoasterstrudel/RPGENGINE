package ui.bottombar;

class BottomBar extends FlxSpriteGroup
{  
    var bottomCover:CtSprite;
    
	var unitPortrait:CtSprite;
    
    var curUnit:Unit;
    
    var skillIcons:Array<SkillIcon> = [];
    
	var endTurn:CtSprite;

	var menuManager:CtMenuManager;

	var cursor:CtSprite;

	public var signalEndTurn:FlxSignal;
    
    public function new():Void{
        super();
        
        bottomCover = new CtSprite().createColorBlock(Std.int(FlxG.width * 2), FlxG.height, FlxColor.BLACK);
        bottomCover.y = Constants.bottomBarY;
        bottomCover.angle = Constants.bottomBarAngle;
        bottomCover.alpha = Constants.bottomBarAlpha;
        bottomCover.screenCenter(X);
        bottomCover.antialiasing = false;
        add(bottomCover);
        
		unitPortrait = new CtSprite();
		unitPortrait.lerpManager.lerpScaleX = true;
		unitPortrait.lerpManager.lerpScaleY = true;
		unitPortrait.lerpManager.targetScale.set(1, 1);
		unitPortrait.lerpManager.lerpSpeed = 8;
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

		cursor = new CtSprite().createFromImage(Constants.cursorArrowGraphic);
		cursor.lerpManager.lerpX = true;
		cursor.lerpManager.lerpY = true;
		add(cursor);

		signalEndTurn = new FlxSignal();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		unitPortrait.updateHitbox();
		unitPortrait.setPosition(150 - unitPortrait.width / 2, FlxG.height - unitPortrait.height);

		menuManager.update();
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
		if (unit.controllable)
		{
			addMenu();
		}
		else
		{
			removeMenu();
		}
    }
    
    function applyUnitGraphic():Void{
        var path = Constants.unitUiGraphicPath + curUnit.data.uiGraphic + '.png';

		if (Assets.exists(path))
		{
			unitPortrait.createFromImage(path);
		}
		else
		{
			FlxG.log.error("Can't find unit ui graphic \"" + path + "\".");
			unitPortrait.createColorBlock(300, 350, FlxColor.BLUE);
		}        
		unitPortrait.antialiasing = false;

		unitPortrait.scale.set(1.5, .7);

		unitPortrait.updateHitbox();
		unitPortrait.setPosition(150 - unitPortrait.width / 2, FlxG.height - unitPortrait.height);
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

		menuManager = new CtMenuManager(menuOptions, function():Bool
		{
			return FlxG.keys.justPressed.RIGHT;
		}, function():Bool
		{
			return FlxG.keys.justPressed.LEFT;
		}, function():Bool
		{
			return FlxG.keys.justPressed.Z;
		});

		menuManager.addCursor(cursor, 20, true);

		menuManager.enable(true);
	}

	function removeMenu():Void
	{
		menuManager.disable();
		endTurn.kill();
	}
}
package battle.grid.gridunitplacer;

class GridUnitPlacer extends FlxSpriteGroup
{
    var bg:CtSprite;    
    var uiBg:CtSprite;
	var uiBgAnim:GridUnitPlacerUiBg;

	var robin:GridUnitPlacerRobin;
    
    var unitIcons:FlxSpriteGroup;
    var unitIconArray:Array<GridUnitPlacerUnitIcon> = [];
    
    var allyGrid:Grid;
    var enemyGrid:Grid;

    var selectingMenuManager:CtMenuManager;
    var selectingCursor:Cursor;
    
	var topButtons:Array<CtSprite> = [];

	var selectingTextBg:CtSprite;
	var selectingText:CtText;
    
    var placingMenuManager:CtMenuManager;
    var placingCursor:Cursor;
    var placingUnitCursor:GridUnitPlacerCursor;
    
    var currentPlacingUnit:String = "";

    var status:GridUnitPlacerStatus = SELECTING;
    
    var cursorCamera:CtCamera;
    
    var placedUnits:Array<GridUnitPlacerInfo> = [];
    
    var ghostUnits:Array<GridUnitPlacerGhostUnit> = [];
    var ghostUnitSprites:FlxSpriteGroup;
    
    var onComplete:Array<GridUnitPlacerInfo>->Void;
    
	var startedBefore:Bool = false;
    
	public var inspectTrigger:FlxSignal = new FlxSignal();
    
    public function new(allyGrid:Grid, enemyGrid:Grid):Void{
        super();
        
        this.allyGrid = allyGrid;
        this.enemyGrid = enemyGrid;

        cursorCamera = new CtCamera();
        cursorCamera.bgColor.alpha = 0;
        FlxG.cameras.add(cursorCamera, false);
        
        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
		bg.scrollFactor.set(0, 0);
        add(bg);  
        
		robin = new GridUnitPlacerRobin();
		robin.alpha = 0;
		add(robin);
        
        uiBg = new CtSprite().createColorBlock(Std.int(Constants.gridUnitPlacerBgWidth), FlxG.height, FlxColor.WHITE);
        uiBg.setPosition(enemyGrid.spaces[0].baseSprite.x + (Grid.calculateGridSize(new FlxPoint(enemyGrid.size.x, enemyGrid.size.y)).x / 2) - uiBg.width / 2, 0);
        uiBg.alpha = 0;
		uiBgAnim = new GridUnitPlacerUiBg(uiBg);
		add(uiBgAnim);
        
        add(uiBg);
        
		selectingTextBg = new CtSprite().createColorBlock(Std.int(uiBg.width / 1.2), 120, FlxColor.BLACK);
		selectingTextBg.alpha = .4;
		selectingTextBg.visible = false;
		CtUtil.centerSpriteOnSprite(selectingTextBg, uiBg, true, false);
		selectingTextBg.y = FlxG.height - 150;
		add(selectingTextBg);

		selectingText = new CtText();
		selectingText.setFormat(Constants.fontName, 40, FlxColor.WHITE, CENTER, SHADOW, FlxColor.GRAY);
		selectingText.fieldWidth = uiBg.width / 1.2;
		selectingText.antialiasing = false;
		add(selectingText);
        
		addUnitIcons();  

        initSelectingMenu();
        initPlacingMenu();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        selectingMenuManager.update();
        placingMenuManager.update();
    }
    
    function addUnitIcons():Void{
        unitIcons = new FlxSpriteGroup();
        unitIcons.alpha = 0;
        add(unitIcons);
        
		var listOfUnits:Array<String> = Unit.getListOfUnits();
        
        var xPos:Int = 0;
        var yPos:Int = 0;
        
        for(i in 0...listOfUnits.length){
            var unitName:String = listOfUnits[i];
            
            var unitIcon = new GridUnitPlacerUnitIcon(unitName, uiBg.x + (xPos * Constants.gridUnitPlacerUnitIconSize) + (Constants.gridUnitPlacerUnitIconSpacing * (xPos + 1)), 250 + (yPos * Constants.gridUnitPlacerUnitIconSize) + (Constants.gridUnitPlacerUnitIconSpacing * (yPos + 1)), xPos, yPos);
            unitIcons.add(unitIcon);
            
            unitIconArray.push(unitIcon);
            
            xPos ++;
            if(xPos >= Constants.gridUnitPlacerUnitsPerRow){
                xPos = 0;
                yPos ++;
            }
        }
    }
    
    function initSelectingMenu():Void{
        selectingMenuManager = new CtMenuManager(CtControls.getInputFunction("right", JUSTPRESSED), CtControls.getInputFunction("left", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED),
			CtControls.getInputFunction("down", JUSTPRESSED), CtControls.getInputFunction("up", JUSTPRESSED));
            
        selectingCursor = new Cursor(Constants.cursorArrowGraphic);
        add(selectingCursor);
        
        selectingMenuManager.addCursor(selectingCursor, 30);
        
		var menuOptions:Array<Array<CtMenuOption>> = [[]];
        
		var xPos:Int = 0;

		for (buttonName in ["finish", "inspect", "reuse"])
		{
			var button = new CtSprite().createFromImage(Constants.gridUnitPlacerButtonPath + buttonName + ".png");

			button.y = 20;
			button.alpha = 0;
			button.antialiasing = false;
			add(button);

			topButtons.push(button);

			menuOptions[0].push({
				sprite: button,
				cursorDirection: DOWN,
				hoverFunction: function(f):Void
				{
					switch (buttonName)
					{
						case "finish":
							updateSelectingText("Start Battle");
						case "inspect":
							updateSelectingText("View the Board");
						case "reuse":
							updateSelectingText("Use Last Formation");
					}
				},
				clickFunction: function(f):Void
				{
					switch (buttonName)
					{
						case "finish":
							selectingMenuManager.disable();
							deactivate();    
						case "inspect":
							selectingMenuManager.disable();
							deactivate(function():Void
							{
								inspectTrigger.dispatch();
							});
						case "reuse":
					}
				}
			});

			xPos++;
		}

		CtUtil.centerGroup(cast topButtons, Constants.gridUnitPlacerUnitIconSpacing, uiBg.x + uiBg.width / 2);
        
        for(i in unitIconArray){
            if(menuOptions[i.yPos + 1] == null){
                menuOptions[i.yPos + 1] = [];
            }
            menuOptions[i.yPos + 1].push({sprite: i.bg, cursorDirection: UP, hoverFunction: function(f):Void{
                i.updateSelected(true);
					if (i.placed)
					{
						updateSelectingText(new UnitData(i.unit).name + "\nPLACED");
					}
					else
					{
						updateSelectingText(new UnitData(i.unit).name);
					}
            }, nonHoverFunction: function(f):Void{
                i.updateSelected(false);
            }, clickFunction: function(f):Void{
                if(i.placed){
                    removePlacedUnit(i.unit);
						selectingMenuManager.changeSelection();
                } else {
                    startPlacing(i.unit);
                }
            }});
        }
                
        selectingMenuManager.setMenuOptions(menuOptions, true);
    }
    
    function initPlacingMenu():Void{
        placingMenuManager = new CtMenuManager(CtControls.getInputFunction("right", JUSTPRESSED), CtControls.getInputFunction("left", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED),
			CtControls.getInputFunction("down", JUSTPRESSED), CtControls.getInputFunction("up", JUSTPRESSED));
            
        ghostUnitSprites = new FlxSpriteGroup();
        add(ghostUnitSprites);
        
        placingCursor = new Cursor(Constants.cursorArrowGraphic);
        add(placingCursor);
        
        placingMenuManager.addCursor(placingCursor, 30);
        
        placingUnitCursor = new GridUnitPlacerCursor(placingCursor);
        placingUnitCursor.visible = false;
        add(placingUnitCursor);
        
        new FlxTimer().start(0.1, function(f):Void{
            ghostUnitSprites.camera = cursorCamera;
            placingCursor.camera = cursorCamera;
            placingUnitCursor.camera = cursorCamera;
        });
        
        var gridSelectorSpaces:Array<GridSpace> = [];

        var menuOptions:Array<Array<CtMenuOption>> = [];
        
        for (space in allyGrid.spaces)
        {
            gridSelectorSpaces.push(space);
        }

		for (i in 0...Std.int(allyGrid.size.y))
		{
			menuOptions.push([]);
		}

		for (space in gridSelectorSpaces)
		{
			menuOptions[Std.int(space.position.y)].push({sprite: space.baseSprite, cursorDirection: UP, hoverFunction: function(f):Void{
                space.toggleFlashSprite(canPlaceOnSpace(space) ? true : false);
            }, nonHoverFunction: function(f):Void{
                space.toggleFlashSprite(false);
            }, cancelFunction: function(f):Void{
                endPlacing();
            }, clickFunction: function(f):Void{
                if(canPlaceOnSpace(space)){
                    placeUnit(space, currentPlacingUnit);
                }
            }});
        }
        
        placingMenuManager.setMenuOptions(menuOptions);
    }
    
    function hideGridSpaces():Void{
        for (space in allyGrid.spaces)
        {
            if(canPlaceOnSpace(space)) {
                space.baseSprite.alpha = 1;
            } else {
                space.baseSprite.alpha = .5;
            }
        } 
    }
    
    function showGridSpaces():Void{
        for (space in allyGrid.spaces)
        {
            space.baseSprite.alpha = 1;
            space.toggleFlashSprite(false);
        } 
    }
    
    function canPlaceOnSpace(space:GridSpace):Bool{
        var notPlacedOnYet = true;
        
        for(i in placedUnits){
            if(space.position.x == i.x && space.position.y == i.y){
                notPlacedOnYet = false;
            }
        }
        
        return(space.unit == null && notPlacedOnYet);
    }
    
    function startPlacing(unit:String):Void{
        status = PLACING;
        hideGridSpaces();
        placingUnitCursor.updateUnit(unit);
        currentPlacingUnit = unit;
        
        selectingMenuManager.disable();
        
        new FlxTimer().start(0.0001, function(f):Void{
            placingUnitCursor.visible = true;
            placingMenuManager.enable();            
        });
    }
    
    function endPlacing():Void{
        status = SELECTING;
        showGridSpaces();
        placingUnitCursor.visible = false;
        
        placingMenuManager.disable();
        
        new FlxTimer().start(0.0001, function(f):Void{
            selectingMenuManager.enable();            
        });
    }
    
    function placeUnit(space:GridSpace, unit:String):Void{
        endPlacing();
        
        placedUnits.push({unit: unit, x: Std.int(space.position.x), y: Std.int(space.position.y)});
        
        updatePlacedIcons();
        
        var ghost = new GridUnitPlacerGhostUnit(unit, space);
        ghostUnitSprites.add(ghost);
        
        ghostUnits.push(ghost);
    }
    
    function removePlacedUnit(unit:String):Void{
        for(i in placedUnits){
            if(i.unit == unit){
                placedUnits.remove(i);
                break;
            }
        }
        for(i in ghostUnits){
            if(i.unit == unit){
                ghostUnits.remove(i);
                i.destroy();
                break;
            }
        }
        updatePlacedIcons();
    }
    
    function updatePlacedIcons():Void{
        for(i in unitIconArray){
            i.updatePlaced(false);
            
            for(unit in placedUnits){
                if(i.unit == unit.unit){
                    i.updatePlaced(true);
                }
            }
        }
    }
    
	function updateSelectingText(text:String):Void
	{
		selectingText.text = text;
		CtUtil.centerSpriteOnSprite(selectingText, selectingTextBg, true, true);
		selectingTextBg.visible = true;
	}

	public function activate(?onComplete:Array<GridUnitPlacerInfo>->Void):Void
	{
		if (onComplete != null)
			this.onComplete = onComplete;
        
        FlxTween.tween(bg, {alpha: .85}, 0.5);
        
		FlxTween.tween(robin, {alpha: 1}, 0.5);
		robin.doAnim();

		FlxTween.tween(uiBg, {alpha: 1}, 0.5, {
			onComplete: function(f):Void
			{
				uiBgAnim.visible = true;
			}
		}); 
        
        FlxTween.tween(unitIcons, {alpha: 1}, 0.5); 

		FlxTween.tween(ghostUnitSprites, {alpha: 1}, 0.5); 

		for (button in topButtons)
		{
			FlxTween.tween(button, {alpha: 1}, 0.5);
		}

		FlxTween.tween(selectingText, {alpha: 1}, 0.5);

		FlxTween.tween(selectingTextBg, {alpha: .4}, 0.5);
        
        new FlxTimer().start(0.5, function(f):Void{
			if (!startedBefore)
			{
				startedBefore = true;
				selectingMenuManager.curRack = 1;
			}
            selectingMenuManager.enable(false);
        });
    }
    
	public function deactivate(?newOnComplete:Void->Void):Void
	{
        FlxTween.tween(bg, {alpha: 0}, 0.5);
        
		FlxTween.tween(robin, {alpha: 0}, 0.5);

        FlxTween.tween(uiBg, {alpha: 0}, 0.5); 
        
        FlxTween.tween(unitIcons, {alpha: 0}, 0.5); 

        FlxTween.tween(ghostUnitSprites, {alpha: 0}, 0.5); 

		FlxTween.tween(selectingText, {alpha: 0}, 0.5);

		FlxTween.tween(selectingTextBg, {alpha: 0}, 0.5);

		FlxTween.tween(uiBgAnim, {alpha: 0}, 0.5, {
			onComplete: function(F):Void
			{
				uiBgAnim.visible = false;
			}
		});

		for (button in topButtons)
		{
			FlxTween.tween(button, {alpha: 0}, 0.5);
		}

        new FlxTimer().start(0.5, function(f):Void{
			if (newOnComplete != null)
			{
				newOnComplete();
			}
			else
			{
				onComplete(placedUnits);
				destroy();   
			}
        });
    }
}
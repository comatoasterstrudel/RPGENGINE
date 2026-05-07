package battle;

class PlayState extends FlxState
{
	public static var battleName:String = "test";
	public static var battleData:BattleData;

	// BG STUFF
	var bgLine:CtSprite;

	// GRID STUFF
	var gridSize:FlxPoint = new FlxPoint();

	var allyGrid:Grid;
	var enemyGrid:Grid;

	var grids:Array<Grid> = [];
	
	var gridSelectorOptions:Array<Array<CtMenuOption>> = [];
	var gridSelectorSpaces:Array<GridSpace> = [];

	// UI STUFF
	var miniHealthBars:FlxTypedGroup<MiniHealthBar>;

	var turnOrderDisplay:TurnOrderDisplay;
	
	var bottomBar:BottomBar;
	
	// MENU MANAGERS
	var menuManagerPlayerUI:CtMenuManager;
	var menuManagerGridSelector:CtMenuManager;
	var menus:Array<CtMenuManager> = [];
	
	// GAME STUFF

	var units:Array<Unit> = [];
	
	var roundNum:Int = 0;
	var turnNum:Int = 0;
	var turnOrder:Array<Unit> = [];
	
	var currentTurnUnit:Unit;
	
	var uiStatus:UIStatus = INACTIVE;
	
	// EXIT
	var exitProgress:Float = 0;
	
	override public function create()
	{
		persistentUpdate = true;
		
		loadBattle();

		setUpBg();
		setUpGrids();
		setUpUI();
		addInitialUnits();

		setUpMenus();

		advanceRound();
		
		#if debug
		addDebugFunctions();
		#end
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		for (menu in menus)
		{
			menu.update();
		}
		if (FlxG.keys.pressed.ESCAPE)
		{
			exitProgress += elapsed;

			if (exitProgress >= Constants.exitTime)
			{
				FlxG.switchState(LevelSelectorState.new);
			}
		}
		else
		{
			exitProgress = 0;
		}
	}
	
	/**
	 * Call this to initialize this battles JSON file
	 */
	function loadBattle():Void
	{
		battleData = new BattleData(battleName);

		bgColor = FlxColor.GRAY;

		gridSize.set(battleData.gridSizeX, battleData.gridSizeY);
	}

	/**
	 * Call this to add the background sprites
	 */
	function setUpBg():Void
	{
		var sizing = Grid.calculateGridSize(gridSize);

		bgLine = new CtSprite().createColorBlock(FlxG.width, Std.int(sizing.y + Constants.gridSize), FlxColor.WHITE);
		bgLine.alpha = .6;
		bgLine.y = (FlxG.height / 2 - bgLine.height / 2) + Constants.uiYOffset;
		add(bgLine);
	}

	/**
	 * Call this to initialize the grids
	 */
	function setUpGrids():Void
	{
		var sizing = Grid.calculateGridSize(gridSize);
		var midPointX = FlxG.width / 2 - (sizing.x / 2);
		var midPointY = (bgLine.y + bgLine.height / 2) - (sizing.y / 2);
		var spacing:Float = sizing.x + 15;

		allyGrid = new Grid(gridSize, new FlxPoint(midPointX - (spacing), midPointY));
		add(allyGrid);

		enemyGrid = new Grid(gridSize, new FlxPoint(midPointX + (spacing), midPointY));
		add(enemyGrid);
		grids = [allyGrid, enemyGrid];
		updateGridSelectorOptions();
	}

	/**
	 * Call this to set up the UI needed for the game
	 */
	function setUpUI():Void
	{
		miniHealthBars = new FlxTypedGroup<MiniHealthBar>();
		add(miniHealthBars);
		turnOrderDisplay = new TurnOrderDisplay(gridSize);
		add(turnOrderDisplay);
		bottomBar = new BottomBar();
		add(bottomBar);
	}

	/**
	 * Call this to set up the different menus used for the games ui
	 */
	function setUpMenus():Void
	{
		// init menuManagerPlayerUI
		menuManagerPlayerUI = new CtMenuManager(CtControls.getInputFunction("right", JUSTPRESSED), CtControls.getInputFunction("left", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED),
			CtControls.getInputFunction("down", JUSTPRESSED), CtControls.getInputFunction("up", JUSTPRESSED));
		add(menuManagerPlayerUI.addCursor(new Cursor(Constants.cursorArrowGraphic), 20, false));
		// init menuManagerGridSelector
		menuManagerGridSelector = new CtMenuManager(CtControls.getInputFunction("right", JUSTPRESSED), CtControls.getInputFunction("left", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED),
			CtControls.getInputFunction("down", JUSTPRESSED), CtControls.getInputFunction("up", JUSTPRESSED));
		add(menuManagerGridSelector.addCursor(new Cursor(Constants.cursorArrowGraphic), 20, false));

		menus = [menuManagerPlayerUI, menuManagerGridSelector];
	}

	/**
	 * Call this to add the units listed in this battles JSON file to the field
	 */
	function addInitialUnits():Void
	{
		for (unit in battleData.allyUnits)
		{
			placeUnit(unit.id, allyGrid, unit.position, true);
		}
		for (unit in battleData.enemyUnits)
		{
			placeUnit(unit.id, enemyGrid, unit.position, false);
		}
	}
	
	/**
	 * Call this to place a unit down on the grid.
	 * @param unitID The id/name of the unit you want to place
	 * @param grid Which grid you want to place it on
	 * @param position Which position on the grid you want to place it on
	 * @param controllable Should this unit be controllable or not? basically is it an enemy or ally
	 */
	function placeUnit(unitID:String, grid:Grid, position:FlxPoint, controllable:Bool):Void
	{
		if (position.x >= gridSize.x || position.y >= gridSize.y)
		{
			FlxG.log.error("Can't place unit \"" + unitID + "\" at " + position.x + ", " + position.y + ". Out of bounds!");
			return;
		}
		
		if (Grid.getGridSpaceFromGrid(grid, position).unit != null)
		{
			FlxG.log.error("Can't place unit \"" + unitID + "\" at " + position.x + ", " + position.y + ". Occupied!");
			return;
		}
		
		var unit = new Unit(unitID, grid, position, controllable);
		add(unit);

		unit.doEntranceAnimation();

		grid.placeUnit(unit);

		units.push(unit);
		var miniHealthBar = new MiniHealthBar(unit);
		miniHealthBars.add(miniHealthBar);
	}

	/**
	 * Call this to advance the battle turn
	 * @param amount How many turns to advance by. Defaults to 1
	 */
	function advanceTurn(amount:Int = 1):Void
	{
		turnNum += amount;

		if (turnNum >= turnOrder.length)
		{
			advanceRound();
			return;
		}

		currentTurnUnit = turnOrder[turnNum];

		turnOrderDisplay.updateCurrentTurn(currentTurnUnit);
		bottomBar.updateCurrentUnit(currentTurnUnit);
		if (currentTurnUnit.controllable)
		{
			startAllyTurn();
		}
		else
		{
			startEnemyTurn();
		}
	}

	/**
	 * Call this to advance the battle round.
	 */
	function advanceRound():Void
	{
		roundNum++;

		calculateTurnOrder();

		turnNum = 0;

		advanceTurn(0);
	}

	/**
	 * Call this to start an ally units turn
	 */
	function startAllyTurn():Void
	{
		bottomBar.addMenu();

		var menuOptions:Array<Array<CtMenuOption>> = [[]];

		menuOptions[0].push({
			sprite: bottomBar.inspect,
			cursorDirection: UP,
			clickFunction: function(spr:FlxSprite):Void
			{
				menuManagerPlayerUI.disable(false);
				uiStatus = GRID_INSPECT;
				addGridSelector();
			},
			hoverFunction: function(spr:FlxSprite):Void
			{
				updateGridSelectorOptions();
			}
		});

		for (i in bottomBar.skillIcons)
		{
			if (i.enabled)
				menuOptions[0].push({
					sprite: i.outlineSprite,
					cursorDirection: UP,
					clickFunction: function(spr:FlxSprite):Void
					{
						if (uiStatus == SELECTING_SKILLS)
						{
							menuManagerPlayerUI.disable(false);
							uiStatus = GRID_SKILL;
							addGridSelector();
						}
						else if (uiStatus == GRID_SKILL)
						{ // use skill!!
							endPlayerTurn();
							advanceTurn();
						}
					},
					hoverFunction: function(spr:FlxSprite):Void
					{
						updateGridSelectorOptions(i.currentSkill.selectType);
					}
				});
		}

		menuOptions[0].push({
			sprite: bottomBar.endTurn,
			cursorDirection: UP,
			clickFunction: function(spr:FlxSprite):Void
			{
				endPlayerTurn();
				advanceTurn();
			},
			hoverFunction: function(spr:FlxSprite):Void
			{
				updateGridSelectorOptions();
			}
		});

		menuManagerPlayerUI.setMenuOptions(menuOptions);

		menuManagerPlayerUI.enable(true);
		menuManagerPlayerUI.changeSelection(1);
		uiStatus = SELECTING_SKILLS;
	}

	/**
	 * Call this when to end a player units turn
	 */
	function endPlayerTurn():Void
	{
		menuManagerPlayerUI.disable();
		uiStatus = INACTIVE;
	}

	/**
	 * Call this to start an enemy units turn
	 */
	function startEnemyTurn():Void
	{
		bottomBar.removeMenu();

		new FlxTimer().start(.5, function(f):Void
		{
			endEnemyTurn();
			advanceTurn();
		});
	}

	/**
	 * Call this when to end an enemy units turn
	 */
	function endEnemyTurn():Void
	{
		//
	}
	
	/**
	 * Call this to calculate and start the turn order for the next round
	 */
	function calculateTurnOrder():Void
	{
		turnOrder = [];

		for (unit in units)
		{
			turnOrder.push(unit);
		}

		ArraySort.sort(turnOrder, function(a, b)
		{
			if (a.speed.value < b.speed.value)
				return 1;
			if (a.speed.value > b.speed.value)
				return -1;
			return 0;
		});
		turnOrderDisplay.updateTurnOrderDisplay(turnOrder);
	}

	/**
	 * Call this to add the grid selector UI
	 */
	function addGridSelector():Void
	{
		menuManagerGridSelector.setMenuOptions(gridSelectorOptions);
		menuManagerGridSelector.enable();

		for (grid in grids)
		{
			for (space in grid.spaces)
			{
				if (gridSelectorSpaces.contains(space))
				{
					space.baseSprite.alpha = 1;
				}
				else
				{
					space.baseSprite.alpha = .5;
				}
			}
		}
	}

	/**
	 * Call this to remove the grid selector UI
	 */
	function removeGridSelector():Void
	{
		menuManagerGridSelector.disable();
		if (uiStatus == GRID_INSPECT || uiStatus == GRID_SKILL)
		{
			uiStatus = SELECTING_SKILLS;
			menuManagerPlayerUI.enable(false);
		}
		for (grid in grids)
		{
			for (space in grid.spaces)
			{
				space.baseSprite.alpha = 1;
			}
		}
	}

	/**
	 * Call this to adjust what grid spaces will be in the grid selector
	 * @param type 
	 */
	function updateGridSelectorOptions(type:String = ""):Void
	{
		gridSelectorSpaces = [];

		for (grid in grids)
		{
			for (space in grid.spaces)
			{
				if (switch (type)
					{
						case "ally_sameCollumn": (currentTurnUnit.grid == grid && space.position.y == currentTurnUnit.position.y);
						case "enemy_sameCollumn": (currentTurnUnit.grid != grid && space.position.y == currentTurnUnit.position.y);
						default: (true); // by default, add all spaces
					})
					gridSelectorSpaces.push(space);
			}
		}

		gridSelectorOptions = [];

		for (i in 0...Std.int(gridSize.y))
		{
			gridSelectorOptions.push([]);
		}

		for (space in gridSelectorSpaces)
		{
			gridSelectorOptions[Std.int(space.position.y)].push({
				sprite: space.baseSprite,
				cursorDirection: UP,
				cancelFunction: function(sprite):Void
				{
					removeGridSelector();
				}
			});
		}
		var i = gridSelectorOptions.length;

		while (i-- > 0)
		{
			if (gridSelectorOptions[i].length <= 0)
			{
				gridSelectorOptions.splice(i, 1);
			}
		}
	}

	#if debug
	function addDebugFunctions():Void
	{
		FlxG.console.registerFunction("advanceTurn", function()
		{
			advanceTurn(1);
		});
	}
	#end
}

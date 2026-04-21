package;

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
		var controlIncreaseRack = function():Bool
		{
			return FlxG.keys.justPressed.DOWN;
		};

		var controlDecreaseRack = function():Bool
		{
			return FlxG.keys.justPressed.UP;
		};

		var controlIncrease = function():Bool
		{
			return FlxG.keys.justPressed.RIGHT;
		};

		var controlDecrease = function():Bool
		{
			return FlxG.keys.justPressed.LEFT;
		};

		var controlSelect = function():Bool
		{
			return FlxG.keys.justPressed.Z;
		};

		var controlCancel = function():Bool
		{
			return FlxG.keys.justPressed.X;
		};

		// init menuManagerPlayerUI
		menuManagerPlayerUI = new CtMenuManager(controlIncrease, controlDecrease, controlSelect, controlCancel, controlIncreaseRack, controlDecreaseRack);
		add(menuManagerPlayerUI.addCursor(new Cursor(Constants.cursorArrowGraphic), 20, false));
		// init menuManagerGridSelector
		menuManagerGridSelector = new CtMenuManager(controlIncrease, controlDecrease, controlSelect, controlCancel, controlIncreaseRack, controlDecreaseRack);
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
			}
		});

		for (i in bottomBar.skillIcons)
		{
			if (i.enabled)
				menuOptions[0].push({sprite: i.outlineSprite, cursorDirection: UP});
		}

		menuOptions[0].push({
			sprite: bottomBar.endTurn,
			cursorDirection: UP,
			clickFunction: function(spr:FlxSprite):Void
			{
				endPlayerTurn();
				advanceTurn();
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
		var menuOptions:Array<Array<CtMenuOption>> = [];

		for (i in 0...Std.int(gridSize.y))
		{
			menuOptions.push([]);
		}
		for (grid in grids)
		{
			for (space in grid.spaces)
			{
				menuOptions[Std.int(space.position.y)].push({
					sprite: space.baseSprite,
					cursorDirection: UP,
					cancelFunction: function(sprite):Void
					{
						removeGridSelector();
					}
				});
			}
		}

		menuManagerGridSelector.setMenuOptions(menuOptions);
		menuManagerGridSelector.enable();
	}
	/**
	 * Call this to remove the grid selector UI
	 */
	function removeGridSelector():Void
	{
		menuManagerGridSelector.disable();
		if (uiStatus == GRID_INSPECT)
		{
			uiStatus = SELECTING_SKILLS;
			menuManagerPlayerUI.enable(false);
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

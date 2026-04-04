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

	// UI STUFF
	var miniHealthBars:FlxTypedGroup<MiniHealthBar>;

	var turnOrderDisplay:TurnOrderDisplay;
	
	var bottomBar:BottomBar;
	
	// GAME STUFF

	var units:Array<Unit> = [];
	
	var roundNum:Int = 0;
	var turnNum:Int = 0;
	var turnOrder:Array<Unit> = [];
	
	var currentTurnUnit:Unit;
	
	override public function create()
	{
		persistentUpdate = true;
		
		loadBattle();

		setUpBg();
		setUpGrids();
		setUpUI();

		addInitialUnits();
		
		advanceRound();
		
		#if debug
		addDebugFunctions();
		#end
		
		super.create();
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

		if (amount >= turnOrder.length)
		{
			advanceRound();
			return;
		}
		currentTurnUnit = turnOrder[turnNum];

		turnOrderDisplay.updateCurrentTurn(currentTurnUnit);
		bottomBar.updateCurrentUnit(currentTurnUnit);
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
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
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

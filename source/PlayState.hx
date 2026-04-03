package;

class PlayState extends FlxState
{
	public static var battleName:String = "test";
	public static var battleData:BattleData;

	var gridSize:FlxPoint = new FlxPoint();

	var bgLine:CtSprite;

	var allyGrid:Grid;
	var enemyGrid:Grid;

	var units:Array<Unit> = [];
	
	override public function create()
	{
		loadBattle();

		setUpBg();
		setUpGrids();

		addInitialUnits();
		
		super.create();
	}

	function loadBattle():Void
	{
		battleData = new BattleData(battleName);

		bgColor = FlxColor.GRAY;

		gridSize.set(battleData.gridSizeX, battleData.gridSizeY);
	}

	function setUpBg():Void
	{
		var sizing = Grid.calculateGridSize(gridSize);

		bgLine = new CtSprite().createColorBlock(FlxG.width, Std.int(sizing.y + Constants.gridSize), FlxColor.WHITE);
		bgLine.alpha = .6;
		bgLine.screenCenter(Y);
		add(bgLine);
	}

	function setUpGrids():Void
	{
		var sizing = Grid.calculateGridSize(gridSize);
		var midPointX = FlxG.width / 2 - (sizing.x / 2);
		var midPointY = FlxG.height / 2 - (sizing.y / 2);
		var spacing:Float = sizing.x + 15;

		allyGrid = new Grid(gridSize, new FlxPoint(midPointX - (spacing), midPointY));
		add(allyGrid);

		enemyGrid = new Grid(gridSize, new FlxPoint(midPointX + (spacing), midPointY));
		add(enemyGrid);
	}

	function addInitialUnits():Void
	{
		for (unit in battleData.allyUnits)
		{
			placeUnit(unit.id, allyGrid, unit.position);
		}
		for (unit in battleData.enemyUnits)
		{
			placeUnit(unit.id, enemyGrid, unit.position);
		}
	}
	
	function placeUnit(unitID:String, grid:Grid, position:FlxPoint):Void
	{
		if (position.x >= gridSize.x || position.y >= gridSize.y)
		{
			FlxG.log.error("Can't place unit \"" + unitID + "\" at " + position.x + ", " + position.y + ". Out of bounds!");
			return;
		}
		
		var unit = new Unit(unitID, grid, position);
		add(unit);

		grid.placeUnit(unit);

		units.push(unit);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

package;

class PlayState extends FlxState
{
	final gridSize = new FlxPoint(3, 3);

	var bgLine:CtSprite;

	var allyGrid:Grid;
	var enemyGrid:Grid;

	var units:Array<Unit> = [];
	
	override public function create()
	{
		bgColor = FlxColor.GRAY;

		setUpBg();
		setUpGrids();

		// placeholder way to add units to the grids
		placeUnit("unit name", allyGrid, new FlxPoint(2, 1));
		placeUnit("unit name 2", allyGrid, new FlxPoint(0, 0));
		placeUnit("unit name 3", enemyGrid, new FlxPoint(1, 1));

		super.create();
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

	function placeUnit(unitID:String, grid:Grid, position:FlxPoint):Void
	{
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

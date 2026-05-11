package battle;

class PlayState extends FlxState
{
	public static var eventManager:EventManager;
	
	public static var battleName:String = "test";
	public static var battleData:BattleData;

	// CAMERAS
	var camGame:FlxCamera;
	var camUI:FlxCamera;
	
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
	
	var damageTexts:FlxTypedGroup<DamageText>;

	public var damageTextSignal = new FlxTypedSignal<Unit->String->FlxColor->Void>();
	
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
		
		eventManager = new EventManager();
		eventManager.reset();
		
		loadBattle();

		setupCameras();
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
		removeUnusedDamageTexts();
		
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
		eventManager.update();
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
	 * call this to add the flxcameras that the game uses hehehe
	 */
	function setupCameras():Void
	{
		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;
		FlxG.cameras.add(camGame, true);

		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;
		FlxG.cameras.add(camUI, false);
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
		bgLine.camera = camGame;
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
		allyGrid.camera = camGame;
		add(allyGrid);

		enemyGrid = new Grid(gridSize, new FlxPoint(midPointX + (spacing), midPointY));
		enemyGrid.camera = camGame;
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
		miniHealthBars.camera = camUI;
		add(miniHealthBars);
		turnOrderDisplay = new TurnOrderDisplay(gridSize);
		turnOrderDisplay.camera = camUI;
		add(turnOrderDisplay);
		bottomBar = new BottomBar();
		bottomBar.camera = camUI;
		add(bottomBar);
		damageTexts = new FlxTypedGroup<DamageText>();
		damageTexts.camera = camUI;
		add(damageTexts);
		damageTextSignal.add(function(unit:Unit, text:String, color:FlxColor)
		{
			damageTexts.add(new DamageText(unit, text, color));
		});
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
		add(menuManagerPlayerUI.addCursor(menuMakeCursor(), 20, false));
		// init menuManagerGridSelector
		menuManagerGridSelector = new CtMenuManager(CtControls.getInputFunction("right", JUSTPRESSED), CtControls.getInputFunction("left", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED),
			CtControls.getInputFunction("down", JUSTPRESSED), CtControls.getInputFunction("up", JUSTPRESSED));
		add(menuManagerGridSelector.addCursor(menuMakeCursor(), 20, false));

		menus = [menuManagerPlayerUI, menuManagerGridSelector];
	}

	function menuMakeCursor():Cursor
	{
		var cursor = new Cursor(Constants.cursorArrowGraphic);
		cursor.camera = camUI;
		return cursor;
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
		unit.camera = camGame;
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
				for (grid in grids)
				{
					grid.updateFlashingSprites([]);
				}
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
						menuManagerPlayerUI.disable(false);
						new FlxTimer().start(0.01, function(f):Void // jank
						{
							uiStatus = GRID_SKILL;
							addGridSelector();		
						});
					},
					hoverFunction: function(spr:FlxSprite):Void
					{
						for (grid in grids)
						{
							grid.updateFlashingSprites([]);
						}
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
				for (grid in grids)
				{
					grid.updateFlashingSprites([]);
				}
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
	 * call this to use a skill!!!!
	 * @param skillData which skill to use
	 * @param unit which unit is using the skill
	 * @param grid which grid
	 * @param position where on the grid its being used
	 */
	function useSkill(skillData:SkillData, unit:Unit, grid:Grid, position:FlxPoint, ?onFinish:Void->Void):Void
	{
		var affectedSpaces = getAffectedSpacesForSkill(skillData, unit, grid, position);
		
		eventManager.addEvent(function():Void
		{
			for (space in affectedSpaces)
			{
				if (space.unit != null)
				{ // this has a unit on it !!!
					if (skillData.eff_damage > 0)
					{
						space.unit.takeDamage(skillData.eff_damage);
					}
					if (skillData.eff_heal > 0)
					{
						space.unit.heal(skillData.eff_heal);
					}
				}
			}
		});
		if (onFinish != null)
		{
			eventManager.addEvent(function():Void
			{
				onFinish();
			});
		}
	}
	
	function getAffectedSpacesForSkill(skillData:SkillData, unit:Unit, grid:Grid, position:FlxPoint)
	{
		var affectedSpaces:Array<GridSpace> = [];
		if (skillData.eff_rangeX >= 1 && skillData.eff_rangeY >= 1)
		{
			affectedSpaces.push(Grid.getGridSpaceFromGrid(grid, position));

			for (i in 0...skillData.eff_rangeX)
			{
				var gridSpaceXNeg = Grid.getGridSpaceFromGrid(grid, new FlxPoint(affectedSpaces[0].position.x - i, affectedSpaces[0].position.y));

				if (gridSpaceXNeg != null)
				{
					if (!affectedSpaces.contains(gridSpaceXNeg))
						affectedSpaces.push(gridSpaceXNeg);
				}

				var gridSpaceXPos = Grid.getGridSpaceFromGrid(grid, new FlxPoint(affectedSpaces[0].position.x + i, affectedSpaces[0].position.y));
				if (gridSpaceXPos != null)
				{
					if (!affectedSpaces.contains(gridSpaceXPos))
						affectedSpaces.push(gridSpaceXPos);
				}
			}

			for (i in 0...skillData.eff_rangeY)
			{
				var gridSpaceYNeg = Grid.getGridSpaceFromGrid(grid, new FlxPoint(affectedSpaces[0].position.x, affectedSpaces[0].position.y - i));

				if (gridSpaceYNeg != null)
				{
					if (!affectedSpaces.contains(gridSpaceYNeg))
						affectedSpaces.push(gridSpaceYNeg);
				}

				var gridSpaceYPos = Grid.getGridSpaceFromGrid(grid, new FlxPoint(affectedSpaces[0].position.x, affectedSpaces[0].position.y + i));
				if (gridSpaceYPos != null)
				{
					if (!affectedSpaces.contains(gridSpaceYPos))
						affectedSpaces.push(gridSpaceYPos);
				}
			}
		}
		return affectedSpaces;
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
					space.baseSprite.alpha = .2;
				}
			}
		}
	}

	/**
	 * Call this to remove the grid selector UI
	 */
	function removeGridSelector():Void
	{
		for (grid in grids)
		{
			grid.updateFlashingSprites([]);
		}
		
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
						case "ally_sameRow": (currentTurnUnit.grid == grid
								&& space.position.y == currentTurnUnit.position.y); // all allies in the same row as the current unit
						case "enemy_sameRow": (currentTurnUnit.grid != grid
								&& space.position.y == currentTurnUnit.position.y); // all enemies in the same row as the current unit
						case "ally_sameCollumn": (currentTurnUnit.grid == grid
								&& space.position.x == currentTurnUnit.position.x); // all allies in the same collumn as the current unit
						case "enemy_sameCollumn": (currentTurnUnit.grid != grid
								&& space.position.x == currentTurnUnit.position.x); // all enemies in the same commumn as the current unit
						case "ally_all": (currentTurnUnit.grid == grid); // all allies
						case "enemy_all": (currentTurnUnit.grid != grid); // all enemies
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
				clickFunction: function(sprite):Void
				{
					if (uiStatus == GRID_SKILL)
					{
						uiStatus = INACTIVE;
						removeGridSelector();

						useSkill(currentTurnUnit.skills[menuManagerPlayerUI.curSelected - 1], currentTurnUnit, space.grid,
							new FlxPoint(space.position.x, space.position.y), function():Void
						{
							endPlayerTurn();
							advanceTurn();
						});
					}
				},
				cancelFunction: function(sprite):Void
				{
					removeGridSelector();
				},
				hoverFunction: function(sprite):Void
				{
					if (uiStatus == GRID_SKILL)
					{
						space.grid.updateFlashingSprites(getAffectedSpacesForSkill(currentTurnUnit.skills[menuManagerPlayerUI.curSelected - 1],
							currentTurnUnit, space.grid, new FlxPoint(space.position.x, space.position.y)));
					}
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

	/**
	 * Call this to clear up damage texts that are off screen
	 */
	function removeUnusedDamageTexts():Void
	{
		var removeThese:Array<DamageText> = [];

		for (text in damageTexts.members)
		{
			if (text.y > FlxG.height)
			{
				removeThese.push(text);
			}
		}

		for (text in removeThese)
		{
			damageTexts.remove(text, true);
			text.destroy();
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

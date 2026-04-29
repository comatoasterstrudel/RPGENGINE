package levelselector;

/**
 * The main menu of the game I guess
 * You can select levels here!!!!
 */
class LevelSelectorState extends FlxState
{
	/**
	 * This is the list of battle files that this menu is displaying
	 */
    var listOfBattleFiles:Array<BattleData> = [];
    
	/**
	 * The list of text objects for this menu
	 */
    var textOptions:Array<FlxText> = [];
    
	/**
	 * The menu manager for this menu
	 */
    var menuManager:CtMenuManager;
    
	/**
	 * The last value that was selected
	 */
	public static var savedCurSelected:Int = 0;
	
    override function create():Void{
        bgColor = FlxColor.WHITE;
        
        setUpMenu();
                
        populateMenuOptions();
        
        super.create();
    }
    
    override function update(elapsed:Float):Void{
        if(FlxG.keys.justPressed.R){
			updateSavedCurSelected();
            populateMenuOptions();
        }
        
        menuManager.update();
        
        super.update(elapsed);
    }
    
	/**
	 * Call this to set up the MenuManager. in a seperate function for tidiness
	 */
    function setUpMenu():Void{
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
        
        menuManager = new CtMenuManager(controlIncrease, controlDecrease, controlSelect, controlCancel, controlIncreaseRack, controlDecreaseRack);
        add(menuManager.addCursor(new Cursor(Constants.cursorArrowGraphic), 20, false));
    }
    
	/**
	 * Call this to reset and populate the menu options!! Can be reloaded at runtime
	 */
    function populateMenuOptions():Void{
        listOfBattleFiles = [];
        
        for(battle in CtUtil.stripTextFromStrings(CtUtil.findFilesInPath(Constants.battleDataFolder, [".json"], false, false), ["battle_", ".json"])){
            listOfBattleFiles.push(new BattleData(battle));
        }
                
        textOptions = cast CtUtil.destroyArrayOfSprites(cast textOptions);
        
        var menuOptions:Array<Array<CtMenuOption>> = [];
        
		if (listOfBattleFiles.length == 0)
		{
			var text = new FlxText(Constants.levelSelectTextXPos, Constants.levelSelectTextYPos, Constants.levelSelectNoLevelMessage);
			text.color = FlxColor.GRAY;
			text.size = Constants.levelSelectTextSize;
			add(text);
			textOptions.push(text);

			menuOptions.push([{sprite: text, cursorDirection: LEFT}]);
		}
		else
		{
			for (i in 0...listOfBattleFiles.length)
			{
				var battle = listOfBattleFiles[i];

				var text = new FlxText(Constants.levelSelectTextXPos, Constants.levelSelectTextYPos + (Constants.levelSelectTextYSpacing * i), battle.id);
				text.color = FlxColor.BLACK;
				text.size = Constants.levelSelectTextSize;
				add(text);
				textOptions.push(text);

				menuOptions.push([
					{
						sprite: text,
						cursorDirection: LEFT,
						clickFunction: function(sprite):Void
						{
							updateSavedCurSelected();

							PlayState.battleName = battle.id;
							FlxG.switchState(PlayState.new);
						}
					}
				]);
			}   
        }
        
        menuManager.setMenuOptions(menuOptions);
		menuManager.curRack = savedCurSelected;
        menuManager.enable();
    }
	/**
	 * Call this to set savedCurSelected to menuManger.curRack
	 */
	function updateSavedCurSelected():Void
	{
		savedCurSelected = menuManager.curRack;
	}
}
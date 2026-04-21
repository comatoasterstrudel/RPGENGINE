package levelselector;

/**
 * The main menu of the game I guess
 * You can select levels here!!!!
 */
class LevelSelectorState extends FlxState
{
    var listOfBattleFiles:Array<BattleData> = [];
    
    var textOptions:Array<FlxText> = [];
    
    var menuManager:CtMenuManager;
    
    override function create():Void{
        bgColor = FlxColor.WHITE;
        
        setUpMenu();
                
        populateMenuOptions();
        
        super.create();
    }
    
    override function update(elapsed:Float):Void{
        if(FlxG.keys.justPressed.R){
            populateMenuOptions();
        }
        
        menuManager.update();
        
        super.update(elapsed);
    }
    
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
    
    function populateMenuOptions():Void{
        listOfBattleFiles = [];
        
        for(battle in CtUtil.stripTextFromStrings(CtUtil.findFilesInPath(Constants.battleDataFolder, [".json"], false, false), ["battle_", ".json"])){
            listOfBattleFiles.push(new BattleData(battle));
        }
                
        textOptions = cast CtUtil.destroyArrayOfSprites(cast textOptions);
        
        var menuOptions:Array<Array<CtMenuOption>> = [];
        
        for(i in 0...listOfBattleFiles.length){
            var battle = listOfBattleFiles[i];
            
            var text = new FlxText(70, 30 + (80 * i), battle.id);
            text.color = FlxColor.BLACK;
            text.size = 30;
            add(text);
            textOptions.push(text);
            
            menuOptions.push([{sprite: text, cursorDirection: LEFT, clickFunction: function(sprite):Void{
                PlayState.battleName = battle.id;
                FlxG.switchState(PlayState.new);
            }}]);
        }
        
        menuManager.setMenuOptions(menuOptions);
        menuManager.enable();
    }
}
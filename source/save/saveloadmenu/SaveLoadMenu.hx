package save.saveloadmenu;

class SaveLoadMenu extends FlxSubState
{
    var camUI:FlxCamera;
    var camFade:FlxCamera;
    
    var bg:CtSprite;
    var saveWindow:CtSprite;
    
    var rows:Array<SaveLoadMenuRow> = [];
    var saveWindowArrow:CtSprite;
    
    var topText:CtText;
    
    var type:SaveLoadMenuType;
    
    var menuManager:CtMenuManager;
    var cursor:Cursor;
    
    public function new(type:SaveLoadMenuType, ?onComplete:Void->Void, ?onExit:Void->Void):Void{
        super();
        
        this.type = type;
        
        setupCameras();        
                
        setUpMenu();
        
        doTransition(function():Void{
            setupUI();
        }, function():Void{
            menuManager.enable();
        });
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        menuManager.update();  
        
        trace(cursor.x + ' ' + cursor.y);
    }
    
    /**
	 * Call this to set up the MenuManager. in a seperate function for tidiness
	 */
	function setUpMenu():Void
	{
		menuManager = new CtMenuManager(CtControls.getInputFunction("right", JUSTPRESSED), CtControls.getInputFunction("left", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED),
			CtControls.getInputFunction("down", JUSTPRESSED), CtControls.getInputFunction("up", JUSTPRESSED));
		cursor = new Cursor(Constants.cursorArrowGraphic);
        cursor.camera = camUI;
	}
    
    function setupCameras():Void{
        camUI = new FlxCamera();
        camUI.bgColor.alpha = 0;
        FlxG.cameras.add(camUI, false);
        
        camFade = new FlxCamera();
        camFade.bgColor.alpha = 0;
        FlxG.cameras.add(camFade, false);
    }
    
    function setupUI():Void{
        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, 0xFF383B4B);
        bg.camera = camUI;
        add(bg);
        
        saveWindow = new CtSprite().createFromImage(Constants.saveLoadMenuSaveWindowGraphicPath);
        saveWindow.camera = camUI;
        saveWindow.screenCenter(Y);
        saveWindow.x = FlxG.width - saveWindow.width;
        saveWindow.antialiasing = false;
        add(saveWindow);   
        
        saveWindowArrow = new CtSprite(600, 40).createFromImage(Constants.saveLoadMenuSaveWindowArrowGraphicPath);
        saveWindowArrow.camera = camUI;
        saveWindowArrow.antialiasing = false;
        add(saveWindowArrow);
        
        topText = new CtText(saveWindow.x + 430, saveWindow.y + 70, "", FlxAssets.FONT_DEFAULT, 30);
        topText.color = FlxColor.BLACK;
        topText.text = switch(type){
            case NEWGAME: "//  NEW";
            case CONTINUE: "//  CONTINUE";
            case ERASE: "//  ERASE";
            case SAVE: "//  SAVE";
        };
        topText.camera = camUI;
        add(topText);
        
        var menuOptions:Array<Array<CtMenuOption>> = [];
        var startNum:Int = 0;
        
        if(type == CONTINUE){
            menuOptions.push([{sprite: saveWindowArrow, cursorDirection: LEFT}]);
            startNum = 1;
        } else {
            saveWindowArrow.alpha = .25;
        }
        
        var baseY:Float = saveWindow.y + 150;
        
        for(i in 0...Constants.maxSaveFiles + 1){
            var row = new SaveLoadMenuRow(saveWindow, baseY + (190 * i), i, (i != Constants.maxSaveFiles));
            row.camera = camUI;
            rows.push(row);
            add(row);    
            
            menuOptions.push([{sprite: row.callIcon, cursorDirection: LEFT}]);
        }
        
        add(menuManager.addCursor(cursor, 50, false));
        menuManager.setMenuOptions(menuOptions);
        menuManager.curRack = startNum;
    }
    
    function doTransition(?step1:Void->Void, ?step2:Void->Void):Void{
        var tranSpr = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        tranSpr.camera = camFade;
        tranSpr.alpha = 0;
        add(tranSpr);
        
        FlxTween.tween(tranSpr, {alpha: 1}, .25, {onComplete: function(f):Void{
            if(step1 != null) step1();
            
                FlxTween.tween(tranSpr, {alpha: 0}, .25, {onComplete: function(f):Void{
                    tranSpr.destroy();
                    if(step2 != null) step2();
                }});
        }});
    }
}
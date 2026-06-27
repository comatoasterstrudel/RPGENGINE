package mainmenu;

class MainMenuState extends FlxState
{
	var texts:FlxTypedGroup<CtText>;

	var menuManager:CtMenuManager;
	var cursor:Cursor;
	var menuOptions:Array<Array<CtMenuOption>> = [];

	var logo:CtSprite;
    
    override function create():Void{
        super.create();
        
		setUpMenu();

		addTexts();

		logo = new CtSprite(30, 40).createFromImage(Constants.mainMenuLogoPath);
		add(logo);
        
        bgColor = 0xFF1E1C28;
    }
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		menuManager.update();
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
		add(menuManager.addCursor(cursor, 20, false));

		texts = new FlxTypedGroup<CtText>();
		add(texts);
	}

	function addTexts():Void
	{
		clearMenuOptions();

		addOption("New Call", function():Void
		{
			menuManager.disable();

			openSubState(new SaveLoadMenu(NEWGAME, null, function():Void
			{
				menuManager.enable();
			}));
		});

		var allowContinue:Bool = Save.isAnySaveStarted();

		var continueText:CtText = addOption("Continue Call", function():Void
		{
			if (allowContinue)
			{
				menuManager.disable();

				openSubState(new SaveLoadMenu(CONTINUE, null, function():Void
				{
					menuManager.enable();
				}));
			}
			else
			{
				//
			}
		});

		var eraseText:CtText = addOption("Erase Call", function():Void
		{
			if (allowContinue)
			{
				menuManager.disable();

				openSubState(new SaveLoadMenu(ERASE, function():Void
				{
					FlxG.camera.shake(0.05, 0.1, null, true, X);
					menuManager.enable();
				}, function():Void
				{
					menuManager.enable();
				}));
			}
			else
			{
				//
			}
		});

		if (!allowContinue)
		{
			continueText.alpha = .25;
			eraseText.alpha = .25;
		}

		addOption("Quit", function():Void
		{
			Sys.exit(1);
		});

		menuManager.setMenuOptions(menuOptions);

		menuManager.enable();
	}

	function addOption(text:String, onClick:Void->Void):CtText
	{
		var text = new CtText(110, Constants.mainMenuStartingY + (50 * texts.members.length), text, FlxAssets.FONT_DEFAULT, 30);
		texts.add(text);

		menuOptions.push([
			{
				sprite: text,
				clickFunction: function(f):Void
				{
					onClick();
				},
				cursorDirection: LEFT
			}
		]);
		return text;
	}

	function clearMenuOptions():Void
	{
		var destroyThese:Array<CtText> = [];

		for (text in texts.members)
		{
			destroyThese.push(text);
		}

		texts.clear();

		for (i in destroyThese)
		{
			i.destroy();
		}

		menuOptions = [];
		menuManager.disable();
	}
}
package ctUtil.menu;

/**
 * Class for managing menus easily, with reusable and flexible code.
 */
class CtMenuManager
{
	/**
	 * The list of menuOptions this menu has
	 */
	var menuOptions:Array<Array<CtMenuOption>>;
    
	/**
	 * The function used to check when to increase the selected value.
	 */
    var increaseFunction:Void->Bool;
    
	/**
	 * The function used to check when to increase the selected value.
	 */
    var decreaseFunction:Void->Bool;
    
	/**
	 * The function used to check when to select the currently selected option
	 */
    var selectFunction:Void->Bool;
    
	/**
	 * OPTIONAL; The function used to increase the selected rack
	 */
	var increaseRackFunction:Void->Bool;

	/**
	 * OPTIONAL; The function used to decrease the selected rack
	 */
	var decreaseRackFunction:Void->Bool;
    
	/**
	 * Is this menu currently enabled?
	 */
    var enabled:Bool = false;
    
	var curRack:Int = 0;
    
	/**
	 * Which option is currently selected
	 */
    var curSelected:Int = 0;
    
	/**
	 * The cursor sprite for this menu. If this is null, the cursor simply wont be used.
	 */
    var cursor:CtSprite;
    
	/**
	 * How far the cursor will be spaced from the option its tied to.
	 */
    var cursorSpacing:Float;
    
	/**
	 * Should the cursor use the build in lerping in CtSprite?
	 */
    var cursorDoLerp:Bool;
    
	/**
	 * Call this to initialize the menu or change the options it has.
	 * @param menuOptions The list of menuOptions this menu has
	 * @param increaseFunction The function used to check when to increase the selected value.
	 * @param decreaseFunction The function used to check when to increase the selected value.
	 * @param selectFunction The function used to check when to select the currently selected option
	 * @param increaseRackFunction OPTIONAL; The function used to increase the selected rack
	 * @param decreaseRackFunction OPTIONAL; The function used to decrease the selected rack
	 */
	public function new(increaseFunction:Void->Bool, decreaseFunction:Void->Bool, selectFunction:Void->Bool, ?increaseRackFunction:Void->Bool,
			?decreaseRackFunction:Void->Bool)
	{        
        this.increaseFunction = increaseFunction;
        this.decreaseFunction = decreaseFunction;
		this.selectFunction = selectFunction;        
		this.increaseRackFunction = increaseRackFunction;
		this.decreaseRackFunction = decreaseRackFunction;

		resetSelected();
    }
    
	/**
	 * Call this every frame
	 */
    public function update():Void{
        if(!enabled) return;
        
		var doRackIncrease:Bool = increaseRackFunction != null ? increaseRackFunction() : false;
		var doRackDecrease:Bool = decreaseRackFunction != null ? decreaseRackFunction() : false;

		if (doRackIncrease && !doRackDecrease)
		{
			changeRack(1);
		}
		else if (!doRackIncrease && doRackDecrease)
		{
			changeRack(-1);
		}
        
        var doIncrease:Bool = increaseFunction();
        var doDecrease:Bool = decreaseFunction();
        
        if(doIncrease && !doDecrease){
            changeSelection(1);
        } else if(!doIncrease && doDecrease){
            changeSelection(-1);
        }
        
        if(selectFunction()) makeSelection();        
    }
    
	/**
	 * Call this to change which rack is selected!!
	 * @param amount How many selections to move
	 */
	function changeRack(amount:Int = 0):Void
	{
		curRack += amount;

		if (curRack >= menuOptions.length)
		{
			curRack = 0;
		}
		else if (curRack < 0)
		{
			curRack = menuOptions.length - 1;
		}

		changeSelection();
	}
    
	/**
	 * Call this to change which menu option is selected!!
	 * @param amount How many selections to move
	 */
    function changeSelection(amount:Int = 0):Void{
        curSelected += amount;
        
		if (curSelected >= menuOptions[curRack].length)
		{
            curSelected = 0;
        } else if(curSelected < 0){
			curSelected = menuOptions[curRack].length - 1;
        }

		for (rack in 0...menuOptions.length)
		{
			for (i in 0...menuOptions[curRack].length)
			{
				var option = menuOptions[rack][i];
                
				if ((curRack != rack || curSelected != i) && option.nonHoverFunction != null)
				{
					option.nonHoverFunction(option.sprite);
				}
				else if (curRack == rack && curSelected == i)
				{
					if (option.hoverFunction != null)
						option.hoverFunction(option.sprite);

					updateCursorWithOption(option);
				}
			}
		}
	}

	/**
	 * Call this when the player presses the accept button
	 */
    function makeSelection():Void{
		var option = menuOptions[curRack][curSelected];
        
        if(option.clickFunction != null) option.clickFunction(option.sprite);
    }
    
	/**
	 * Call this to set the options for this menu.
	 * @param menuOptions Which options the menu should have.
	 * @param reset Should this menu reset the currently selected option to 0?
	 */
	public function setMenuOptions(menuOptions:Array<Array<CtMenuOption>>, ?reset:Bool = false):Void
	{
		this.menuOptions = menuOptions;
		if (reset)
			resetSelected();
		if (enabled)
		{
			changeRack();
			changeSelection();
		}
	}

	/**
	 * Call this to enable this menu
	 * @param reset Should this menu reset the currently selected option to 0?
	 */
    public function enable(?reset:Bool = false):Void{
		if (menuOptions.length < 1)
		{
			FlxG.log.error("Can't enable menu without options!! Run setMenuOptions() first!");
			enabled = false;
			return;
		}
        enabled = true;
        if(cursor != null) cursor.revive();
		if (reset)
			resetSelected();
		changeRack();
        changeSelection();
    }
    
	/**
	 * Call this to disable this menu
	 * @param reset Should this menu reset the currently selected option to 0?
	 */
    public function disable(?reset:Bool = false):Void{
        enabled = false;
        if(cursor != null) cursor.kill();
		if (reset)
			resetSelected();
	}

	/**
	 * Call this to reset the currently selected option and rack
	 */
	function resetSelected():Void
	{
		curRack = 0;
		curSelected = 0;
    }
    
	/**
	 * Call this to add a cursor to this menu
	 * @param cursor The CtSprite you want to use as a cursor
	 * @param cursorSpacing How far the cursor will be spaced from the option its tied to. 
	 * @param cursorDoLerp Should the cursor use the build in lerping in CtSprite?
	 * @return The cursor used
	 */
    public function addCursor(cursor:CtSprite, cursorSpacing:Float, ?cursorDoLerp:Bool = false):FlxSprite{
        this.cursor = cursor;
        this.cursorSpacing = cursorSpacing;
        this.cursorDoLerp = cursorDoLerp;
        return cursor;
    }
	/**
	 * Call this to move the cursor to an option, if the cursor isn't null
	 * @param option The option the cursor should move to
	 */
	function updateCursorWithOption(option:CtMenuOption):Void
	{
		if (cursor != null && option.cursorDirection != null)
		{
			cursor.revive();
			var pos = new FlxPoint();
			switch (option.cursorDirection)
			{
				case LEFT:
					pos.set(option.sprite.x - cursor.width - cursorSpacing, option.sprite.y + option.sprite.height / 2 - cursor.height / 2);
				case RIGHT:
					pos.set(option.sprite.x + option.sprite.width + cursorSpacing, option.sprite.y + option.sprite.height / 2 - cursor.height / 2);
				case DOWN:
					pos.set(option.sprite.x + option.sprite.width / 2 - cursor.width / 2, option.sprite.y + option.sprite.height + cursorSpacing);
				case UP:
					pos.set(option.sprite.x + option.sprite.width / 2 - cursor.width / 2, option.sprite.y - cursor.height - cursorSpacing);
			}
			if (cursorDoLerp)
			{
				cursor.lerpManager.targetPosition.set(pos.x, pos.y);
			}
			else
			{
				cursor.setPosition(pos.x, pos.y);
			}
		}
		else if (cursor != null && option.cursorDirection == null)
		{
			cursor.kill();
			FlxG.log.error("Menu option has no cursor direction listed. Cursor will be killed.");
		}
	}
}
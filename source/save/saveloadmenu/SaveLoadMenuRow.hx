package save.saveloadmenu;

class SaveLoadMenuRow extends FlxSpriteGroup{
    var saveWindow:CtSprite;
    
    public var callIcon:CtSprite;
    
    var divider:CtSprite;
        
	var roomText:CtText;

	public function new(saveWindow:CtSprite, y:Float, saveID:Int, addDivider:Bool, enabled:Bool):Void
	{
        super();
    
        this.saveWindow = saveWindow;
        
		var started = Save.isSaveStarted(saveID);
		var save = new FlxSave();
		save.bind(Constants.saveFileName + saveID);

		callIcon = new CtSprite().createFromImage(started ? Constants.saveLoadMenuCallIconGraphicPath : Constants.saveLoadMenuCallIconNotStartedGraphicPath,
			.7);
        callIcon.setPosition(saveWindow.x + 30, y + 20);
        callIcon.antialiasing = false;
        add(callIcon);
        
        if(addDivider){
            divider = new CtSprite().createFromImage(Constants.saveLoadMenuDividerGraphicPath);
            CtUtil.centerSpriteOnSprite(divider, saveWindow, true, false);
            divider.y = y + 160;
            divider.antialiasing = false;
            add(divider);
		}     
		roomText = new CtText(10, 10, "sd", FlxAssets.FONT_DEFAULT, 20, false);
		roomText.x = callIcon.x + callIcon.width + 20;
		roomText.color = FlxColor.BLACK;
		roomText.text = "File " + (saveID + 1);

		if (started)
		{
			var roomData = new RoomData(save.data.roomName);

			var roomName = roomData.name;
			roomText.text += ("\n" + roomName);
		}
		else
		{
			roomText.text += ("\n(Not Started)");
		}

		CtUtil.centerSpriteOnSprite(roomText, callIcon, false, true);
		add(roomText);

		if (!enabled)
		{
			callIcon.alpha = .4;
			roomText.alpha = .4;
		}
    }
}
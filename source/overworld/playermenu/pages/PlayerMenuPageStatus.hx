package overworld.playermenu.pages;

class PlayerMenuPageStatus extends PlayerMenuPage
{
	var nameplate:CtSprite;
	var statusText:CtText;
	var robinAura:CtSprite;
	var biggerText:CtText;
    
    public function new(playerMenu:PlayerMenu):Void{
        super(playerMenu, "status");
        makeBg(450, 500);
		robinAura = new CtSprite().createFromImage(Constants.playerMenuStatusRobinAuraPath);
		add(robinAura);
		nameplate = new CtSprite().createFromImage(Constants.playerMenuStatusNamePlatePath);
		add(nameplate);
		statusText = new CtText(0, 0, "(STATUS)");
		statusText.setFormat(Constants.fontName, 30, FlxColor.BLACK);
		add(statusText);
		biggerText = new CtText(0, 0, "");
		biggerText.setFormat(Constants.fontName, 40, FlxColor.BLACK);
		add(biggerText);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(CtControls.checkInput("cancel", JUSTPRESSED)){
            playerMenu.removePage("status");
        }        
		configText();
    }

    override function openPage(xPos:Int):Void{
        super.openPage(xPos); 
		nameplate.setPosition(bg.bgCenter.x + 10, bg.bgCenter.y + 10);
		statusText.setPosition(nameplate.x + nameplate.width + 20, nameplate.y + nameplate.height - statusText.height);
		robinAura.setPosition((bg.bgCenter.x + bg.bgCenter.width - robinAura.width) + 20, (bg.bgCenter.y + bg.bgCenter.height - robinAura.height) + 30);
		configText();
    }
    
    override function setActivePage():Void{
        super.setActivePage();        
    }
    
    override function removeActivePage():Void{
        super.removeActivePage();        
    }
	function configText():Void
	{
		var levelText:String = "LVL: 999\n";
		var expText:String = "EXP: 999\n";
		var nextLevelText:String = "EXP TO NEXT LVL: 1\n";
		var timeText:String = "TIME: " + FlxStringUtil.formatTime(Save.playtime, false) + "\n";

		biggerText.text = levelText + expText + nextLevelText + timeText;
		biggerText.setPosition(bg.bgCenter.x + 5, bg.bgCenter.y + bg.bgCenter.height - biggerText.height);
	}
}
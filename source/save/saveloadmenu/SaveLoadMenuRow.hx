package save.saveloadmenu;

class SaveLoadMenuRow extends FlxSpriteGroup{
    var saveWindow:CtSprite;
    
    public var callIcon:CtSprite;
    
    var divider:CtSprite;
        
    public function new(saveWindow:CtSprite, y:Float, saveID:Int, addDivider:Bool):Void{
        super();
    
        this.saveWindow = saveWindow;
        
        callIcon = new CtSprite().createFromImage(Constants.saveLoadMenuCallIconGraphicPath, .7);
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
    }
}
package overworld.playermenu;

class PlayerMenuPage extends FlxSpriteGroup{
    public var highlightBg:PlayerMenuPageBg;
    public var bg:PlayerMenuPageBg;
    
    // player menu
    var playerMenu:PlayerMenu;
    
    // tag
    public var tag:String = "";
    
    public function new(playerMenu:PlayerMenu, tag:String):Void{
        super();
        
        this.playerMenu = playerMenu;
        this.tag = tag;
        
        highlightBg = new PlayerMenuPageBg();
        highlightBg.visible = false;
        add(highlightBg);
        
        for(i in highlightBg.bgSprites){
            i.colorTransform.color = FlxColor.WHITE;
        }
        
        bg = new PlayerMenuPageBg();
        add(bg);

        makeBg(300, 600);
        
        kill();
    }
    
    function makeBg(width:Int, height:Int):Void{
        highlightBg.makeBg(width + 10, height + 10);        
        bg.makeBg(width, height); 
    }
    
    public function openPage(xPos:Int):Void{
        revive();
        
        bg.position(xPos);
        highlightBg.position(Std.int(xPos - 5));
    }
    
    public function closePage():Void{
        kill();
    }
    
    public function setActivePage():Void{
        highlightBg.visible = true;
    }
    
    public function removeActivePage():Void{
        highlightBg.visible = false;
    }
}
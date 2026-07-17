package overworld.playermenu.pages;

class PlayerMenuPageStatus extends PlayerMenuPage
{
    public function new(playerMenu:PlayerMenu):Void{
        super(playerMenu, "status");
        makeBg(450, 500);
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(CtControls.checkInput("cancel", JUSTPRESSED)){
            playerMenu.removePage("status");
        }        
    }
    
    override function openPage(xPos:Int):Void{
        super.openPage(xPos); 
    }
    
    override function setActivePage():Void{
        super.setActivePage();        
    }
    
    override function removeActivePage():Void{
        super.removeActivePage();        
    }
}
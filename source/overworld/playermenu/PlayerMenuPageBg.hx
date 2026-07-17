package overworld.playermenu;

class PlayerMenuPageBg extends FlxSpriteGroup{
    public var bgCenter:CtSprite = new CtSprite().createColorBlock(1, 1, FlxColor.WHITE);
    public var bgLeft:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgLeft);
    public var bgLeftUp:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgLeftUp);
    public var bgLeftDown:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgLeftDown);
    public var bgRight:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgRight);
    public var bgRightUp:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgRightUp);
    public var bgRightDown:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgRightDown);
    public var bgTop:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgTop);
    public var bgBottom:CtSprite = new CtSprite().createFromImage(Constants.playerMenuBgBottom);
    
    public var bgSprites:Array<CtSprite>;
    
    public function new():Void{
       super(); 
       
        bgSprites = [
            bgLeftUp, bgTop, bgRightUp,
            bgLeft, bgCenter, bgRight,
            bgLeftDown, bgBottom, bgRightDown
        ];
        
        for(i in bgSprites){
            i.antialiasing = false;
            add(i);
        }        
    }
    
    public function makeBg(width:Int, height:Int):Void{
        bgCenter.setGraphicSize(width, height);    
        bgCenter.updateHitbox();
        
        bgTop.setGraphicSize(bgCenter.width, bgTop.height);
        bgTop.updateHitbox();
        
        bgBottom.setGraphicSize(bgCenter.width, bgBottom.height);
        bgBottom.updateHitbox();
        
        bgLeft.setGraphicSize(bgLeft.width, bgCenter.height);
        bgLeft.updateHitbox();
        
        bgRight.setGraphicSize(bgRight.width, bgCenter.height);
        bgRight.updateHitbox();
        
        updateSpritePositions();
    }
    
    public function position(xPos:Int):Void{
        bgCenter.x = xPos;
        bgCenter.screenCenter(Y);
        
        updateSpritePositions();
    }
    
    function updateSpritePositions():Void{
        //up
        bgTop.setPosition(bgCenter.x, bgCenter.y - bgTop.height);
        bgLeftUp.setPosition(bgCenter.x - bgLeftUp.width, bgTop.y);
        bgRightUp.setPosition(bgCenter.x + bgCenter.width, bgCenter.y - bgRightUp.height);
        
        //center
        bgLeft.setPosition(bgCenter.x - bgLeft.width, bgCenter.y);
        bgRight.setPosition(bgCenter.x + bgCenter.width, bgCenter.y);
        
        //down
        bgBottom.setPosition(bgCenter.x, bgCenter.y + bgCenter.height);
        bgLeftDown.setPosition(bgCenter.x - bgLeftDown.width, bgCenter.y + bgCenter.height);
        bgRightDown.setPosition(bgCenter.x + bgCenter.width, bgCenter.y + bgCenter.height);
    }
}
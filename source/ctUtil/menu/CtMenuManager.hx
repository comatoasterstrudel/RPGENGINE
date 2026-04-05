package ctUtil.menu;

class CtMenuManager
{
    var menuOptions:Array<CtMenuOption>;
    
    var increaseFunction:Void->Bool;
    
    var decreaseFunction:Void->Bool;
    
    var selectFunction:Void->Bool;
    
    var enabled:Bool = false;
    
    var curSelected:Int = 0;
    
    var cursor:CtSprite;
    
    var cursorSpacing:Float;
    
    var cursorDoLerp:Bool;
    
    public function new(menuOptions:Array<CtMenuOption>, increaseFunction:Void->Bool, decreaseFunction:Void->Bool, selectFunction:Void->Bool){
        this.menuOptions = menuOptions;
        
        this.increaseFunction = increaseFunction;
        this.decreaseFunction = decreaseFunction;
        this.selectFunction = selectFunction;
        
        disable();
    }
    
    public function update():Void{
        if(!enabled) return;
        
        var doIncrease:Bool = increaseFunction();
        var doDecrease:Bool = decreaseFunction();
        
        if(doIncrease && !doDecrease){
            changeSelection(1);
        } else if(!doIncrease && doDecrease){
            changeSelection(-1);
        }
        
        if(selectFunction()) makeSelection();        
    }
    
    function changeSelection(amount:Int = 0):Void{
        curSelected += amount;
        
        if(curSelected >= menuOptions.length){
            curSelected = 0;
        } else if(curSelected < 0){
            curSelected = menuOptions.length - 1;
        }
                
        for(i in 0...menuOptions.length){
            var option = menuOptions[i];
            
            if(curSelected != i && option.nonHoverFunction != null){
                option.nonHoverFunction(option.sprite);
            } else if(curSelected == i){
                if(option.hoverFunction != null) option.hoverFunction(option.sprite);
                
                if(cursor != null && option.cursorDirection != null){
                    cursor.revive();

                    var pos = new FlxPoint();
                    
                    switch(option.cursorDirection){
                        case LEFT:
                            pos.set(option.sprite.x - cursor.width - cursorSpacing, option.sprite.y + option.sprite.height / 2 - cursor.height / 2);
                        case RIGHT:
                            pos.set(option.sprite.x + option.sprite.width + cursorSpacing, option.sprite.y + option.sprite.height / 2 - cursor.height / 2);
                        case DOWN:
                            pos.set(option.sprite.x + option.sprite.width / 2 - cursor.width / 2, option.sprite.y + option.sprite.height + cursorSpacing);
                        case UP:
                            pos.set(option.sprite.x + option.sprite.width / 2 - cursor.width / 2, option.sprite.y - cursor.height - cursorSpacing);
                    }
                    
                    if(cursorDoLerp){
                        cursor.lerpManager.targetPosition.set(pos.x, pos.y);
                    } else {
                        cursor.setPosition(pos.x, pos.y);
                    }
                } else if(cursor != null && option.cursorDirection == null) {
                    cursor.kill();
                    FlxG.log.error("Menu option " + i + " has no cursor direction listed. Cursor will be killed.");
                }
            }
        }
    }
    
    function makeSelection():Void{
        var option = menuOptions[curSelected];
        
        if(option.clickFunction != null) option.clickFunction(option.sprite);
    }
    
    public function enable(?reset:Bool = false):Void{
        enabled = true;
        if(cursor != null) cursor.revive();
        if(reset) curSelected = 0;
        changeSelection();
    }
    
    public function disable(?reset:Bool = false):Void{
        enabled = false;
        if(cursor != null) cursor.kill();
        if(reset) curSelected = 0;
    }
    
    public function addCursor(cursor:CtSprite, cursorSpacing:Float, ?cursorDoLerp:Bool = false):FlxSprite{
        this.cursor = cursor;
        this.cursorSpacing = cursorSpacing;
        this.cursorDoLerp = cursorDoLerp;
        return cursor;
    }
}
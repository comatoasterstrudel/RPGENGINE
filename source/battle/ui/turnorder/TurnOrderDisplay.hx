package battle.ui.turnorder;

class TurnOrderDisplay extends FlxSpriteGroup
{
	var upperBar:CtSprite;
    
    var iconAmount:Int;
    
    var icons:Array<TurnOrderIcon> = [];
    
    var aliveIcons:Array<FlxSprite> = [];
    
    public function new(gridSize:FlxPoint):Void{
        super();
        
		upperBar = new CtSprite().createFromImage(Constants.turnOrderDisplayUpperBarGraphicPath);
		add(upperBar);
        
        iconAmount = Std.int((gridSize.x * gridSize.y) * 2);
        
        for(i in 0...iconAmount){
            var icon = new TurnOrderIcon();
            add(icon);
            
            icon.kill();
            
            icons.push(icon);
        }
    }
    
    public function updateTurnOrderDisplay(turnOrder:Array<Unit>):Void{
        for(icon in icons){
            icon.kill();
        }
        
        aliveIcons = [];
        
        for(i in 0...turnOrder.length){
            icons[i].revive();
            icons[i].updateTurnOrderIcon(turnOrder[i]);
            
            aliveIcons.push(icons[i].bg);
        }
        
        CtUtil.centerGroup(aliveIcons, 20);
    }
	public function updateCurrentTurn(unit:Unit):Void
	{
		for (icon in icons)
		{
			if (!icon.alive)
				continue;

			icon.updateCurrentTurn(unit);
		}
	}
}
package battle.ui.minihealthbar;

class MiniHealthBars extends FlxTypedGroup<MiniHealthBar>{
    public function new():Void{
        super();
    }
    
    public function addNewBar(unit:Unit):Void{
        var miniHealthBar = new MiniHealthBar(unit);
		add(miniHealthBar);
    }
    
    public function getBarByUnit(unit:Unit):MiniHealthBar{
        for(bar in members){
            if(bar.unit.uniqueUnitID == unit.uniqueUnitID){
                return bar;
            }
        }
        
        return null;
    }
    
    public function removeBarByUnit(unit:Unit):Void{
        var bar = getBarByUnit(unit);
        
        if(bar != null){
            remove(bar, true);
            bar.destroy();
        }
    }
}
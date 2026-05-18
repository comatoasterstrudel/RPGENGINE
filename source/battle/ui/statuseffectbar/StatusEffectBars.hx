package battle.ui.statuseffectbar;

class StatusEffectBars extends FlxTypedGroup<StatusEffectBar>{
    public function new():Void{
        super();
    }
    
    public function addNewBar(unit:Unit):Void{
        var statusEffectBar = new StatusEffectBar(unit);
		add(statusEffectBar);
    }
    
    public function getBarByUnit(unit:Unit):StatusEffectBar{
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
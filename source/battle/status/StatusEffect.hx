package battle.status;

class StatusEffect
{
    public var id:String;
    
    public var data:StatusEffectData;
    
    public var turns:Int = 0;
    
    public var finished:FlxSignal;
    
    public function new(id:String, turns:Int):Void{
        this.id = id;
        
        this.data = new StatusEffectData(id);
        
        this.turns = turns;
        
        finished = new FlxSignal();
    }
    
    public function changeTurns(amount:Int):Void{
        turns = Std.int(FlxMath.bound(turns + amount, 0));
        
        if(turns == 0){
            finished.dispatch();
        }
    }
    
    public static function mapStatusParams(data:Dynamic):Array<StatusParams>{
        if(data == null){
            return([]);
        }
        return(data.map(function(item)
        {
            return {
				id: item.id,
                turns: item.turns
            };
        }));
    }
}
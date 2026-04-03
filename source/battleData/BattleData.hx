package battleData;

class BattleData extends CtJsonLoader
{
    var id:String;
    
    public var gridSizeX:Int;
    public var gridSizeY:Int;
    
    public var allyUnits:Array<UnitInfo> = [];
    public var enemyUnits:Array<UnitInfo> = [];

    public function new(id:String){
        this.id = id;
        
        super(Constants.battleDataPath + id + '.json');
        
        this.gridSizeX = data.gridSizeX;
        this.gridSizeY = data.gridSizeY;
        
        allyUnits = data.allyUnits.map(function(item)
        {
            return {
                id: item.ID,
                position: new FlxPoint(item.x, item.y)
            };
        });
        
        enemyUnits = data.enemyUnits.map(function(item)
        {
            return {
                id: item.ID,
                position: new FlxPoint(item.x, item.y)
            };
        });
    }
}
package units;

class Unit extends CtSprite
{
    /**
     * the id for this unit, basically its name
     */
    public var unitID:String;
    
    public var grid:Grid;
    
    public var position:FlxPoint;
    
    public function new(unitID:String, grid:Grid, position:FlxPoint):Void{
        super();
        
        this.unitID = unitID;
        this.grid = grid;
        this.position = position;
        
        applyGraphic();
        
        lerpManager.lerpX = true;
        lerpManager.lerpY = true;
    }
    
    function applyGraphic():Void{
        createColorBlock(30, 30, FlxColor.BLUE);
    }
}
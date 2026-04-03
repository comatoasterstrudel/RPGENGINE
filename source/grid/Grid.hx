package grid;

class Grid extends FlxTypedGroup<GridSpace>
{
    /**
     * The size of this battle grid.
     * Ex. (4,4) - A 4 tile wide 4 tile tall grid.
     */
    var size:FlxPoint;
    
    var position:FlxPoint;
    
    var spaces:Array<GridSpace> = [];
    
    var units:Array<Unit> = [];
    
    public function new(size:FlxPoint, position:FlxPoint){
        super();
        
        this.size = size;
        
        for(xSpace in 0...Std.int(size.x)){
            for(ySpace in 0...Std.int(size.y)){
                var gridSpace = new GridSpace(new FlxPoint(xSpace, ySpace));
                gridSpace.baseSprite.setPosition(position.x + (Constants.gridSize * xSpace), position.y + (Constants.gridSize * ySpace));
                gridSpace.updateGridSprites();
                add(gridSpace);
                
                spaces.push(gridSpace);
            } 
        }
    }
    
    public function placeUnit(unit:Unit):Void{
        if(units.contains(unit)){
            return;
        }
        
        units.push(unit);
        
        updateUnits();
    }
    
    function updateUnits():Void{
        for(space in spaces){
            space.unit = null;    
        }
        
        for(unit in units){
            var space = getGridSpaceFromGrid(this, unit.position);
            space.unit = unit;
            space.updateGridSprites();
        }
    }
    
    public static function getGridSpaceFromGrid(grid:Grid, position:FlxPoint):GridSpace
    {
        for(space in grid.spaces){
            if(CtUtil.compareFlxPoints(space.position, position)) return space;
        }
        
        return null;
    }
    
    public static function calculateGridSize(size:FlxPoint):FlxPoint{
        return new FlxPoint(Constants.gridSize * size.x, Constants.gridSize * size.y);
    }
}
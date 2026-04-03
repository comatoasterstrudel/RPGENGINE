package units;

class Unit extends CtSprite
{
    /**
     * the id for this unit, basically its name
     */
    public var unitID:String;
    
	public var data:UnitData;
    
    public var grid:Grid;
    
    public var position:FlxPoint;
    
    public function new(unitID:String, grid:Grid, position:FlxPoint):Void{
        super();
        
        this.unitID = unitID;
		this.data = new UnitData(unitID);
        
        this.grid = grid;
        this.position = position;
        
        applyGraphic();
        
        lerpManager.lerpX = true;
        lerpManager.lerpY = true;
    }
    
    function applyGraphic():Void{
		var path = Constants.unitGridGraphicPath + data.gridGraphic + '.png';

		if (Assets.exists(path))
		{
			createFromImage(path);
		}
		else
		{
			FlxG.log.error("Can't find unit grid graphic \"" + path + "\".");
			createColorBlock(40, 40, FlxColor.BLUE);
		}        
    }
}
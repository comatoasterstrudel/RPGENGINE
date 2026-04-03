package grid;

class GridSpace extends FlxTypedGroup<CtSprite>{
    /**
     * the position of this grid space on a grid.
     * Ex: (0, 0) - At the top left of the grid
     */
    public var position:FlxPoint;
    
    /**
     * this is the sprite used to position this grid space. should be invisible
     */
    public var baseSprite:CtSprite;
    
    /**
     * this is used to track where the base sprite of this grid space was last frame. if the grid space moves, this grid space will reposition all of its sprites.
     */
    var lastBaseSpritePosition:FlxPoint;
    
    var outlineSprite:CtSprite;
    
    var fillSprite:CtSprite;
    
    public var unit:Unit;
    
    var lastOccupied:Bool = false;
    
    public function new(position:FlxPoint){
        super();
        
        this.position = position;
        
        baseSprite = new CtSprite().createColorBlock(Constants.gridSize, Constants.gridSize, FlxColor.BLACK);
        baseSprite.visible = false;
        add(baseSprite);
        
        lastBaseSpritePosition = new FlxPoint();
        
        final outlineSpriteSize:Int = Std.int(Constants.gridSize / 1.2);
        
        outlineSprite = new CtSprite().createColorBlock(outlineSpriteSize, outlineSpriteSize, FlxColor.BLACK);
        add(outlineSprite);
        
        final fillSpriteSize:Int = Std.int(Constants.gridSize / 1.4);
        
        fillSprite = new CtSprite().createColorBlock(fillSpriteSize, fillSpriteSize, FlxColor.WHITE);
        add(fillSprite);
        
        updateGridSprites(true);
    }
    
    override function update(elapsed:Float){
        super.update(elapsed);
        
        updateGridSprites();
    }
    
    /**
     * call this to update the positions of the sprites on this grid space!!
     * @param force should this happen no matter what?
     */
    public function updateGridSprites(force:Bool = false):Void{
        if(!force && (lastBaseSpritePosition.x == baseSprite.x && lastBaseSpritePosition.y == baseSprite.y) && (lastOccupied == (unit != null))){
            return;
        }
        
        CtUtil.centerSpriteOnSprite(outlineSprite, baseSprite, true, true);
        CtUtil.centerSpriteOnSprite(fillSprite, baseSprite, true, true);
                
        if(unit != null) {
            unit.lerpManager.targetPosition.x = baseSprite.x + baseSprite.width / 2 - unit.width / 2;
            unit.lerpManager.targetPosition.y = baseSprite.y + baseSprite.height / 2 - unit.height / 2;
        }
        
        lastBaseSpritePosition.set(baseSprite.x, baseSprite.y);
        lastOccupied = (unit != null);
    }
}
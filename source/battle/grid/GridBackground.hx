package battle.grid;

class GridBackground extends FlxSpriteGroup
{
    var bgSprites:Array<CtSprite> = [];
    var scrollArray:Array<Float> = [];
    
    public function new(grid:Grid):Void{
        super();
                
        var theSize = Grid.calculateGridSize(grid.size);

        for(spr in 0...Constants.gridBackgroundSpriteNum){
            var prog = 1 - FlxMath.bound(spr / (Constants.gridBackgroundSpriteNum - 1), 0, 1);
            
            var color:FlxColor = 0xFFEBEBEB;
            color = color.getDarkened(prog);
            
            var bg = new CtSprite(grid.spaces[0].baseSprite.x, grid.spaces[0].baseSprite.y).createColorBlock(Std.int(theSize.x), Std.int(theSize.y), color);
            var scroll:Float = 1 - prog;
            bg.scrollFactor.set(scroll, scroll);    
            bg.ID = spr;
            bg.alpha = scroll;
            add(bg);  
                        
            bgSprites.push(bg);
            scrollArray.push(scroll);
        }        
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        for(bg in bgSprites){
            bg.scrollFactor.set(scrollArray[bg.ID], scrollArray[bg.ID]);
        }
    }
}
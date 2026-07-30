package battle.victoryscreen;

class VictoryScreenUnitLevelUi extends FlxSpriteGroup
{
    var units:Array<String> = [];

    public var bg:CtSprite;
    var unitCells:Array<VictoryScreenUnitLevelCell> = [];

    public var wide:Int = 0;
    public var tall:Int = 0;

    var victoryScreen:VictoryScreen;

    public function new(units:Array<String>, victoryScreen:VictoryScreen):Void{
        super();

        this.units = units;
        this.victoryScreen = victoryScreen;

        addSprites();
    }

    function addSprites():Void{
        wide = (units.length > 2 ? 3 : units.length);
        tall = Math.ceil(units.length / 3);

        bg = new CtSprite().createColorBlock(Std.int(Constants.vsUnitLevelUiCellWidth * wide), Std.int(Constants.vsUnitLevelUiCellHeight * tall), FlxColor.WHITE);
        bg.screenCenter(X);
        bg.y = FlxG.height - bg.height - 50;
        bg.alpha = 0;
        add(bg);

        for(unit in units){
            var unitCell = new VictoryScreenUnitLevelCell(unit, victoryScreen);
            add(unitCell);

            unitCells.push(unitCell);
        }

        var setsofthree:Array<Array<CtSprite>> = [];

        var xPos:Int = 0;
        var yPos:Int = 0;

        for(i in 0...unitCells.length){
            if(setsofthree[yPos] == null) setsofthree[yPos] = [];

            setsofthree[yPos].push(unitCells[i].baseSprite);

            xPos ++;

            if(xPos > 2){
                xPos = 0;
                yPos ++;
            }
        }

        for(i in 0...setsofthree.length){
            CtUtil.centerGroup(cast setsofthree[i], 35, bg.x + bg.width / 2);
            for(base in setsofthree[i]){
                base.y = (bg.y + (Constants.vsUnitLevelUiCellHeight * i)) + 10;
            }
        }

        for(unit in unitCells){
            unit.updateSpritePositions();
        }
    }

    public function doFadeIn():Void{
        bg.scale.set(0.01,0.01);
        
        FlxTween.tween(bg, {alpha: 1}, .6);
        FlxTween.tween(bg.scale, {x:1 , y:1}, .6, {ease: FlxEase.quartOut});

        new FlxTimer().start(0.6, function(f):Void{
            for(unit in unitCells){
                unit.doFadeIn();
            }
        });
    }
}
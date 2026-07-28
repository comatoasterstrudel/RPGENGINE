package battle.victoryscreen;

class VictoryScreen extends FlxSubState
{
    var victoryCam:CtCamera;

    var bg:CtSprite;
    var topText:CtSprite;
    var unitLevelUi:VictoryScreenUnitLevelUi;
    var phone:VictoryScreenPhone;

    var unitsToAdd:Array<String> = [];
    
    public function new (unitsToAdd:Array<String>){
        super();

        this.unitsToAdd = unitsToAdd;

        this.unitsToAdd = ["chair", "partyhat"];

        victoryCam = new CtCamera();
        victoryCam.bgColor.alpha = 0;
        FlxG.cameras.add(victoryCam, false);

        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.camera = victoryCam;
        bg.alpha = 0;
        add(bg);

        topText = new CtSprite().createFromImage(Constants.vsTopTextPath);
        topText.antialiasing = false;
        topText.camera = victoryCam;
        topText.alpha = 0;
        add(topText);

        unitLevelUi = new VictoryScreenUnitLevelUi(this.unitsToAdd);
        unitLevelUi.camera = victoryCam;
        add(unitLevelUi);

        phone = new VictoryScreenPhone();
        phone.camera = victoryCam;
        add(phone);

        doFadeIn();

        //new FlxTimer().start(4, function(f):Void{
        //    distributeExp(100);
        //});
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
    }

    function doFadeIn():Void{
        FlxTween.tween(bg, {alpha: .94}, 1);

        new FlxTimer().start(1, function(F):Void{
            topText.setPosition(50, 40);
            
            FlxTween.tween(topText, {alpha: 1}, .5);
            topText.scale.set(2,2);
            FlxTween.tween(topText.scale, {x: 1, y: 1}, .5, {ease: FlxEase.backIn, onComplete: function(f):Void{
                FlxTween.shake(topText, 0.075, 0.05, XY);
            }});

            new FlxTimer().start(1, function(F):Void{
                phone.doFadeIn();

                new FlxTimer().start(2, function(F):Void{
                    unitLevelUi.doFadeIn();
                });
            });
        });
    }

    function distributeExp(exp:Int):Void{
        // robin
        FlxTween.tween(Save.levelRobin, {exp: Save.levelRobin.exp + exp}, 2);

        for(unit in unitsToAdd){
            var exptogive = FlxMath.bound(exp / unitsToAdd.length, 1);
            FlxTween.tween(Save.levelUnits.get(unit), {exp: Save.levelUnits.get(unit).exp + exptogive}, 2);
        }
    }
}
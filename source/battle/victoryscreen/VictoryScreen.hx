package battle.victoryscreen;

class VictoryScreen extends FlxSubState
{
    var victoryCam:CtCamera;

    var bg:CtSprite;
    var topText:CtSprite;
    var unitLevelUi:VictoryScreenUnitLevelUi;
    var phone:VictoryScreenPhone;
    var robin:CtSprite;

    var unitsToAdd:Array<String> = [];
    var expReward:Int = 1;

    public var textSignal = new FlxTypedSignal<(String, FlxColor, FlxSprite)->Void>();
    
    var onComplete:Void->Void;

    public function new (unitsToAdd:Array<String>, expReward:Int, onComplete:Void->Void){
        super();

        this.unitsToAdd = unitsToAdd;
        
        #if forceResultsValues
        this.unitsToAdd = ["chair", "partyhat"];
        this.expReward = 100;
        #end

        this.onComplete = onComplete;

        victoryCam = new CtCamera();
        victoryCam.bgColor.alpha = 0;
        FlxG.cameras.add(victoryCam, false);

        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.camera = victoryCam;
        bg.alpha = 0;
        add(bg);

        robin = new CtSprite().createFromImage(Constants.vsRobinPath);
        robin.antialiasing = false;
        robin.camera = victoryCam;
        robin.screenCenter();
        robin.alpha = 0;
        add(robin);

        topText = new CtSprite().createFromImage(Constants.vsTopTextPath);
        topText.antialiasing = false;
        topText.camera = victoryCam;
        topText.alpha = 0;
        add(topText);

        unitLevelUi = new VictoryScreenUnitLevelUi(this.unitsToAdd, this);
        unitLevelUi.camera = victoryCam;
        add(unitLevelUi);

        phone = new VictoryScreenPhone(this);
        phone.camera = victoryCam;
        add(phone);

        textSignal.add(addFloatingText);

        doFadeIn();

        new FlxTimer().start(5.5, function(f):Void{
            distributeExp(expReward, function():Void{
                new FlxTimer().start(1, function(f):Void{
                    doEnding();
                });
            });
        });
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
    }

    function addFloatingText(text:String, color:FlxColor, baseSprite:FlxSprite):Void{
        var floatingText = new VictoryScreenFloatingText(text, color, baseSprite);
        floatingText.camera = victoryCam;
        add(floatingText);
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
                robin.x += 30;
                FlxTween.tween(robin, {x: robin.x - 30, alpha: 1}, 1, {ease: FlxEase.quartOut});

                phone.doFadeIn();

                new FlxTimer().start(2, function(F):Void{
                    unitLevelUi.doFadeIn();
                });
            });
        });
    }

    function distributeExp(exp:Int, ending:Void->Void):Void{
        var time:Float = 2 + (5 * FlxMath.bound(exp / 3000, 0));
        // robin
        FlxTween.tween(Save.levelRobin, {exp: Save.levelRobin.exp + exp}, time);

        for(unit in unitsToAdd){
            var exptogive = FlxMath.bound(exp / unitsToAdd.length, 1);
            FlxTween.tween(Save.levelUnits.get(unit), {exp: Save.levelUnits.get(unit).exp + exptogive}, time);
        }

        new FlxTimer().start(time, function(f):Void{
            ending();
        });
    }

    function doEnding():Void{
        var spr = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.WHITE);
		spr.camera = victoryCam;
		spr.alpha = 0;
		add(spr);

		FlxTween.tween(spr, {alpha: 1}, 1, {
			onComplete: function(f):Void
			{
				if (onComplete != null)
				{
					onComplete();
				}
			}
		});
    }
}
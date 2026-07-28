package battle.victoryscreen;

class VictoryScreenPhoneUi extends FlxSkewedSprite
{
    var phoneSprite:CtSprite;

    public var bgCamera:FlxCamera;

    var bgTest:CtSprite;

    var cropEffect:VictoryScreenPhoneCropEffect;

    public function new(phoneSprite:CtSprite):Void{
        super();

        this.phoneSprite = phoneSprite;

        initCameraSystem();

        bgTest = new CtSprite(20, -10).createFromImage("assets/images/victoryscreen/vs_phonescreentest.png");
        bgTest.camera = bgCamera;
        FlxG.state.add(bgTest);

        skew.y = -18;
    }

    function initCameraSystem():Void{
        makeGraphic(Std.int(phoneSprite.width), Std.int(phoneSprite.height), Constants.vsPhoneBgColor);

        bgCamera = new FlxCamera(0, 0, Std.int(phoneSprite.width), Std.int(phoneSprite.height));
        bgCamera.bgColor = Constants.vsPhoneBgColor;
        FlxG.cameras.list.insert(0, bgCamera);    

        cropEffect = new VictoryScreenPhoneCropEffect();

        this.shader = cropEffect;
    }

    override function update(elapsed:Float):Void{          
        loadGraphic(CtUtil.renderFlxCameraToBitmapData(pixels, bgCamera));

        CtUtil.centerSpriteOnSprite(this, phoneSprite, true, true);
        angle = phoneSprite.angle;
        offset.set(phoneSprite.offset.x, phoneSprite.offset.y);
        visible = (phoneSprite.visible && phoneSprite.animation.curAnim.name == "open");

        super.update(elapsed);
    }

    override function destroy():Void{
        if(FlxG.cameras.list.contains(bgCamera)){
            FlxG.cameras.remove(bgCamera, true);
        }

        super.destroy();            
    }
}
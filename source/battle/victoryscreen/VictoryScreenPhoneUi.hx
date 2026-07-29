package battle.victoryscreen;

class VictoryScreenPhoneUi extends FlxSkewedSprite
{
    var phoneSprite:CtSprite;

    public var bgCamera:FlxCamera;

    var cropEffect:VictoryScreenPhoneCropEffect;

    var screenSprites:Array<FlxSprite> = [];
    var bg:CtSprite;
    var topText:CtText;
    var expBar:FlxBar;
    var levelText:CtText;
    
    var lastExp:Int = -45;
    var currentExp:Int = 100;
    var currentMaxExp:Int = 100;

    public function new(phoneSprite:CtSprite):Void{
        super();

        this.phoneSprite = phoneSprite;

        initCameraSystem();

        setupScreen();

        skew.y = -14;
        skew.x = 8.8;
        visible = false;
    }

    function initCameraSystem():Void{
        makeGraphic(Std.int(phoneSprite.width), Std.int(phoneSprite.height), Constants.vsPhoneBgColor);

        bgCamera = new FlxCamera(0, 0, Std.int(phoneSprite.width), Std.int(phoneSprite.height));
        bgCamera.bgColor = Constants.vsPhoneBgColor;
        FlxG.cameras.list.insert(0, bgCamera);    

        cropEffect = new VictoryScreenPhoneCropEffect();

        this.shader = cropEffect;
    }

    function setupScreen():Void{
        bg = new CtSprite(70, 20).createColorBlock(180, 300, 0xFF2E2E2E);
        bg.camera = bgCamera;
        FlxG.state.add(bg);

        topText = new CtText(0,0,"ROBIN");
        topText.setFormat(Constants.fontName, 45, FlxColor.WHITE);
        topText.camera = bgCamera;
        FlxG.state.add(topText);

        CtUtil.centerSpriteOnSprite(topText, bg, true, false);
        topText.y = bg.y + 20;

        expBar = new FlxBar(0,0,LEFT_TO_RIGHT, 120, 20, this, "currentExp", 0, currentMaxExp);
        expBar.createColoredFilledBar(FlxColor.BLUE, false);
        expBar.createColoredEmptyBar(FlxColor.BLACK, false);
        expBar.camera = bgCamera;
        FlxG.state.add(expBar);

        CtUtil.centerSpriteOnSprite(expBar, bg, true, true);
        expBar.y += 50;

        levelText = new CtText(0,0,"sdsd");
        levelText.setFormat(Constants.fontName, 20, FlxColor.WHITE);
        levelText.camera = bgCamera;
        FlxG.state.add(levelText);

        screenSprites = [bg, expBar, topText, levelText];
    }

    override function update(elapsed:Float):Void{          
        loadGraphic(CtUtil.renderFlxCameraToBitmapData(pixels, bgCamera));

        CtUtil.centerSpriteOnSprite(this, phoneSprite, true, true);
        angle = phoneSprite.angle;
        offset.set(phoneSprite.offset.x, phoneSprite.offset.y);
        visible = (phoneSprite.visible && phoneSprite.animation.curAnim.name == "open");

        #if phoneChangeSkew
        var movement:Float = 1;

        if(CtControls.checkInput("left", PRESSED)){
            skew.x -= movement * elapsed;
        }
        if(CtControls.checkInput("right", PRESSED)){
            skew.x += movement * elapsed;
        }
        if(CtControls.checkInput("up", PRESSED)){
            skew.y += movement * elapsed;
        }
        if(CtControls.checkInput("down", PRESSED)){
            skew.y -= movement * elapsed;
        }
        trace("SKEW - X: " + skew.x + " Y: " + skew.y);
        #end

        updateExp();
        super.update(elapsed);
    }

    function updateExp():Void{
        if(Save.levelRobin.exp != lastExp){
            levelText.text = "LVL " + Save.levelRobin.getLevel() + "\nNEXT: " + (Save.levelRobin.getNextlevelExp());
            levelText.setPosition(expBar.x + 5, expBar.y - levelText.height - 5);

            currentExp = Save.levelRobin.getCurrentLevelExp();
            currentMaxExp = CharacterLevel.getExpForNextLevel(Save.levelRobin.getLevel());
            expBar.setRange(0, currentMaxExp > 0 ? currentMaxExp : 1);

            lastExp = Save.levelRobin.exp;
        }
    }

    public function doFadeIn():Void{
        visible = true;
    }

    override function destroy():Void{
        if(FlxG.cameras.list.contains(bgCamera)){
            FlxG.cameras.remove(bgCamera, true);
        }

        super.destroy();            
    }
}
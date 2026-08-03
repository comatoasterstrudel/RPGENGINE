package battle.ui.turnorder.topbar;

class TopBarStatDisplay extends FlxSpriteGroup{
    var bar:FlxBar;
    var bgLeft:CtSprite;
    var bgMid:CtSprite;
    var bgRight:CtSprite;

    var text:CtText;

    public var progress:Float = 0;

    var prefix:String;

    public function new(x:Float, y:Float, color:FlxColor, lossColor:FlxColor, prefix:String):Void{
        super();

        this.prefix = prefix;

        bgLeft = new CtSprite(x, y).createFromImage(Constants.topBarStatDisplayLeft);
        bgLeft.antialiasing = false;

        bgMid = new CtSprite(x, y).createFromImage(Constants.topBarStatDisplayMid);
        bgMid.antialiasing = false;

        bgRight = new CtSprite(x, y).createFromImage(Constants.topBarStatDisplayRight);
        bgRight.antialiasing = false;

        bar = new FlxBar(x + 1, y + 1, LEFT_TO_RIGHT, 100, Std.int(bgLeft.height - 2), this, "progress", 0, 1, false);
        bar.createColoredFilledBar(color);
        bar.createColoredEmptyBar(lossColor);
        bar.antialiasing = false;
        add(bar);

        add(bgLeft);
        add(bgMid);
        add(bgRight);

        text = new CtText();
        text.setFormat(Constants.fontName, 30, color.getDarkened(.5), LEFT, SHADOW, color.getDarkened(.8));
        text.antialiasing = false;
        add(text);
    }

    public function changeWidth(newWidth:Int):Void{
        newWidth = Std.int(FlxMath.bound(newWidth, Constants.topBarStatDisplayMinWidth, Constants.topBarStatDisplayMaxWidth));

        bgMid.setGraphicSize(newWidth, bgMid.height);
        bgMid.updateHitbox();
        bgMid.x = bgLeft.x + bgLeft.width;

        bgRight.x = bgMid.x + bgMid.width;

        bar.setGraphicSize((bgLeft.width + bgMid.width + bgRight.width) - 2, Std.int(bgLeft.height - 2));
        bar.updateHitbox();
        bar.x = bgLeft.x + 1;
        bar.y = bgLeft.y + 1;
    }

    public function updateValues(bottom:Float, top:Float):Void{
        progress = bottom / top;
        bar.updateBar();

        text.text = prefix + " " + bottom + " / " + top;
        text.x = bgMid.x + 2;
        CtUtil.centerSpriteOnSprite(text, bgMid, false, true);
    }
}
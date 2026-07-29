package battle.victoryscreen;

class VictoryScreenFloatingText extends FlxSpriteGroup
{
    var bgMiddle:CtSprite;
    var bgLeftEdge:CtSprite;
    var bgRightEdge:CtSprite;

    var text:CtText;

    var baseSprite:FlxSprite;
    public function new(theText:String, color:FlxColor, baseSprite:FlxSprite):Void{
        super();

        bgLeftEdge = new CtSprite().createFromImage(Constants.vsFloatingTextEdgePath);
        add(bgLeftEdge);

        bgRightEdge = new CtSprite().createFromImage(Constants.vsFloatingTextEdgePath);
        bgRightEdge.flipX = true;
        add(bgRightEdge);

        bgMiddle = new CtSprite().createFromImage(Constants.vsFloatingTextMiddlePath);
        add(bgMiddle);

        text = new CtText(0,0,theText);
        text.setFormat(Constants.fontName, 40, color);
        add(text);

        CtUtil.centerSpriteOnSprite(text, baseSprite, true, true);

        FlxTween.tween(text, {y: text.y - 70, alpha: 0}, 1, {onComplete: function(f):Void{
            this.destroy();
        }});

        formatText();
    }

    override function update(elapsed:Float):Void{
        super.update(elapsed);

        formatText();
    }

    function formatText():Void{
        bgMiddle.setGraphicSize(text.width, text.height);
        bgMiddle.updateHitbox();
        bgMiddle.setPosition(text.x, text.y);

        bgLeftEdge.setGraphicSize(bgLeftEdge.width, text.height);
        bgLeftEdge.updateHitbox();
        bgLeftEdge.setPosition(text.x - bgLeftEdge.width, text.y);

        bgRightEdge.setGraphicSize(bgRightEdge.width, text.height);
        bgRightEdge.updateHitbox();
        bgRightEdge.setPosition(text.x + text.width, text.y);

        for(bg in [bgLeftEdge, bgRightEdge, bgMiddle]){
            bg.alpha = 0.4 * text.alpha;
        }
    }
}
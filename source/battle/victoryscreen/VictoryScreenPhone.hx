package battle.victoryscreen;

class VictoryScreenPhone extends FlxSpriteGroup
{
    var phoneSprite:CtSprite;
    var phoneScreen:VictoryScreenPhoneUi;
    
    public function new():Void{
        super();

        phoneSprite = new CtSprite().createFromSparrow(Constants.vsPhonePath + ".png", Constants.vsPhonePath + ".xml");
        phoneSprite.animation.addByPrefix("closed", "closed", 0);
        phoneSprite.animation.addByPrefix("open", "open", 0);
        phoneSprite.animation.play("open");
        phoneSprite.visible = false;

        phoneScreen = new VictoryScreenPhoneUi(phoneSprite);
        add(phoneScreen);

        add(phoneSprite);

        phoneSprite.setPosition(Constants.vsPhoneBaseX, Constants.vsPhoneBaseY);
    }

    public function doFadeIn():Void{
        phoneSprite.animation.play("closed");

        phoneSprite.x -= 200;

        phoneSprite.visible = true;

        FlxTween.tween(phoneSprite, {angle: 35, x: phoneSprite.x + 350}, .5, {ease: FlxEase.circOut, onComplete: function(f):Void{
            phoneSprite.animation.play("open");
            FlxTween.shake(phoneSprite, 0.1 , 0.05,  X);
            FlxTween.tween(phoneSprite, {angle: 0, x: Constants.vsPhoneBaseX, y: Constants.vsPhoneBaseY}, .5, {ease: FlxEase.circOut, onComplete: function(f):Void{
                //
            }});
        }});
    }
}
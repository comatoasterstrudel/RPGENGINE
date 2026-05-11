package battle.ui.damagetext;

class DamageText extends CtText
{
    public function new(unit:Unit, text:String, color:FlxColor):Void{
        super(0,0,text,FlxAssets.FONT_DEFAULT, 30);
       
        scale.set(4, 3);
        
        lerpManager.lerpScaleX = true;
        lerpManager.lerpScaleY = true;
        lerpManager.targetScale.set(1, 1);
        lerpManager.lerpSpeed = 7.5;
        
        this.color = color;
        
        CtUtil.centerSpriteOnSprite(this, unit, true, true);
        
        velocity.y = -250;
        
        FlxTween.tween(this.acceleration, {y: 1000}, 1, {ease: FlxEase.quartOut});
        
        moves = true;
        
        borderStyle = FlxTextBorderStyle.SHADOW;
        borderSize = 5;
    }
}
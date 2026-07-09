package battle.ui.roundanim;

class RoundAnim extends FlxSpriteGroup
{
    var camAnim:FlxCamera;
    
    var bg:CtSprite;
    var letters:Array<CtText> = [];
    
    public function new():Void{
        super();
        
        camAnim = new FlxCamera();
        camAnim.bgColor.alpha = 0;
        FlxG.cameras.add(camAnim, false);
        
        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.camera = camAnim;
        add(bg);
        
        this.camera = camAnim;
    }
    
    public function doAnim(text:String, onComplete:Void->Void):Void{
        CtUtil.destroyArrayOfSprites(cast letters);
        letters = [];
        
        camAnim.alpha = 1;
        camAnim.zoom = 1;
        bg.alpha = 0;
        
        var trueText = CtUtil.stringToArray(text);
                
        for(i in 0...trueText.length){
            new FlxTimer().start(0.125 * i, function(f):Void{
                bg.alpha = .8 * (i / (trueText.length - 1));
                
                var letter = new CtText(0, 0, trueText[i], FlxAssets.FONT_DEFAULT, 50, false);
                letter.setFormat(FlxAssets.FONT_DEFAULT, 80, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
				letter.borderSize = 8;
                letter.lerpManager.lerpScaleX = true;
                letter.lerpManager.lerpScaleY = true;
                letter.lerpManager.lerpSpeed = 8;
                letter.lerpManager.targetScale.set(1, 1);
                letter.scale.set(1.5, 1.5);
                letter.screenCenter(Y);
                add(letter);
                letters.push(letter);
                
                CtUtil.centerGroup(cast letters, 30);
                
                if(i == (trueText.length - 1)){
                    new FlxTimer().start(.5, function(f):Void{
                       FlxTween.tween(camAnim, {zoom: 2, alpha: 0}, 1, {ease: FlxEase.quartIn, onComplete: function(f):Void{
                            onComplete();
                       }}); 
                    });
                }
            });
        }        
    }
}
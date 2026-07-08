package battle.ui.turnattentionanim;

class TurnAttentionAnim extends FlxTypedGroup<CtSprite>
{
    var icon:CtSprite;
    
    var bars:Array<CtSprite> = [];
        
	var scaleTo:Float;
    
    var scaleTween:FlxTween;
    var alphaTween:FlxTween;
    
    var target:FlxSprite;
    
    var alpha:Float;
    var lastAlpha:Float;
    
    var doingAnim:Bool = false;
    
	var scaler = 2;

    public function new():Void{
        super();
        
        icon = new CtSprite().createFromImage("assets/images/transition/circle.png");
        icon.updateHitbox();
        icon.screenCenter();

        for (i in 0...4)
        {
            var bar = new CtSprite().createColorBlock(1, 1, FlxColor.BLACK);
            switch (i)
            {
                case 0:
					bar.setGraphicSize((FlxG.width) * scaler, (Math.ceil((FlxG.height - icon.height) / 2)) * scaler);
                    bar.updateHitbox();
                case 1:
					bar.setGraphicSize((Math.ceil((FlxG.width - icon.width) / 2)) * scaler, (FlxG.height) * scaler);
                    bar.updateHitbox();
                case 2:
					bar.setGraphicSize((FlxG.width) * scaler, (Math.ceil((FlxG.height - icon.height) / 2)) * scaler);
                    bar.updateHitbox();
                case 3:
					bar.setGraphicSize((Math.ceil((FlxG.width - icon.width) / 2)) * scaler, (FlxG.height) * scaler);
                    bar.updateHitbox();
            }
            add(bar);
            bars.push(bar);
        }
        add(icon);
		alpha = 0;
		lastAlpha = 1;
    }

    public function doAnim(target:FlxSprite):Void{
        doingAnim = true;
        
        this.target = target;
        
        for(i in [scaleTween, alphaTween]){
            if(i != null){
                i.cancel();
                i.destroy();
            }
        }
                
        icon.scale.set(3, 3);
        
        alpha = 0;
        lastAlpha = 0;
        
        scaleTween = FlxTween.tween(icon, {"scale.x": Constants.turnAttentionAnimScale, "scale.y": Constants.turnAttentionAnimScale}, Constants.turnAttentionAnimTime * Constants.turnAttentionAnimTimeSplit, {ease: FlxEase.quartOut});
        alphaTween = FlxTween.tween(this, {alpha: Constants.turnAttentionAnimAlpha}, Constants.turnAttentionAnimTime * Constants.turnAttentionAnimTimeSplit, {ease: FlxEase.quartOut, onComplete: function(f):Void{
            alphaTween = FlxTween.tween(this, {alpha: 0}, Constants.turnAttentionAnimTime  * (1 - Constants.turnAttentionAnimTimeSplit), {ease: FlxEase.quartIn, onComplete: function(f):Void{
                doingAnim = false;
            }});
        }});
    }
    
    override public function draw()
	{        
        if(doingAnim || alpha == 0 && lastAlpha != 0){
            for(i in members){
                i.alpha = alpha;    
            }
            lastAlpha = alpha;
            
            icon.updateHitbox();
            if(target != null) CtUtil.centerSpriteOnSprite(icon, target, true, true);
            
            for (i in 0...bars.length)
            {
                switch (i)
                {
                    case 0: //top
						bars[i].setGraphicSize(FlxG.width * scaler, icon.y * scaler);
                        bars[i].updateHitbox();
						bars[i].setPosition(FlxG.width / 2 - bars[i].width / 2, icon.y - bars[i].height);
                    case 1: //left
						bars[i].setGraphicSize(icon.x * scaler, icon.height);
                        bars[i].updateHitbox();
                        bars[i].setPosition(icon.x - bars[i].width, icon.y);
                    case 2: // bottom
						bars[i].setGraphicSize(FlxG.width * scaler, (FlxG.height - (icon.y + icon.height)) * scaler);
                        bars[i].updateHitbox();
						bars[i].setPosition(FlxG.width / 2 - bars[i].width / 2, icon.y + icon.height);
                    case 3: // right
						bars[i].setGraphicSize((FlxG.width - (icon.width + icon.x)) * scaler, icon.height);
                        bars[i].updateHitbox();
                        bars[i].setPosition(icon.x + icon.width, icon.y);
                }
            }   
        }
		super.draw();
	}
}
package battle.status;

class StatusEffectAnim extends FlxShader
{
	@:glFragmentSource("
    #pragma header

    #define iResolution vec3(openfl_TextureSize, 0.)
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    
    uniform float animProgress;
    uniform vec2 textureSize;
    
    uniform vec3 statusColor;

    void main() {
        vec4 originalPixel = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        if(originalPixel.a > 0.0){
            gl_FragColor = vec4(mix(originalPixel.r, statusColor.r, animProgress), mix(originalPixel.g, statusColor.g, animProgress), mix(originalPixel.b, statusColor.b, animProgress), originalPixel.a);
        }
    }
    ")

    var sprite:FlxSprite;
    
    var progress:Float = 0;

    public var finished:FlxSignal = new FlxSignal();

    public function new(sprite:FlxSprite, statusEffect:StatusEffect) { 
        super(); 
        
        this.sprite = sprite;
        
        data.textureSize.value = [sprite.width, sprite.height];
        data.statusColor.value = [statusEffect.data.color.red / 255, statusEffect.data.color.green / 255, statusEffect.data.color.blue / 255];
        
        data.animProgress.value = [0];
        
        FlxTween.tween(this, {progress: 1}, Constants.statusEffectAnimTime / 2, {onComplete: function(f):Void{
            FlxTween.tween(this, {progress: 0}, Constants.statusEffectAnimTime / 2, {onComplete: function(f):Void{
                finished.dispatch();
            }, onUpdate: function(f):Void{
                data.animProgress.value = [progress];
            }});
        }, onUpdate: function(F):Void{
            data.animProgress.value = [progress];
        }});
    }
}
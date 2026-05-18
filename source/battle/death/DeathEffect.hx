package battle.death;

class DeathEffect extends FlxShader
{
	@:glFragmentSource("
    #pragma header

    #define iResolution vec3(openfl_TextureSize, 0.)
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    
    uniform float progress;
    uniform vec2 textureSize;
    
    void main() {
        vec4 originalPixel = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        if(openfl_TextureCoordv.y > progress){
            gl_FragColor = vec4(originalPixel.r, originalPixel.g, originalPixel.b, originalPixel.a);
        } else {
            gl_FragColor = vec4(0, 0, 0, 0);
        }
    }
    ")

    var sprite:FlxSprite;
    
    public function new(sprite:FlxSprite) { 
        super(); 
        
        this.sprite = sprite;
        
        data.textureSize.value = [sprite.width, sprite.height];
		data.progress.value = [0];
    }
    
    var effectProgress:Float = 0;
    
    public var finished:FlxSignal = new FlxSignal();
    
    var triggeredFinished:Bool = false;
    
    public function update(elapsed:Float):Void{
        effectProgress += elapsed;
        
        if(effectProgress > Constants.deathEffectTime){
            effectProgress = Constants.deathEffectTime;   
            if(!triggeredFinished) {
                finished.dispatch(); 
                triggeredFinished = true;
            }
        }
                
        data.progress.value = [effectProgress / Constants.deathEffectTime];
    }
}
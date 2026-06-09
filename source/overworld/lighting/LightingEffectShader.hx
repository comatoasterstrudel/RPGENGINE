package overworld.lighting;

class LightingEffectShader extends FlxShader
{
	@:glFragmentSource("
    #pragma header

    #define iResolution vec3(openfl_TextureSize, 0.)
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    
    void main() {
        vec4 originalPixel = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        float alph = 1.0 - ((originalPixel.r + originalPixel.g + originalPixel.b) / 3.0);
             
        gl_FragColor = vec4(0, 0, 0, originalPixel.a * alph);  
    }
    ")
    
    public function new() { 
        super();
    }
}
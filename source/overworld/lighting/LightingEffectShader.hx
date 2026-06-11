package overworld.lighting;

class LightingEffectShader extends FlxShader
{   
	@:glFragmentSource("
    #pragma header

    #define iResolution vec3(openfl_TextureSize, 0.)
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    
    uniform vec4 colorDark;
    uniform vec4 colorGlow;

    void main() {
        vec4 originalPixel = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        float alph = ((originalPixel.r + originalPixel.g + originalPixel.b) / 3.0);
             
        vec4 mixed = mix(colorDark, colorGlow, alph);
        
        gl_FragColor = vec4(mixed.r, mixed.g, mixed.b, originalPixel.a * mixed.a);
    }
    ")
    
	public function new(colorDark:FlxColor, colorGlow:FlxColor)
	{
		super();
		updateColors(colorDark, colorGlow);
	}

	public function updateColors(colorDark:FlxColor, colorGlow:FlxColor):Void
	{
		data.colorDark.value = [
			colorDark.red / 255,
			colorDark.green / 255,
			colorDark.blue / 255,
			colorDark.alpha / 255
		];
		data.colorGlow.value = [
			colorGlow.red / 255,
			colorGlow.green / 255,
			colorGlow.blue / 255,
			colorGlow.alpha / 255
		];
	}
}
package battle.victoryscreen;

class VictoryScreenPhoneCropEffect extends FlxShader
{   
	@:glFragmentSource("
    #pragma header

    #define iResolution vec3(openfl_TextureSize, 0.)
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    
    uniform vec4 bgColor;

    void main() {
        vec4 originalPixel = flixel_texture2D(bitmap, openfl_TextureCoordv);
        
        if(bgColor.r == originalPixel.r && bgColor.g == originalPixel.g && bgColor.b == originalPixel.b){
			gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
		} else {
			gl_FragColor = vec4(originalPixel.r, originalPixel.g, originalPixel.b, originalPixel.a);
		}
    }
    ")
    
	public function new()
	{
		super();
		data.bgColor.value = [
			Constants.vsPhoneBgColor.red / 255,
			Constants.vsPhoneBgColor.green / 255,
			Constants.vsPhoneBgColor.blue / 255,
			Constants.vsPhoneBgColor.alpha / 255
		];
	}
}
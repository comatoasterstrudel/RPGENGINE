package overworld.battletransition;

class MosaicEffect extends FlxRuntimeShader
{
  public var blockSize:FlxPoint = FlxPoint.get(FlxG.width, FlxG.height);

  public var thewidth:Float = 0;
  public var theheight:Float = 0;

  public function new()
  {
		super('#pragma header
uniform vec2 uBlocksize;

void main()
{
	vec2 blocks = openfl_TextureSize / uBlocksize;
	gl_FragColor = flixel_texture2D(bitmap, floor(openfl_TextureCoordv * blocks) / blocks);
}
');
    setBlockSize(1.0, 1.0);
  }

  public function update(){
		setBlockSize(thewidth, theheight);
  }

  public function setBlockSize(w:Float, h:Float)
  {
    blockSize.set(w, h);
    setFloatArray("uBlocksize", [w, h]);
  }
}
 
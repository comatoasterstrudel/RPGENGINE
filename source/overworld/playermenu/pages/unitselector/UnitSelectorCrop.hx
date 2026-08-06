package overworld.playermenu.pages.unitselector;

/**
 * this is from fnf "LeftMaskShader" but edited a bit to be more useful
 */
class UnitSelectorCrop extends FlxShader
{
  public var swagMaskX(default, set):Float = 0;
  
  public var swagRightMaskX(default, set):Float = 0;

  public var swagMaskY(default, set):Float = 0;
  
  public var swagBottomMaskY(default, set):Float = 0;
  
  public var swagSprX(default, set):Float = 0;
    
  public var swagSprY(default, set):Float = 0;

  public var frameUV(default, set):FlxRect;

  var sprite:FlxSprite;
  
  function set_swagSprX(x:Float):Float
  {
    sprX.value[0] = x;

    return x;
  }
  
  function set_swagSprY(y:Float):Float
  {
    sprY.value[0] = y;

    return y;
  }

  function set_swagMaskX(x:Float):Float
  {
    maskX.value[0] = x;

    return x;
  }
  
  function set_swagRightMaskX(x:Float):Float
  {
    rightMaskX.value[0] = x;

    return x;
  }
  
  function set_swagMaskY(y:Float):Float
  {
    maskY.value[0] = y;

    return y;
  }
  
  function set_swagBottomMaskY(y:Float):Float
  {
    bottomMaskY.value[0] = y;

    return y;
  }

  function set_frameUV(uv:FlxRect):FlxRect
  {
    trace("SETTING FRAMEUV");
    trace(uv);

    uvFrameX.value[0] = uv.x;
    uvFrameY.value[0] = uv.y;

    return uv;
  }

  @:glFragmentSource('
        #pragma header

        uniform float sprX;
        uniform float sprY;
        
        uniform float maskX;
        uniform float rightMaskX;

        uniform float maskY;
        uniform float bottomMaskY;
        
		uniform float uvFrameX;
		uniform float uvFrameY;

        void main()
        {

            float cutOff = maskX - sprX;
            float sprPos = cutOff / openfl_TextureSize.x;

            vec2 uv = openfl_TextureCoordv.xy;

            vec4 color = flixel_texture2D(bitmap, uv);

            if (uv.x < sprPos + uvFrameX)
            {
                color = vec4(0.0, 0.0, 0.0, 0.0);
            }

            float rightCutoff = rightMaskX - sprX;
            float rightSprPos = rightCutoff / openfl_TextureSize.x;
                       
            if (uv.x > rightSprPos + uvFrameX)
            {
                color = vec4(0.0, 0.0, 0.0, 0.0);
            }
                
            float topCutoff = maskY - sprY;
            float topSprPos = topCutoff / openfl_TextureSize.y;
                       
            if (uv.y < topSprPos + uvFrameY)
            {
                color = vec4(0.0, 0.0, 0.0, 0.0);
            }
                
            float bottomCutoff = bottomMaskY - sprY;
            float bottomSprPos = bottomCutoff / openfl_TextureSize.y;
                       
            if (uv.y > bottomSprPos + uvFrameY)
            {
                color = vec4(0.0, 0.0, 0.0, 0.0);
            }
                
            gl_FragColor = color;
			// vec4 testCol = vec4(openfl_Position.x, openfl_Position.y, openfl_Position.z, 1.0);
			//gl_FragColor = vec4(1.0, openfl_TextureSize.x, 1.0, 1.0);

        }
    ')
    
  /**
   * this is a shader that only renders a sprite inside a certain pos
   * @param leftX the cut off position on the left
   * @param rightX the cut off position on the right
   * @param topY the cut off position on the top
   * @param bottomY the cut off position on the bottom
   */
  public function new(sprite:FlxSprite, leftX:Float, rightX:Float, topY:Float, bottomY:Float)
  {
    super();

    this.sprite = sprite;
    
    sprX.value = [0];
    sprY.value = [0];
    maskX.value = [0];
    rightMaskX.value = [0];
    maskY.value = [0];
    bottomMaskY.value = [0];
    uvFrameX.value = [0];
    uvFrameY.value = [0];
    
    swagMaskX = leftX;
    swagRightMaskX = rightX;
    
    swagMaskY = topY;
    swagBottomMaskY = bottomY;
    
    update();
  }
  
  public function update():Void
	{
    swagSprX = sprite.x;
    swagSprY = sprite.y;    
	}
}

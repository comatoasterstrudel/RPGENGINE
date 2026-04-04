package ctUtil;

/**
 * A class full of utilities I use in a lot of my projects.
 */
class CtUtil{
	/**
	 * Call this to lerp two values together
	 * @param initialnum The number you want to lerp
	 * @param target Where you want the initial number to lerp to
	 * @param elapsed The tiem since last frame (in ms)
	 * @param speed How fast you want it to lerp. Defaults to 15
	 * @param roundNum When you want it to be rounded (defaults to 0.001)
	 * @return Float
	 */
    public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15, ?roundNum:Float = 0.001):Float
	{
		var num = FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
		
		if(num + roundNum >= target && initialnum < target || num - roundNum <= target && initialnum > target) num = target;
		 
		return num;
	}
	/**
	 * Call this to get the average of a list of floats
	 * @param data The floats you want to get the average of
	 * @return Float
	 */
	public static function getAverage(data:Array<Float>):Float
	{
		var sum:Float = 0;
		for (value in data)
		{
			sum += value;
		}
		return (sum / data.length);
	}
	/**
	 * Call this to center a sprites X values evenly, around a certain point
	 * @param sprites An array of FlxSprite to center
	 * @param spacing How much space you want between the sprites
	 * @param xpos Where you want them to be centered around. Defaults to the middle of the screen
	 */
	public static function centerGroup(sprites:Array<FlxSprite>, spacing:Float, ?xpos:Float):Void
	{
		if (xpos == null) {
			xpos = FlxG.width / 2;
		}

		var totalWidth:Float = 0;

		for (i in sprites)
		{
			totalWidth += i.width;
		}
		totalWidth += spacing * (sprites.length - 1);

		var startX:Float = (xpos) - (totalWidth / 2);

		var currentX:Float = startX;
		for (sprite in sprites)
		{
			sprite.x = currentX;
			currentX += sprite.width + spacing;
		}
	}

	/**
	 * Call this to split a string to an array of strings
	 * @param text The text you want to split
	 * @return Array<String>
	 */
	public static function stringToArray(text:String):Array<String> {
		var thing = new StringIteratorUnicode(text);

		var returnthis:Array<String> = [];

		for (i in thing) {
			returnthis.push(String.fromCharCode(i));
		}

		return returnthis;
	}
	
	/**
	 * Call this to center an FlxSprite on another FlxSprite
	 * @param sprite1 The first FlxSprite
	 * @param sprite2 The second FlxSprite
	 * @param x Should it center on the X axis?
	 * @param y Should it center on the Y axis?
	 */
	public static function centerSpriteOnSprite(sprite1:FlxSprite, sprite2:FlxSprite, x:Bool, y:Bool):Void{
		if(x){
			sprite1.x = sprite2.x + sprite2.width / 2 - sprite1.width / 2;
		}

		if(y){
			sprite1.y = sprite2.y + sprite2.height / 2 - sprite1.height / 2;
		}
	}
	
	/**
	 * call this to check if two FlxPoints positions are the same
	 * @param point1 The first FlxPoint
	 * @param point2 The first FlxPoint
	 * @return If they're equal
	 */
	public static function compareFlxPoints(point1, point2):Bool{
		return point1.x == point2.x && point1.y == point2.y;
	}
}
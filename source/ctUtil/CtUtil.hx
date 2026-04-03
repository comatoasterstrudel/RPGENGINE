package ctUtil;

class CtUtil{
    public static function lerpThing(initialnum:Float, target:Float, elapsed:Float, speed:Float = 15, ?roundNum:Float = 0.001):Float
	{
		var num = FlxMath.lerp(target, initialnum, FlxMath.bound(1 - (elapsed * speed), 0, 1));
		
		if(num + roundNum >= target && initialnum < target || num - roundNum <= target && initialnum > target) num = target;
		 
		return num;
	}
	public static function getAverage(data:Array<Float>):Float
	{
		var sum:Float = 0;
		for (value in data)
		{
			sum += value;
		}
		return (sum / data.length);
	}
	public static function centerGroup(array:Array<FlxSprite>, spacing:Float, ?xpos:Float):Void {
		if (xpos == null) {
			xpos = FlxG.width / 2;
		}

		var centerX:Float = xpos;

		var members:Array<Dynamic> = array;

		var count:Int = members.length;
		if (count == 0)
			return;

		// Calculate the total width of all sprites including spacing
		var totalWidth:Float = 0;

		for (i in members) {
			totalWidth += i.width;
			totalWidth += spacing;
		}
		// Start positioning from the leftmost point
		var startX:Float = centerX - totalWidth / 2;

		var thex = startX;

		for (i in 0...count) {
			var sprite = members[i];
			sprite.x = (thex + (spacing)) - sprite.width / 3;
			thex = sprite.x + sprite.width;
		}
	}

	public static function stringToArray(text:String):Array<String> {
		var thing = new StringIteratorUnicode(text);

		var returnthis:Array<String> = [];

		for (i in thing) {
			returnthis.push(String.fromCharCode(i));
		}

		return returnthis;
	}
	
	public static function centerSpriteOnSprite(sprite1:FlxSprite, sprite2:FlxSprite, x:Bool, y:Bool):Void{
		if(x){
			sprite1.x = sprite2.x + sprite2.width / 2 - sprite1.width / 2;
		}

		if(y){
			sprite1.y = sprite2.y + sprite2.height / 2 - sprite1.height / 2;
		}
	}
	
	public static function compareFlxPoints(point1, point2):Bool{
		return point1.x == point2.x && point1.y == point2.y;
	}
}
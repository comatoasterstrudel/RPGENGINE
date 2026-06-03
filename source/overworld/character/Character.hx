package overworld.character;

/**
 * Class used to represent a character in the overworld
 */
class Character extends CtSprite
{
	public var hitbox:CtSprite;

    var status:CharacterStatus = IDLE;
    
	public var id:String;
	public var data:CharacterData;

	var previousPosition:FlxPoint = new FlxPoint();
	
	public var moving:Bool = false;
	
	public var noclip:Bool = false;
	
	public function new(id:String):Void
	{
        super();
        
		this.id = id;
		data = new CharacterData(id);

		initCharacterAnimations();

		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		setFacingFlip(UP, false, false);
		setFacingFlip(DOWN, false, false);
		facing = DOWN;
		hitbox = new CtSprite().createColorBlock(Std.int(width / 1.5), Std.int(height / 2), FlxColor.RED);
		hitbox.visible = false;
		hitbox.immovable = true;
		this.noclip = data.noclip;
    }
    
	override function update(elapsed:Float)
	{
		doMovement();

		hitbox.update(elapsed);
		super.update(elapsed);
    }

	override function draw():Void
	{
		CtUtil.centerSpriteOnSprite(this, hitbox, true, false);
		y = hitbox.y + hitbox.height - height;

		super.draw();
	}
	
	function initCharacterAnimations():Void
	{
		createFromSparrow(Constants.characterGraphicPath + data.graphic + ".png", Constants.characterGraphicPath + data.graphic + ".xml");
		for (anim in data.anims)
		{
			animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped, anim.flipX, anim.flipY);
		}
		scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
		updateHitbox();

		antialiasing = false;
	}

	function handleCharacterAnimations():Void
	{
		var direction:String = switch (facing)
		{
			case LEFT | RIGHT: "horizontal";
			case UP: "up";
			case DOWN: "down";
			default: "down";
		};
		moving = ((hitbox.velocity.x != 0 || hitbox.velocity.y != 0)
			&& (hitbox.x != previousPosition.x || hitbox.y != previousPosition.y));
		var type:String = moving ? "walk" : "idle";

		var animName = type + "_" + direction;

		if (animation.exists(animName))
			animation.play(animName, false);
		else
		{
			if (type == "walk")
				type = "idle";

			animName = type + "_" + direction;

			if (animation.exists(animName))
				animation.play(animName, false);
		}
		previousPosition.set(hitbox.x, hitbox.y);
	}
    
    function doMovement():Void{
        var speed = Constants.characterSpeed;
        var diagonalSpeed = Constants.characterSpeedDiagonal;
        
        switch(status){
            case MOVE_LEFT:
				hitbox.velocity.set(-speed, 0);
				facing = LEFT;
            case MOVE_RIGHT:
				hitbox.velocity.set(speed, 0);
				facing = RIGHT;
            case MOVE_UP:
				hitbox.velocity.set(0, -speed);
				facing = UP;
            case MOVE_DOWN:
				hitbox.velocity.set(0, speed);
				facing = DOWN;
            case MOVE_LEFT_UP:
				hitbox.velocity.set(-diagonalSpeed, -diagonalSpeed);
				facing = UP;
            case MOVE_LEFT_DOWN:
				hitbox.velocity.set(-diagonalSpeed, diagonalSpeed);
				facing = DOWN;
            case MOVE_RIGHT_UP:
				hitbox.velocity.set(diagonalSpeed, -diagonalSpeed);
				facing = UP;
            case MOVE_RIGHT_DOWN:
				hitbox.velocity.set(diagonalSpeed, diagonalSpeed);
				facing = DOWN;
            default:
				hitbox.velocity.set(0, 0);
        }
		handleCharacterAnimations();
	}

	public function positionCharacter(x:Float, y:Float):Void
	{
		setPosition(x, y);
		CtUtil.centerSpriteOnSprite(hitbox, this, true, false);
		hitbox.y = y + height - hitbox.height;
	}
}
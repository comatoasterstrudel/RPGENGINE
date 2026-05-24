package overworld.character;

/**
 * Class used to represent a character in the overworld
 */
class Character extends FlxSpriteGroup
{
	public var char:CtSprite;
	public var hitbox:CtSprite;

    var status:CharacterStatus = IDLE;
    
    public function new():Void{
        super();
        
		char = new CtSprite();
		initCharacterAnimations();
		add(char);

		char.setFacingFlip(LEFT, false, false);
		char.setFacingFlip(RIGHT, true, false);
		char.setFacingFlip(UP, false, false);
		char.setFacingFlip(DOWN, false, false);
		char.facing = DOWN;
		hitbox = new CtSprite().createColorBlock(Std.int(char.width / 1.5), Std.int(char.height / 2), FlxColor.RED);
		hitbox.visible = false;
		add(hitbox);
    }
    
	override function update(elapsed:Float)
	{
		doMovement();

		super.update(elapsed);

    }

	override function draw():Void
	{
		CtUtil.centerSpriteOnSprite(char, hitbox, true, false);
		char.y = hitbox.y + hitbox.height - char.height;

		super.draw();
	}
	
	function initCharacterAnimations():Void
	{
		char.createFromSparrow("assets/images/characters/character_mc.png", "assets/images/characters/character_mc.xml");
		char.animation.addByPrefix("idle_down", "idle_down", 0);
		char.animation.addByPrefix("idle_up", "idle_up", 0);
		char.animation.addByPrefix("idle_horizontal", "idle_horizontal", 0);
		char.animation.addByPrefix("walk_down", "walk_down", Constants.characterWalkFps);
		char.animation.addByPrefix("walk_up", "walk_up", Constants.characterWalkFps);
		char.animation.addByPrefix("walk_horizontal", "walk_horizontal", Constants.characterWalkFps);

		char.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
		char.updateHitbox();

		char.antialiasing = false;
	}

	function handleCharacterAnimations():Void
	{
		var direction:String = switch (char.facing)
		{
			case LEFT | RIGHT: "horizontal";
			case UP: "up";
			case DOWN: "down";
			default: "down";
		};
		var type:String = (hitbox.velocity.x != 0 || hitbox.velocity.y != 0) ? "walk" : "idle";

		var animName = type + "_" + direction;

		if (char.animation.exists(animName))
			char.animation.play(animName, false);
		else
		{
			if (type == "walk")
				type = "idle";

			animName = type + "_" + direction;

			if (char.animation.exists(animName))
				char.animation.play(animName, false);
		}
	}
    
    function doMovement():Void{
        var speed = Constants.characterSpeed;
        var diagonalSpeed = Constants.characterSpeedDiagonal;
        
        switch(status){
            case MOVE_LEFT:
				hitbox.velocity.set(-speed, 0);
				char.facing = LEFT;
            case MOVE_RIGHT:
				hitbox.velocity.set(speed, 0);
				char.facing = RIGHT;
            case MOVE_UP:
				hitbox.velocity.set(0, -speed);
				char.facing = UP;
            case MOVE_DOWN:
				hitbox.velocity.set(0, speed);
				char.facing = DOWN;
            case MOVE_LEFT_UP:
				hitbox.velocity.set(-diagonalSpeed, -diagonalSpeed);
				char.facing = UP;
            case MOVE_LEFT_DOWN:
				hitbox.velocity.set(-diagonalSpeed, diagonalSpeed);
				char.facing = DOWN;
            case MOVE_RIGHT_UP:
				hitbox.velocity.set(diagonalSpeed, -diagonalSpeed);
				char.facing = UP;
            case MOVE_RIGHT_DOWN:
				hitbox.velocity.set(diagonalSpeed, diagonalSpeed);
				char.facing = DOWN;
            default:
				hitbox.velocity.set(0, 0);
        }
		handleCharacterAnimations();
	}

	public function positionCharacter(x:Float, y:Float):Void
	{
		char.setPosition(x, y);
		CtUtil.centerSpriteOnSprite(hitbox, char, true, false);
		hitbox.y = char.y + char.height - hitbox.height;
	}
}
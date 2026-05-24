package overworld.character;

/**
 * Class used to represent a character in the overworld
 */
class Character extends FlxSpriteGroup
{
	public var char:CtSprite;
    
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
    }
    
	override function update(elapsed:Float)
	{
		doMovement();

		super.update(elapsed);

    }
    
	function initCharacterAnimations():Void
	{
		char.createFromSparrow("assets/images/characters/character_mc.png", "assets/images/characters/character_mc.xml");
		char.animation.addByPrefix("idle_down", "idle_down", 0);
		char.animation.addByPrefix("idle_up", "idle_up", 0);
		char.animation.addByPrefix("idle_horizontal", "idle_horizontal", 0);

		char.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
		char.updateHitbox();

		char.antialiasing = false;
	}
    
    function doMovement():Void{
        var speed = Constants.characterSpeed;
        var diagonalSpeed = Constants.characterSpeedDiagonal;
        
        switch(status){
            case MOVE_LEFT:
				char.velocity.set(-speed, 0);
				char.facing = LEFT;
            case MOVE_RIGHT:
				char.velocity.set(speed, 0);
				char.facing = RIGHT;
            case MOVE_UP:
				char.velocity.set(0, -speed);
				char.facing = UP;
            case MOVE_DOWN:
				char.velocity.set(0, speed);
				char.facing = DOWN;
            case MOVE_LEFT_UP:
				char.velocity.set(-diagonalSpeed, -diagonalSpeed);
				char.facing = UP;
            case MOVE_LEFT_DOWN:
				char.velocity.set(-diagonalSpeed, diagonalSpeed);
				char.facing = DOWN;
            case MOVE_RIGHT_UP:
				char.velocity.set(diagonalSpeed, -diagonalSpeed);
				char.facing = UP;
            case MOVE_RIGHT_DOWN:
				char.velocity.set(diagonalSpeed, diagonalSpeed);
				char.facing = DOWN;
            default:
				char.velocity.set(0, 0);
        }
		var direction:String = switch (char.facing)
		{
			case LEFT | RIGHT: "horizontal";
			case UP: "up";
			case DOWN: "down";
			default: "down";
		};

		char.animation.play("idle_" + direction, false);
    }
}
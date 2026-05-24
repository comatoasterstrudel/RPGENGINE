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
        
		char = new CtSprite().createColorBlock(32, 32, FlxColor.RED);
		char.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
		char.updateHitbox();
		add(char);

		char.setFacingFlip(LEFT, false, false);
		char.setFacingFlip(RIGHT, true, false);
		char.setFacingFlip(UP, false, false);
		char.setFacingFlip(DOWN, false, false);
    }
    
	override function update(elapsed:Float)
	{
		doMovement();

		super.update(elapsed);

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
    }
}
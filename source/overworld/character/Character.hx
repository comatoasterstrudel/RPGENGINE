package overworld.character;

/**
 * Class used to represent a character in the overworld
 */
class Character extends CtSprite
{
    var status:CharacterStatus = IDLE;
    
    public function new():Void{
        super();
        
        createColorBlock(50, 50, FlxColor.RED);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
        
        doMovement();
    }
    
    function doMovement():Void{
        var speed = Constants.characterSpeed;
        var diagonalSpeed = Constants.characterSpeedDiagonal;
        
        switch(status){
            case MOVE_LEFT:
                velocity.set(-speed, 0);
            case MOVE_RIGHT:
                velocity.set(speed, 0);
            case MOVE_UP:
                velocity.set(0, -speed); 
            case MOVE_DOWN:
                velocity.set(0, speed);
            case MOVE_LEFT_UP:
                velocity.set(-diagonalSpeed, -diagonalSpeed);
            case MOVE_LEFT_DOWN:
                velocity.set(-diagonalSpeed, diagonalSpeed);
            case MOVE_RIGHT_UP:
                velocity.set(diagonalSpeed, -diagonalSpeed);
            case MOVE_RIGHT_DOWN:
                velocity.set(diagonalSpeed, diagonalSpeed);
            default:
                velocity.set(0,0);
        }
    }
}
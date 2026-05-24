package overworld.character;

class Player extends Character{
	public function new()
	{
		super(Constants.playerCharacterName);
	}
    
    override function doMovement(){
        var left = CtControls.checkInput("left", PRESSED);
        var right = CtControls.checkInput("right", PRESSED);
        var up = CtControls.checkInput("up", PRESSED);
        var down = CtControls.checkInput("down", PRESSED);

        if(up && down){
            up = down = false;    
        }
        
        if(left && right){
            left = right = false;
        }
        
        if(left && !right && !up && !down){
            status = MOVE_LEFT;    
        } else if(right && !left && !up && !down){
            status = MOVE_RIGHT;
        } else if(up && !down && !left && !right){
            status = MOVE_UP;
        } else if(down && !left && !right && !up){
            status = MOVE_DOWN;
        } else if(left && up && !down && !right){
            status = MOVE_LEFT_UP;
        } else if(left && down && !up && !right){
            status = MOVE_LEFT_DOWN;
        } else if(right && up && !down && !left){
            status = MOVE_RIGHT_UP;
        } else if(right && down && !up && !left){
            status = MOVE_RIGHT_DOWN;
        } else {
            status = IDLE;
        }
        
        super.doMovement();
    }
}
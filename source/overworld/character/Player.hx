package overworld.character;

class Player extends Character{
	var interactableHitbox:CtSprite;

	public var interaction = new FlxTypedSignal<CtSprite->Void>();
    
	public function new()
	{
		super(Constants.playerCharacterName);
		interactableHitbox = new CtSprite();
		interactableHitbox.kill();
		add(interactableHitbox);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (CtControls.checkInput("accept", JUSTPRESSED))
		{
			doInteraction();
		}
	}

	function doInteraction():Void
	{
		interactableHitbox.revive();
		interactableHitbox.createColorBlock(Std.int(char.width), Std.int(char.height), FlxColor.GREEN);
		CtUtil.centerSpriteOnSprite(interactableHitbox, char, true, true);
		switch (char.facing)
		{
			case DOWN:
				interactableHitbox.y += 50;
			case UP:
				interactableHitbox.y -= 50;
			case LEFT:
				interactableHitbox.x -= 50;
			case RIGHT:
				interactableHitbox.x += 50;
			default: //
		}

		interaction.dispatch(interactableHitbox);

		interactableHitbox.kill();
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
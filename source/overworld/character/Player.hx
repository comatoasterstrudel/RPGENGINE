package overworld.character;

class Player extends Character{
	var interactableHitbox:CtSprite;

	public var interaction = new FlxTypedSignal<CtSprite->Void>();
    
	public function new()
	{
		super(Constants.playerCharacterName);
		interactableHitbox = new CtSprite();
		interactableHitbox.kill();
		hitbox.immovable = false;
		#if showInteractionBox
		FlxG.state.add(interactableHitbox);
		#end
	}

	override function update(elapsed:Float):Void
	{
		interactableHitbox.update(elapsed);
		super.update(elapsed);

		if (CtControls.checkInput("accept", JUSTPRESSED))
		{
			doInteraction();
		}
	}

	function doInteraction():Void
	{
		interactableHitbox.revive();
		interactableHitbox.createColorBlock(Std.int(width / 1.7), Std.int(height / 1.7), FlxColor.GREEN);
		CtUtil.centerSpriteOnSprite(interactableHitbox, hitbox, true, true);
		switch (facing)
		{
			case DOWN:
				interactableHitbox.y += interactableHitbox.height;
			case UP:
				interactableHitbox.y -= interactableHitbox.height;
			case LEFT:
				interactableHitbox.x -= interactableHitbox.width;
			case RIGHT:
				interactableHitbox.x += interactableHitbox.width;
			default: //
		}

		interaction.dispatch(interactableHitbox);
		interactableHitbox.kill();
		#if showInteractionBox
		interactableHitbox.camera = camera;
		interactableHitbox.revive();
		#end
	}
    
    override function doMovement(){
		var left = canMove() && CtControls.checkInput("left", PRESSED);
		var right = canMove() && CtControls.checkInput("right", PRESSED);
		var up = canMove() && CtControls.checkInput("up", PRESSED);
		var down = canMove() && CtControls.checkInput("down", PRESSED);

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
	function canMove():Bool
	{
		return !OverworldState.inCutscene;
	}
}
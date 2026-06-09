package overworld.door;

class Door extends Interactable
{
	var player:Player;

	var horizontal:Bool;

	public function new(player:Player, x:Int, y:Int, graphic:String, horizontal:Bool, room:String, transitionTime:Float, lockedDialogue:String):Void
	{
        super();
		this.player = player;
		addManually(x, y, 32, 32, INTERACT, room == "" ? lockedDialogue : "", room, transitionTime, "");
        createFromSparrow(Constants.doorGraphicPath + graphic + ".png", Constants.doorGraphicPath + graphic + ".xml");
        animation.addByPrefix("open", "open", 1);
        animation.addByPrefix("closed", "closed", 0);
        animation.play("closed");
        resize(Constants.overworldPixelScale);
        antialiasing = false;
        visible = true;
        triggerSignal.add(function():Void{
			if (room != "")
			{
				animation.play("open"); 
			}
        });
		lerpManager.lerpAlpha = true;
		lerpManager.lerpSpeed = 3;
		this.horizontal = horizontal;

		antialiasing = false;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		updateAlpha();
	}

	public function updateAlpha():Void
	{
		if ((player.y) <= (y) && FlxG.pixelPerfectOverlap(player, this) && !horizontal)
		{
			lerpManager.targetAlpha = .2;
		}
		else
		{
			lerpManager.targetAlpha = 1;
		}
    }
}
package overworld.door;

class Door extends Interactable
{
	var data:DoorData;
	
	var player:Player;

	var horizontal:Bool;

	public function new(name:String, tag:String, player:Player, x:Int, y:Int, horizontal:Bool, room:String, transitionTime:Float, lockedDialogue:String,
			scriptFunction:String):Void
	{
        super();
		this.player = player;
		data = new DoorData(name);
		
		addManually(x, y, 32, 32, INTERACT, tag, room == "" ? lockedDialogue : "", room, transitionTime, "", scriptFunction);
		createFromSparrow(Constants.doorGraphicPath + data.graphic + ".png", Constants.doorGraphicPath + data.graphic + ".xml");
        animation.addByPrefix("open", "open", 1);
        animation.addByPrefix("closed", "closed", 0);
        animation.play("closed");
        resize(Constants.overworldPixelScale);
        antialiasing = false;
        visible = true;
        triggerSignal.add(function():Void{
			openDoor();
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
	function openDoor():Void
	{
		if (room != "")
		{
			animation.play("open");
			if (data.openSound != "")
			{
				FlxG.sound.play(Constants.doorOpenSoundPath + data.openSound + ".ogg");
			}
		}
		else
		{
			if (data.lockSound != "")
			{
				FlxG.sound.play(Constants.doorLockSoundPath + data.lockSound + ".ogg");
			}
		}
	}
}
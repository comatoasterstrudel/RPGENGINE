package save;

class Save
{
	// story flags
    public static var storyFlags:Map<String, StoryFlag> = [];
    
	// time
	public static var playtime:Float = 0;
	
    public static function init():Void{
        // add story flags
        for (storyFlagName in CtUtil.stripTextFromStrings(CtUtil.findFilesInPath(Constants.storyFlagsDataFolder, [".json"], false, false), ["storyflag_", ".json"]))
		{
			storyFlags.set(storyFlagName, new StoryFlag(storyFlagName));
		}
        
		FlxG.plugins.addPlugin(new TimeHandler());
		
        reset();
    }
    
	public static var loadedSaveSlot:Int = -1;

    public static function reset():Void{
        // reset story flags
        
        for(storyFlag in storyFlags){
            storyFlag.restoreDefault();
        }
		// reset last room

		OverworldState.roomName = "";
		OverworldState.previousRoom = "";
		OverworldState.savePointName = "";
		OverworldState.resetGlobalVars();
		// reset time

		playtime = 0;
	}

	public static function save(?slot:Int = -5, ?onComplete:Void->Void):Void
	{
		if (slot == -5)
			slot = loadedSaveSlot;

		if (slot < 0)
		{
			return; // dont load on a slot that doesnt exist dawg..
		}

		loadedSaveSlot = Std.int(FlxMath.bound(slot, 0, Constants.maxSaveFiles));
		trace("Starting Save (Slot " + loadedSaveSlot + ")");

		var save = new FlxSave();
		save.bind(Constants.saveFileName + loadedSaveSlot);

		// set save as created
		save.data.saveCreated = true;

		// save story flags
		save.data.storyFlags = new Map<String, StoryFlag>();

		for (storyFlag in storyFlags)
		{
			var newFlag:StoryFlag = new StoryFlag(storyFlag.id);
			newFlag.val_string = storyFlag.val_string;
			newFlag.val_bool = storyFlag.val_bool;
			newFlag.val_int = storyFlag.val_int;
			newFlag.val_float = storyFlag.val_float;

			save.data.storyFlags.set(newFlag.id, newFlag);
		}

		// save last room

		save.data.roomName = OverworldState.roomName;
		save.data.previousRoom = OverworldState.previousRoom;
		save.data.savePointName = OverworldState.savePointName;

		// save time

		save.data.playtime = playtime;
		
		// flush
        
		save.flush();

		trace("Finished Save (Slot " + loadedSaveSlot + ")");
		if (onComplete != null)
		{
			onComplete();
		}
	}

	public static function load(?slot:Int = -5, ?onComplete:Void->Void):Void
	{
		if (slot == -5)
			slot = loadedSaveSlot;

		reset(); // reset before loading in case youre loading a different slot or smth

		if (slot < 0)
		{
			return; // dont load on a slot that doesnt exist dawg..
		}

		loadedSaveSlot = Std.int(FlxMath.bound(slot, 0, Constants.maxSaveFiles));

		trace("Starting Load (Slot " + loadedSaveSlot + ")");

		var save = new FlxSave();
		save.bind(Constants.saveFileName + loadedSaveSlot);

		if (save.data.saveCreated == null)
		{
			OverworldState.roomName = Constants.startingRoom;
			Save.save();
		}

		// load story flags
		if (save.data.storyFlags != null)
		{
			var saved_storyFlags:Map<String, StoryFlag> = cast save.data.storyFlags;

			for (storyFlag in saved_storyFlags)
			{
				if (storyFlags.exists(storyFlag.id))
				{
					storyFlags.get(storyFlag.id).val_string = storyFlag.val_string;
					storyFlags.get(storyFlag.id).val_bool = storyFlag.val_bool;
					storyFlags.get(storyFlag.id).val_int = storyFlag.val_int;
					storyFlags.get(storyFlag.id).val_float = storyFlag.val_float;
				}
			}
		}

		// load last room
		if (save.data.roomName != null)
		{
			OverworldState.roomName = save.data.roomName;
		}
		if (save.data.previousRoom != null)
		{
			OverworldState.previousRoom = save.data.previousRoom;
		}
		if (save.data.savePointName != null)
		{
			OverworldState.savePointName = save.data.savePointName;
		}
        
		// load time

		if (save.data.playtime != null)
		{
			playtime = save.data.playtime;
		}
		
		trace("Finished Load (Slot " + loadedSaveSlot + ")");
		if (onComplete != null)
		{
			onComplete();
		}
	}
	public static function isSaveStarted(slot:Int):Bool
	{
		var save = new FlxSave();
		save.bind(Constants.saveFileName + slot);

		return save.data.saveCreated;
	}

	public static function isAnySaveStarted():Bool
	{
		var yes:Bool = false;

		for (i in 0...Constants.maxSaveFiles)
		{
			if (isSaveStarted(i))
			{
				yes = true;
				break;
			}
		}

		return yes;
	}
}
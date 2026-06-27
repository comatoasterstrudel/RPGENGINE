package save;

class Save
{
	// story flags
    public static var storyFlags:Map<String, StoryFlag> = [];
    
    public static function init():Void{
        // add story flags
        for (storyFlagName in CtUtil.stripTextFromStrings(CtUtil.findFilesInPath(Constants.storyFlagsDataFolder, [".json"], false, false), ["storyflag_", ".json"]))
		{
			storyFlags.set(storyFlagName, new StoryFlag(storyFlagName));
		}
        
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
	}

	public static function save(?onComplete:Void->Void):Void
	{
		if (loadedSaveSlot < 0)
		{
			return; // dont save on a slot that doesnt exist dawg..
		}

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

		// flush
        
		save.flush();

		trace("Finished Save (Slot " + loadedSaveSlot + ")");
		if (onComplete != null)
		{
			onComplete();
		}
	}

	public static function load(slot:Int, ?onComplete:Void->Void):Void
	{
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
			Save.save(null); // if you havent used this save file before, it should write the default variables to a save file first
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
        
		trace("Finished Load (Slot " + loadedSaveSlot + ")");
		if (onComplete != null)
		{
			onComplete();
		}
	}
	public static function isSaveStarted(slot:Int):Bool
	{
		var save = new FlxSave();
		save.bind(Constants.saveFileName + loadedSaveSlot);

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
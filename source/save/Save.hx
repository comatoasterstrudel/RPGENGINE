package save;

class Save
{
    public static var storyFlags:Map<String, StoryFlag> = [];
    
    public static function init():Void{
        // add story flags
        for (storyFlagName in CtUtil.stripTextFromStrings(CtUtil.findFilesInPath(Constants.storyFlagsDataFolder, [".json"], false, false), ["storyflag_", ".json"]))
		{
			storyFlags.set(storyFlagName, new StoryFlag(storyFlagName));
		}
        
        reset();
    }
    
    public static function reset():Void{
        // reset story flags
        
        for(storyFlag in storyFlags){
            storyFlag.restoreDefault();
        }
    }
}
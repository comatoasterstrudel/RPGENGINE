package overworld.tilemap;

/**
 * FlxOgmo3Loader but qwith the ability to directly access level data
 * why isnt this a feature already??
 */
class BetterFlxOgmo3Loader extends FlxOgmo3Loader
{
    public function getLevelData():LevelData{
        return level;
	}    
}
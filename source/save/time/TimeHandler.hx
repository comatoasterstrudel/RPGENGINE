package save.time;

class TimeHandler extends FlxBasic
{

    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
		var enabled:Bool = false;
		var disabled:Bool = false;

		for (state in Constants.timeTrackerStates)
		{
			if (Std.isOfType(FlxG.state, state))
			{
				enabled = true;
			}
		}

		if (FlxG.state.subState != null)
		{
			for (subState in Constants.timeTrackerExcludedSubStates)
			{
				if (Std.isOfType(FlxG.state.subState, subState))
					disabled = true;
			}
		}

		if (enabled && !disabled)
		{
			#if traceTimeTracker
			trace("[Time Tracker] Time logged!!");
			#end
            
			Save.playtime += elapsed;
		}
    }
}
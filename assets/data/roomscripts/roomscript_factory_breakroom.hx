function CTSCRIPT_SETNAME():String
{
	return "factory_breakroom";
}

var inTheCutscene:Bool = false;

var door:Door;

var character_player:Player;
var character_manager:Character;
var character_laurin:Character;
var character_coworkerA:Character;
var character_coworkerB:Character;
var character_coworkerC:Character;

function create():Void{
	door = getDoorByTag("door");
	
	character_player = get_player();
	character_manager = getCharacterByTag("manager");
	character_laurin = getCharacterByTag("laurin");
	character_coworkerA = getCharacterByTag("coworkerA");
	character_coworkerB = getCharacterByTag("coworkerB");
	character_coworkerB.facing = RIGHT;
	character_coworkerC = getCharacterByTag("coworkerC");

	if (!Save.storyFlags.get("factory_seenbreakroomcutscene").val_bool)
	{
		doCutscene();
	}
	else
	{
		character_manager.kill();
		character_laurin.kill();
		character_coworkerA.kill();
		character_coworkerB.kill();
		character_coworkerC.kill();
	}
}

function update(elapsed:Float):Void{
	if (inTheCutscene)
	{
		door.alpha = 1;
	}
}

function doCutscene():Void{
	Save.storyFlags.get("factory_seenbreakroomcutscene").val_bool = true;
	
	set_inCutscene(true);
	
	set_lockCamera(true);
	
	inTheCutscene = true;
	
	character_player.lockMovement = true;
	character_player.positionCharacterByGrid(7.5, 15);
	character_player.movementSpeed = .2;
	
	camGame.scroll.y = 150;
	
	OverworldState.lastTransitionTime = 0;
	
	// CUTSCENE !!!

	//start fade in
	OverworldState.eventManager.addEvent(function()
	{
		var fade = new CtSprite().createColorBlock(FlxG.width, FlxG.height, 0xFF000000);
		fade.camera = camOverlay;
		add(fade);
		
		FlxTween.tween(fade, {alpha: 0}, 3, {onComplete: function(f):Void{
			fade.destroy();
		}});
	});
	
	// Camera moves upwards
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("cameraGoUp");

		character_player.moveToGridSpace(7.5, 12.5);
		
		FlxTween.tween(camGame.scroll, {y: 65}, 3, {
			ease: FlxEase.sineOut,
			onComplete: function(f):Void
			{
				OverworldState.eventManager.finishTransaction("cameraGoUp");
			}
		});
	});
	
	// initial dialogue
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("dialogue");

		new FlxTimer().start(.75, function(f):Void{
			startDialogue(["factory/breakroom/dialogue_cutscene_1"], function():Void
			{	
				OverworldState.eventManager.finishTransaction("dialogue");
			});
		});
	});
	
	// clap clap
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("clap clap");

		character_laurin.facing = LEFT;
		character_coworkerA.facing = LEFT;
		character_coworkerB.facing = UP;
		character_coworkerC.facing = RIGHT;
		
		new FlxTimer().start(2.3, function(f):Void{
			OverworldState.eventManager.finishTransaction("clap clap");
		});
	});
	
	// initial dialogue
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("dialogue");

		startDialogue(["factory/breakroom/dialogue_cutscene_2"], function():Void
		{
			OverworldState.eventManager.finishTransaction("dialogue");
		});
	});
}
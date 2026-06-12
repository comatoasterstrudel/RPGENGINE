function CTSCRIPT_SETNAME():String
{
	return "factory_lobby";
}

var character_player:Player;
var character_lobbysecretary:Character;
var character_laurin:Character;

var anims:Array<String> = ["idle_right", "blink", "idle_down", "blink"];
var progress:Int = 0;

var frontdoor:Door;
var inFirstCutscene:Bool = false;

function create():Void{
	character_player = get_player();
    character_lobbysecretary = getCharacterByTag("lobbysecretary");
	character_laurin = getCharacterByTag("laurin");

	frontdoor = getDoorByTag("frontdoor");

	if (!Save.storyFlags.get("factory_seenLobbyConversation").val_bool)
	{
		doConversationCutscene();
	}
	else
	{
		character_laurin.kill();
		setupBlink();
	}
}

function update(elapsed:Float):Void
{
	if (inFirstCutscene)
	{
		frontdoor.alpha = 1;
	}
}

function doConversationCutscene():Void
{
	Save.storyFlags.get("factory_seenLobbyConversation").val_bool = true;

	set_inCutscene(true);
	set_lockCamera(true);

	character_player.lockMovement = true;
	character_player.positionCharacterByGrid(7, 17);
	character_player.visible = false;

	camGame.scroll.y = 1000;

	character_lobbysecretary.lockAnims = true;
	character_lobbysecretary.animation.play("idle_right");

	character_laurin.facing = LEFT;

	inFirstCutscene = true;

	// CUTSCENE !!!

	// Camera moves upwards
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("cameraGoUp");

		FlxTween.tween(camGame.scroll, {y: 80}, 3, {
			onComplete: function(f):Void
			{
				OverworldState.eventManager.finishTransaction("cameraGoUp");
			}
		});
	});

	// Robin walks upwards
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("robinMove");

		character_player.visible = true;

		character_player.moveToGridSpace(7, 13, function():Void
		{
			character_player.moveToGridSpace(9, 13, function():Void
			{
				character_player.moveToGridSpace(9, 8, function():Void
				{
					OverworldState.eventManager.finishTransaction("robinMove");
				});
			});
		});
	});

	// Jess and Laurin look at robin
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("look");

		character_laurin.facing = DOWN;

		new FlxTimer().start(1, function(f):Void
		{
			OverworldState.eventManager.finishTransaction("look");
		});
	});

	// Dialogue
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("dialogue");

		startDialogue(["factory/lobby/dialogue_introcutscene"], function():Void
		{
			OverworldState.eventManager.finishTransaction("dialogue");
		});
	});

	// Laurin walks away
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("walkin away");

		character_laurin.moveToGridSpace(11.5, 5, function():Void
		{
			character_laurin.facing = UP;

			new FlxTimer().start(.5, function(f):Void
			{
				character_laurin.kill();
				new FlxTimer().start(1, function(f):Void
				{
					OverworldState.eventManager.finishTransaction("walkin away");
				});
			});
		});
	});

	// Camera goes back to robin
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("camra");

		FlxTween.tween(camGame.scroll, {y: 86}, .5, {
			onComplete: function(f):Void
			{
				OverworldState.eventManager.finishTransaction("camra");
			}
		});
	});

	// End cutscene
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("camra");

		inFirstCutscene = false;

		set_lockCamera(false);
		set_inCutscene(false);
		character_player.facing = DOWN;
		character_player.lockMovement = false;

		setupBlink();

		OverworldState.eventManager.finishTransaction("camra");
	});
}

function setupBlink():Void
{		
    character_lobbysecretary.lockAnims = true;
    
    doBlink();
}

function doBlink():Void{
    character_lobbysecretary.animation.play(anims[progress]);

    new FlxTimer().start(anims[progress] == "blink" ? .5 : 3, function(f):Void{
        doBlink();
    });
    
    progress ++;
    if(progress >= anims.length) progress = 0;
}
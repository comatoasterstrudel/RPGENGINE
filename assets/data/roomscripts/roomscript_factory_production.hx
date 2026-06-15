function CTSCRIPT_SETNAME():String
{
	return "factory_production";
}

var dialogueBox:CtDialogueBox;
var character_player:Player;

var conveyorsHorizontal:Array<ScrollingProp> = [];
var conveyorsVertical:Array<ScrollingProp> = [];

function create():Void
{
	configSnow();

	removeProductionCutsceneTrigger();

	dialogueBox = get_dialogueBox();
	character_player = get_player();

	conveyorsHorizontal = [
		getScrollingPropByTag("conveyorHorizontal1"),
		getScrollingPropByTag("conveyorHorizontal2"),
		getScrollingPropByTag("conveyorHorizontal3")
	];
	conveyorsVertical = [
		getScrollingPropByTag("conveyorVertical1"),
		getScrollingPropByTag("conveyorVertical2")
	];

	if (!Save.storyFlags.get("sawproductioncutscene"))
		stopConveyors();
	
	dialogueBox.onChoicerSelected.add(function(tag:String):Void
	{
		if (tag == "Yes")
		{
			set_inCutscene(true);
			set_inCutsceneBeforeDialogue(true);
			doProductionCutscene();
		}
		else if (tag == "No")
		{
			set_inCutscene(true);
			set_inCutsceneBeforeDialogue(true);

			doWalkDown();
		}
	});
}

function doProductionCutscene():Void
{
	Save.storyFlags.get("factory_sawproductioncutscene").val_bool = true;
	removeProductionCutsceneTrigger();

	character_player.lockMovement = true;

	set_lockCamera(true);

	var fadeout:CtSprite;

	// fade out
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("fadeOut");

		fadeout = new CtSprite().createColorBlock(FlxG.width, FlxG.height, 0xFF000000);
		fadeout.alpha = 0;
		fadeout.camera = camUI;
		add(fadeout);

		FlxTween.tween(fadeout, {alpha: 1}, 2, {
			onComplete: function(f):Void
			{
				OverworldState.eventManager.finishTransaction("fadeOut");
			}
		});
	});

	// change scene and fade in
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("fadeIn");
		OverworldState.eventManager.startTransaction("robinMovement");

		camGame.scroll.set(20, 1000);

		character_player.positionCharacterByGrid(17.5, 35);

		character_player.movementSpeed = .5;
		character_player.moveToGridSpace(-1, 27, function():Void
		{
			character_player.movementSpeed = 1;
			OverworldState.eventManager.finishTransaction("robinMovement");
		});

		FlxTween.tween(fadeout, {alpha: 0}, 2, {
			onComplete: function(f):Void
			{
				OverworldState.eventManager.finishTransaction("fadeIn");
			}
		});
	});

	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("turnOnConveyors");

		new FlxTimer().start(1, function(f):Void
		{
			startConveyors();
			new FlxTimer().start(1, function(f):Void
			{
				OverworldState.eventManager.finishTransaction("turnOnConveyors");
			});
		});
	});
	
	// end cutscene
	OverworldState.eventManager.addEvent(function()
	{
		/*
		new FlxTimer().start(0.1, function(f):Void
		{
			character_player.lockMovement = false;
			set_inCutscene(false);
														set_lockCamera(false);
		});
		 */
	});
}

function doWalkDown():Void
{
	character_player.lockMovement = true;

	// Robin walks downwards
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("robinMove");

		character_player.movementSpeed = .35;
		
		character_player.moveToGridSpace(-1, 37, function():Void
		{
			OverworldState.eventManager.finishTransaction("robinMove");
		});
	});

	// end cutscene
	OverworldState.eventManager.addEvent(function()
	{
		character_player.movementSpeed = 1;
		character_player.lockMovement = false;
		set_inCutscene(false);
	});
}

function removeProductionCutsceneTrigger():Void
{
	if (Save.storyFlags.get("factory_sawproductioncutscene").val_bool)
	{
		getInteractableByTag("factorycutscenetrigger").disabled = true;
	}
}

var snowGroup:FlxSpriteGroup;
var spr_behindTiles:FlxSpriteGroup;
var overMap:FlxSpriteGroup;

function configSnow():Void
{
	snowGroup = executeSingleScriptFunction("snow", "snow_get_snowGroup", []);    
    spr_behindTiles = get_spr_behindTiles();
    overMap = get_overMap();
    
    overMap.remove(snowGroup);
    spr_behindTiles.add(snowGroup);
    
    snowGroup.alpha = .4;
    
    executeSingleScriptFunction("snow", "snow_set_frequency", [1.5]);    
	executeSingleScriptFunction("snow", "snow_setBoundariesFromGrid", [12, 42, 8, 15]);   
}
function startConveyors():Void
{
	for (conveyor in conveyorsHorizontal)
	{
		conveyor.backdrop.velocity.set(30, 0);
	}
	for (conveyor in conveyorsVertical)
	{
		conveyor.backdrop.velocity.set(0, 30);
	}
}

function stopConveyors():Void
{
	for (conveyor in conveyorsHorizontal)
	{
		conveyor.backdrop.velocity.set(0, 0);
	}
	for (conveyor in conveyorsVertical)
	{
		conveyor.backdrop.velocity.set(0, 0);
	}
}
function CTSCRIPT_SETNAME():String
{
	return "factory_production";
}

var dialogueBox:CtDialogueBox;
var character_player:Player;

var conveyorsHorizontal:Array<ScrollingProp> = [];
var conveyorsVertical:Array<ScrollingProp> = [];

var tile_main_front:FlxTypedGroup<FlxTilemap>;

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

	tile_main_front = get_tile_main_front();

	initProduction();
	
	if (!Save.storyFlags.get("sawproductioncutscene"))
		stopConveyors();
	
	disableProduction();
	
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

function update(elapsed:Float):Void
{
	handleProduction();
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

	// turn on conveyors
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("turnOnConveyors");

		new FlxTimer().start(.5, function(f):Void
		{
			startConveyors();
			new FlxTimer().start(1, function(f):Void
			{
				OverworldState.eventManager.finishTransaction("turnOnConveyors");
			});
		});
	});
	
	// change scene to robin walking to conveyor
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("walkToConveyor");

		doSceneFade(2);

		camGame.scroll.set(1000, 1300);

		character_player.positionCharacterByGrid(22, 34);

		character_player.movementSpeed = .6;

		character_player.moveToGridSpace(38.5, -1, function():Void
		{
			FlxTween.tween(camGame.scroll, {y: 1200}, 3);

			character_player.moveToGridSpace(-1, 28.5, function():Void
			{
				character_player.moveToGridSpace(33.5, 31, function():Void
				{
					character_player.movementSpeed = 1;
					OverworldState.eventManager.finishTransaction("walkToConveyor");
				});
			});
		});
	});

	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("startProduction");

		tile_main_front.visible = true;
		enableProduction(3);
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
var conveyorSpeed:Float = -30;

function startConveyors():Void
{
	for (conveyor in conveyorsHorizontal)
	{
		conveyor.backdrop.velocity.set(conveyorSpeed, 0);
	}
	for (conveyor in conveyorsVertical)
	{
		conveyor.backdrop.velocity.set(0, conveyorSpeed);
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
var sceneFadeActive:Bool = false;

function doSceneFade(time:Float, ?onComplete:Void->Void):Void
{
	if (sceneFadeActive)
		return;

	sceneFadeActive = true;

	OverworldState.eventManager.startTransaction("sceneFading!!");

	var spr:CtSprite = new CtSprite().createColorBlock(FlxG.width, FlxG.height, 0xFF000000);
	spr.pixels.draw(FlxG.game);
	spr.screenCenter();
	spr.camera = camUI;
	add(spr);

	FlxTween.tween(spr, {alpha: 0}, time, {
		onComplete: function(f):Void
		{
			spr.destroy();
			if (onComplete != null)
				onComplete();

			OverworldState.eventManager.finishTransaction("sceneFading!!");

			sceneFadeActive = false;
		}
	});
}
var spr_inFrontTiles:FlxSpriteGroup;
var prod_start:Int = 0;
var prod_entrancesX:Array<Int> = [34, 30, 28];
var prod_entrancesY:Array<Int> = [33, 33, 26];
var prod_endX:Array<Int> = [30, 30, 20];
var prod_endY:Array<Int> = [33, 27, 26];
var prod_horiz:Array<Bool> = [true, false, true];
var prod_redirect:Array<Int> = [1, 2, -1];
var productionTimer:FlxTimer;
var productionObjects:FlxSpriteGroup;

function initProduction():Void
{
	spr_inFrontTiles = get_spr_infrontTiles();

	productionObjects = new FlxSpriteGroup();
	spr_inFrontTiles.add(productionObjects);
}

function handleProduction():Void
{
	var redirThese:Array<FlxSprite> = [];

	for (obj in productionObjects.members)
	{
		if (prod_horiz[obj.ID])
		{
			obj.velocity.set(conveyorSpeed, 0);
		}
		else
		{
			obj.velocity.set(0, conveyorSpeed);
		}

		if (obj.x <= ((prod_endX[obj.ID] * Constants.overworldPixelScale) * 16)
			&& obj.y <= ((prod_endY[obj.ID] * Constants.overworldPixelScale) * 16))
		{
			redirThese.push(obj);
		}
	}

	for (spr in redirThese)
	{
		if (prod_redirect[spr.ID] != -1)
		{
			addProductionObject(prod_redirect[spr.ID]);
		}
		productionObjects.remove(spr, true);
		spr.destroy();
	}

	redirThese = [];
}

var timeBetween:Float = 1;
var playerY:Int = 0;
var playerTween:FlxTween;

function enableProduction(time:Float):Void
{
	timeBetween = time;

	playerY = character_player.hitbox.y;

	productionTimer = new FlxTimer().start(timeBetween, function(f):Void
	{
		addProductionObject(prod_start);

		productionTimer.reset(timeBetween);

		if (playerTween != null)
		{
			playerTween.cancel();
			playerTween.destroy();
		}

		character_player.hitbox.y = playerY + 18;
		playerTween = FlxTween.tween(character_player.hitbox, {y: playerY}, .5);
	});
}

function disableProduction():Void
{
	if (productionTimer != null)
	{
		productionTimer.cancel();
	}
}

function addProductionObject(id:Int):Void
{
	var obj = new CtSprite().createColorBlock(16, 16, 0xFF0000FF);
	obj.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
	obj.updateHitbox();
	obj.ID = id;
	productionObjects.add(obj);

	obj.setPosition((prod_entrancesX[obj.ID] * Constants.overworldPixelScale) * 16, (prod_entrancesY[obj.ID] * Constants.overworldPixelScale) * 16);
}
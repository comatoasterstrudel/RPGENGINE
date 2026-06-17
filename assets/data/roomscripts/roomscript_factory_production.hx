function CTSCRIPT_SETNAME():String
{
	return "factory_production";
}

var dialogueBox:CtDialogueBox;

var character_player:Player;
var character_laurin:Character;

var conveyorsHorizontal:Array<ScrollingProp> = [];
var conveyorsVertical:Array<ScrollingProp> = [];

var conveyorLights:Array<Prop> = [];

var tile_main_front:FlxTypedGroup<FlxTilemap>;

var spr_inFrontTiles:FlxSpriteGroup;
var queuedTimeChange:Float = 0;
var snowGroup:FlxSpriteGroup;
var spr_behindTiles:FlxSpriteGroup;
var overMap:FlxSpriteGroup;
var cutsceneSnowOverlay:CtSprite;

function create():Void
{
	configSnow();

	removeProductionCutsceneTrigger();

	dialogueBox = get_dialogueBox();
	character_player = get_player();
	character_laurin = getCharacterByTag("laurin");

	conveyorsHorizontal = [
		getScrollingPropByTag("conveyorHorizontal1"),
		getScrollingPropByTag("conveyorHorizontal2"),
		getScrollingPropByTag("conveyorHorizontal3")
	];
	conveyorsVertical = [
		getScrollingPropByTag("conveyorVertical1"),
		getScrollingPropByTag("conveyorVertical2")
	];

	conveyorLights = [getPropByTag("conveyorlight1"), getPropByTag("conveyorlight2")];
	
	tile_main_front = get_tile_main_front();
	tile_main_front.visible = false;

	initProduction();
	
	if (!Save.storyFlags.get("sawproductioncutscene"))
	{
		stopConveyors();
	}
	else
	{
		startConveyors();
		character_laurin.kill();
	}
	
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
			new FlxTimer().start(1.5, function(f):Void
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

	// enable production
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("startProduction");

		tile_main_front.visible = true;
		spr_inFrontTiles.add(getPropByTag("conveyorlight2"));

		enableProduction(3);
		new FlxTimer().start(10, function(f):Void
		{
			OverworldState.eventManager.finishTransaction("startProduction");
		});
	});

	// wait, then change scene and move camera
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("cinematic");

		doSceneFade(2);

		camGame.scroll.set(0, 1500);

		FlxTween.tween(camGame.scroll, {y: 800}, 9, {
			ease: FlxEase.quadInOut,
			onComplete: function(f):Void
			{
				new FlxTimer().start(1.5, function(f):Void
				{
					queuedTimeChange = 4;
					doSceneFade(2);
					camGame.scroll.set(1000, 1200);

					new FlxTimer().start(8, function(F):Void
					{
						OverworldState.eventManager.finishTransaction("cinematic");
					});
				});
			}
		});
	});

	// wait, then change scene and move camera
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("cinematic");

		doSceneFade(2);

		camGame.scroll.set(0, 800);

		FlxTween.tween(camGame.scroll, {x: 900}, 9, {
			ease: FlxEase.quadInOut,
			onComplete: function(f):Void
			{
				new FlxTimer().start(1.5, function(f):Void
				{
					queuedTimeChange = 5;
					doSceneFade(2);
					camGame.scroll.set(1000, 1200);

					new FlxTimer().start(8, function(F):Void
					{
						OverworldState.eventManager.finishTransaction("cinematic");
					});
				});
			}
		});
	});

	// wait, then change scene and move camera
	OverworldState.eventManager.addEvent(function()
	{
		executeSingleScriptFunction("snow", "snow_set_frequency", [.5]);

		cutsceneSnowOverlay = new CtSprite(100, 100).createColorBlock(FlxG.width * 2.5, 1000, 0x67FFFFFF);
		// cutsceneSnowOverlay.alpha = .3;
		spr_behindTiles.add(cutsceneSnowOverlay);

		OverworldState.eventManager.startTransaction("cinematic");

		FlxTween.tween(camGame.scroll, {x: 400, y: 240}, 9, {
			ease: FlxEase.quadInOut,
			onComplete: function(f):Void
			{
				FlxTween.tween(camGame.scroll, {x: 800}, 9, {
					ease: FlxEase.quadInOut,
					onComplete: function(f):Void
					{
						queuedTimeChange = 7;

						new FlxTimer().start(3, function(f):Void
						{
							doSceneFade(2);
							var lightingCover = get_lightingCover();
							lightingCover.alpha = .5;
							cutsceneSnowOverlay.visible = false;
							executeSingleScriptFunction("snow", "snow_set_frequency", [1.5]);

							new FlxTimer().start(4, function(F):Void
							{
								OverworldState.eventManager.finishTransaction("cinematic");
							});
						});
					}
				});
			}
		});
	});

	// go back to robin who is now eepy
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("cinematic");

		FlxTween.tween(camGame.scroll, {x: 976, y: 1200}, 5, {
			ease: FlxEase.quadInOut,
			onComplete: function(f):Void
			{
				new FlxTimer().start(2.5, function(F):Void
				{
					OverworldState.eventManager.finishTransaction("cinematic");
				});
			}
		});
	});

	// go back to robin who is now eepy
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("larin");

		character_laurin.positionCharacterByGrid(38.5, 22);
		character_laurin.movementSpeed = .5;

		character_laurin.moveToGridSpace(-1, 28, function():Void
		{
			character_laurin.moveToGridSpace(33.5, -1, function():Void
			{
				character_laurin.moveToGridSpace(-1, 29.5, function():Void
				{
					disableProduction();
					new FlxTimer().start(1.5, function(f):Void
					{
						OverworldState.eventManager.finishTransaction("larin");
					});
				});
			});
		});
	});

	// nudge!!
	OverworldState.eventManager.addEvent(function()
	{
		character_player.facing = UP;
		FlxTween.shake(character_player, 0.05, .2, FlxAxes.X);

		/*
					var lightingCover = get_lightingCover();

					var light = lightingCover.addLightSource("factorylight", 0, 0, "haha");

					light.scale.set(0.5, 0.5);
					light.updateHitbox();
					CtUtil.centerSpriteOnSprite(light, character_player, true, true);

					FlxTween.tween(light.scale, {x: 100, y: 100}, 1, {
						ease: FlxEase.quartOut,
						onComplete: function(f):Void
						{
							lightingCover.alpha = 0;
						}
		});
		 */
	});
	// end cutscene
	OverworldState.eventManager.addEvent(function() {
		
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
	for (light in conveyorLights)
	{
		light.visible = true;
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
	for (light in conveyorLights)
	{
		light.visible = false;
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
	spr.setGraphicSize(FlxG.width, FlxG.height);
	spr.updateHitbox();
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
var prod_start:Int = 0;
var prod_entrancesX:Array<Int> = [34, 30, 28, 16, 11];
var prod_entrancesY:Array<Int> = [33, 33, 26, 26, 26];
var prod_endX:Array<Int> = [30, 30, 20, 11, 11];
var prod_endY:Array<Int> = [33, 27, 26, 26, 17];
var prod_horiz:Array<Bool> = [true, false, true, true, false];
var prod_redirect:Array<Int> = [1, 2, 3, 4, -1];
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

		if (queuedTimeChange != 0)
		{
			timeBetween = queuedTimeChange;
			queuedTimeChange = 0;
		}

		productionTimer.reset(timeBetween * FlxG.random.float(0.7, 1.3));

		if (playerTween != null)
		{
			playerTween.cancel();
			playerTween.destroy();
		}

		character_player.hitbox.y = playerY + 8;
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
	var obj = new CtSprite().createFromImage(Constants.overworldMiscGraphicPath + "factorydetergent" + FlxG.random.int(1, 3) + ".png");
	obj.scale.set(Constants.overworldPixelScale, Constants.overworldPixelScale);
	obj.updateHitbox();
	obj.ID = id;
	obj.antialiasing = false;
	productionObjects.add(obj);

	obj.setPosition((prod_entrancesX[obj.ID] * Constants.overworldPixelScale) * 16, (prod_entrancesY[obj.ID] * Constants.overworldPixelScale) * 16);
}
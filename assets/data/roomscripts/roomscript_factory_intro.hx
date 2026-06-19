function CTSCRIPT_SETNAME():String
{
	return "factory_intro";
}

var roomTrigger:Interactable;

var sprites:FlxSpriteGroup;
var spr_bg:CtSprite;
var spr_crowdBack:CtSprite;
var spr_robin:CtSprite;
var spr_crowdFront:CtSprite;

function create():Void{
    roomTrigger = getInteractableByTag("roomtrigger");
    roomTrigger.disabled = true;
    
	setupBg();

	OverworldState.lastTransitionTime = 2;

	new FlxTimer().start(2, function(f):Void
	{
		startDialogue(["factory/intro/dialogue_intro"], function():Void
		{
			roomTrigger.disabled = false;
		});   
	});
}

function setupBg():Void
{
	sprites = new FlxSpriteGroup();
	sprites.camera = camOverlay;
	add(sprites);

	spr_bg = new CtSprite().createFromImage(Constants.overworldCutsceneGraphicPath + "factory_bg.png");
	sprites.add(spr_bg);

	spr_crowdBack = new CtSprite().createFromImage(Constants.overworldCutsceneGraphicPath + "factory_crowdBack.png");
	sprites.add(spr_crowdBack);

	spr_robin = new CtSprite().createFromImage(Constants.overworldCutsceneGraphicPath + "factory_robin.png");
	sprites.add(spr_robin);

	spr_crowdFront = new CtSprite().createFromImage(Constants.overworldCutsceneGraphicPath + "factory_crowdFront.png");
	sprites.add(spr_crowdFront);
}
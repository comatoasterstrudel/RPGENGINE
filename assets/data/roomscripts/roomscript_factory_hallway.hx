function CTSCRIPT_SETNAME():String
{
	return "factory_hallway";
}

var breakRoomDoor:Door;
var officeDoor:Door;
var finaldoor:Door;
var bathroom1:Interactable;
var bathroom2:Interactable;
var bathroom3:Interactable;

var bottomDoorIsOpen:Bool = false;

var character_player:Player;
var character_managerscary:Character;
var lightingCover:LightingSprite;
var inMonsterCutscene:Bool = false;

function create(){
    breakRoomDoor = getDoorByTag("breakRoomDoor");
    officeDoor = getDoorByTag("officeDoor");
    finaldoor = getDoorByTag("finaldoor");
    bathroom1 = getInteractableByTag("bathroom1");
    bathroom2 = getInteractableByTag("bathroom2");
    bathroom3 = getInteractableByTag("bathroom3");

	character_player = get_player();
	character_managerscary = getCharacterByTag("managerscary");
	character_managerscary.kill();

	lightingCover = get_lightingCover();

    updateDialogues();
	if (Save.storyFlags.get("factory_monsterscene1").val_bool)
	{
		startMonsterCutscene();
	}
}

function update(elapsed:Float){
	if (inMonsterCutscene)
	{
		finaldoor.alpha = 1;

		if (running)
		{
			//
		}
	}
}

function opensDoor():Void{
    if(Save.storyFlags.get("factory_seenbreakroomcutscene").val_bool){
        Save.storyFlags.get("factory_officedoorinteractions").val_int += 1;
    }
    updateDialogues();
}

function updateDialogues():Void{
    if(!Save.storyFlags.get("factory_officedoorkeyobtained").val_bool){ // seen the party
        officeDoor.room = "";
        
        if(Save.storyFlags.get("factory_seenbreakroomcutscene").val_bool){
            switch(Save.storyFlags.get("factory_officedoorinteractions").val_int){
                case 0:
                    officeDoor.dialogue = "factory/hallway/dialogue_officedoor_0";
                case 1:
                    officeDoor.dialogue = "factory/hallway/dialogue_officedoor_1";
                default:
                    officeDoor.dialogue = "factory/hallway/dialogue_officedoor_2";
            }
        } else {
            officeDoor.dialogue = "factory/hallway/dialogue_officedoor_locked";
        }
    }
    
    if(Save.storyFlags.get("factory_seenbreakroomcutscene").val_bool){ // seen the party
		character_player.changeAnimationPrefix("party_");

        breakRoomDoor.room = "";
        
        if(Save.storyFlags.get("factory_officedoorinteractions").val_int > 0){
            breakRoomDoor.dialogue = "factory/hallway/dialogue_door_manager";
            for(br in [bathroom1, bathroom2, bathroom3]){
                br.dialogue = "factory/hallway/dialogue_br_manager";
            }
            
            finaldoor.dialogue = "";
            finaldoor.room = "factory_production";
            finaldoor.roomTransitionTime = 1.5;
            bottomDoorIsOpen = true;
        } else {
            breakRoomDoor.dialogue = "factory/hallway/dialogue_door_nogood";     
            
            finaldoor.room = "";
            finaldoor.dialogue = "factory/hallway/dialogue_finaldoor_dontgothere";     
        }
    }
}

function leavingRoom():Void{
    if(bottomDoorIsOpen){
        Save.storyFlags.get("factory_startedmonstercutscene").val_bool = true;
    }
}
// monster scenee
function startMonsterCutscene():Void
{
	inMonsterCutscene = true;

	set_inCutscene(true);
	set_lockCamera(true);
	camGame.scroll.x = 50;
	lightingCover.alpha = .5;

	character_player.positionCharacterByGrid(24, 15);
	character_player.movementSpeed = 1.5;
	character_player.lockAnims = true;
	character_player.lockMovement = true;

	// run up
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("run away!!!!");

		new FlxTimer().start(.5, function(F):Void
		{
			character_player.animation.play("walk_up_fast");

			character_player.moveToGridSpace(-1, 11.3, function():Void
			{
				OverworldState.eventManager.finishTransaction("run away!!!!");
			});
		});
	});

	// run left
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("run2");

		character_player.animation.play("shocked_run");

		character_player.moveToGridSpace(11, -1, function():Void
		{
			character_player.animation.play("shocked_idle");

			new FlxTimer().start(.5, function(F):Void
			{
				OverworldState.eventManager.finishTransaction("run2");
			});
		});

		new FlxTimer().start(.8, function(F):Void
		{
			character_managerscary.revive();
			character_managerscary.changeAnimationPrefix("stand-");
			character_managerscary.movementSpeed = 1.3;

			character_managerscary.positionCharacterByGrid(23.5, 14);

			character_managerscary.moveToGridSpace(-1, 10.3, function():Void
			{
				running = true;
				character_managerscary.moveToGridSpace(13, -1, function():Void
				{
					running = false;
				});
			});
		});
	});

	// look right
	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("turning");

		facing = RIGHT;
		character_player.flipX = true;
		character_player.animation.play("shocked_idle");

		new FlxTimer().start(.5, function(f):Void
		{
			OverworldState.eventManager.finishTransaction("turning");
		});
	});

	OverworldState.eventManager.addEvent(function()
	{
		OverworldState.eventManager.startTransaction("shocked_stepback");

		character_player.movementSpeed = .3;
		character_player.animation.play("shocked_stepback");
		character_player.move(character_player.x - 20, -1, function():Void
		{
			OverworldState.eventManager.finishTransaction("stepright");
			character_player.flipX = false;
			character_player.animation.play("lookup_scared");
			FlxTween.shake(character_player, 0.05, .2, 0x01);
		});
	});
}
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

function create(){
    breakRoomDoor = getDoorByTag("breakRoomDoor");
    officeDoor = getDoorByTag("officeDoor");
    finaldoor = getDoorByTag("finaldoor");
    bathroom1 = getInteractableByTag("bathroom1");
    bathroom2 = getInteractableByTag("bathroom2");
    bathroom3 = getInteractableByTag("bathroom3");

    updateDialogues();
}

function update(elapsed:Float){
    //
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
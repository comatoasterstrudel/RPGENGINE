function CTSCRIPT_SETNAME():String
{
	return "factory_intro";
}

var roomTrigger:Interactable;

function create():Void{
    roomTrigger = getInteractableByTag("roomtrigger");
    roomTrigger.disabled = true;
    
    startDialogue(["poop"], function():Void{
        roomTrigger.disabled = false;
    });
}
function CTSCRIPT_SETNAME():String
{
	return "factory_lobby";
}

var character_lobbysecretary:Character;

var anims:Array<String> = ["idle_down", "blink", "idle_right", "blink"];
var progress:Int = 0;

function create():Void{
    character_lobbysecretary = getCharacterByTag("lobbysecretary");
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
package;

class InitState extends FlxState{
    override function create():Void{
        super.create();
        
        FlxG.mouse.visible = false;

        CtControls.registerControl({id: "left", inputKey: LEFT});
        CtControls.registerControl({id: "right", inputKey: RIGHT});
        CtControls.registerControl({id: "up", inputKey: UP});
        CtControls.registerControl({id: "down", inputKey: DOWN});
        CtControls.registerControl({id: "accept", inputKey: Z});
        CtControls.registerControl({id: "cancel", inputKey: X});

        FlxG.switchState(LevelSelectorState.new);
    }
}
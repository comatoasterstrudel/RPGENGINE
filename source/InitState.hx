package;

class InitState extends FlxState{
    override function create():Void{
        super.create();
        
		#if release // show the mouse for the debugger
		openfl.ui.Mouse.hide();
		#end 
		
		CtControls.registerControl({id: "left", inputKey: LEFT, inputPad: DPAD_LEFT});
		CtControls.registerControl({id: "right", inputKey: RIGHT, inputPad: DPAD_RIGHT});
		CtControls.registerControl({id: "up", inputKey: UP, inputPad: DPAD_UP});
		CtControls.registerControl({id: "down", inputKey: DOWN, inputPad: DPAD_DOWN});
		CtControls.registerControl({id: "accept", inputKey: Z, inputPad: A});
		CtControls.registerControl({id: "cancel", inputKey: X, inputPad: B});
		CtControls.registerControl({id: "exit", inputKey: ESCAPE, inputPad: START});

		initDialogueBox();
		
		#if debug
		#if testBattle
		PlayState.battleName = Compiler.getDefine("testBattle").split('=')[0];
		FlxG.switchState(PlayState.new);
		return;
		#end
		#if testOverworld
		OverworldState.roomName = Compiler.getDefine("testOverworld").split('=')[0];
		FlxG.switchState(OverworldState.new);
		return;
		#end
		#end
        
        FlxG.switchState(LevelSelectorState.new);
    }
	function initDialogueBox():Void
	{
		CtDialogueBox.defaultSettings = {
			pressedAcceptFunction: CtControls.getInputFunction("accept", JUSTPRESSED),
			boxImgPath: Constants.dialogueBoxGraphicPath,
			nameBoxImgPath: Constants.dialogueNameBoxGraphicPath,
			nameBoxLeftEndImgPath: Constants.dialogueNameBoxLeftEndGraphicPath,
			nameBoxRightEndImgPath: Constants.dialogueNameBoxRightEndGraphicPath,
			nameBoxFontSize: 40,
			font: FlxAssets.FONT_DEFAULT,
			fontSize: 35,
			textFieldWidth: 1000,
			portraitFieldWidthRight: 600,
			textOffset: new FlxPoint(100, 100),
			boxPosition: new FlxPoint(0, 170),
			textRows: 4,
			portraitOnTopOfBox: true,
			portraitOffsetRight: new FlxPoint(330, 60),
			nameBoxOffsetLeft: new FlxPoint(45, 60)
		}

		CtDialogueBox.preloadFont(CtDialogueBox.defaultSettings.font, CtDialogueBox.defaultSettings.fontSize);
	}
}
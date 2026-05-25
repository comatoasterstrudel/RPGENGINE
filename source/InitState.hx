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

		initDialogueBox();
		
		#if debug
		#if testBattle
		PlayState.battleName = Compiler.getDefine("testBattle").split('=')[0];
		FlxG.switchState(new PlayState());
		return;
		#end
		#if testOverworld
		OverworldState.roomName = Compiler.getDefine("testOverworld").split('=')[0];
		FlxG.switchState(new OverworldState());
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
			fontSize: 30,
			textFieldWidth: 900,
			textOffset: new FlxPoint(40, 40),
			boxPosition: new FlxPoint(0, 200),
			textRows: 4,
		}

		CtDialogueBox.preloadFont(CtDialogueBox.defaultSettings.font, CtDialogueBox.defaultSettings.fontSize);
	}
}
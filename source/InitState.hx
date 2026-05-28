package;

class InitState extends FlxState{
    override function create():Void{
        super.create();
        
		#if release // show the mouse for the debugger
		openfl.ui.Mouse.hide();
		#end 
		
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
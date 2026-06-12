package;

class InitState extends FlxState{
    override function create():Void{
        super.create();
        
		#if release // show the mouse for the debugger
		openfl.ui.Mouse.hide();
		#end 
		
		initControls();

		initDialogueBox();
		
		initScripts();
		
		#if debug
		#if testBattle
		PlayState.setBattle(Compiler.getDefine("testBattle").split('=')[0], ARCADE);
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
	function initControls():Void
	{
		CtControls.registerControl({id: "left", inputKey: [LEFT, A], inputPad: [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT]});
		CtControls.registerControl({id: "right", inputKey: [RIGHT, D], inputPad: [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT]});
		CtControls.registerControl({id: "up", inputKey: [UP, W], inputPad: [DPAD_UP, LEFT_STICK_DIGITAL_UP]});
		CtControls.registerControl({id: "down", inputKey: [DOWN, S], inputPad: [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN]});
		CtControls.registerControl({id: "accept", inputKey: [Z, ENTER], inputPad: [A]});
		CtControls.registerControl({id: "cancel", inputKey: [X, SHIFT], inputPad: [B]});
		CtControls.registerControl({id: "exit", inputKey: [ESCAPE, BACKSPACE], inputPad: [START]});
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
			portraitOffsetRight: new FlxPoint(330, 52),
			nameBoxOffsetLeft: new FlxPoint(45, 60),
			sentencePauseLength: .2,
		}

		CtDialogueBox.preloadFont(CtDialogueBox.defaultSettings.font, CtDialogueBox.defaultSettings.fontSize);
	}
	function initScripts():Void
	{
		CtScript.init();
		CtScript.setDefaultValue({name: "Character", value: Character});
		CtScript.setDefaultValue({name: "DOWN", value: FlxDirectionFlags.DOWN});
		CtScript.setDefaultValue({name: "LEFT", value: FlxDirectionFlags.LEFT});
		CtScript.setDefaultValue({name: "UP", value: FlxDirectionFlags.UP});
		CtScript.setDefaultValue({name: "RIGHT", value: FlxDirectionFlags.RIGHT});
		CtScript.setDefaultValue({name: "FlxTimer", value: FlxTimer});
		CtScript.setDefaultValue({name: "FlxTween", value: FlxTween});
		CtScript.setDefaultValue({name: "FlxEase", value: FlxEase});
		CtScript.setDefaultValue({name: "Constants", value: Constants});
		CtScript.setDefaultValue({name: "FlxMath", value: FlxMath});
		CtScript.setDefaultValue({name: "LightingSprite", value: LightingSprite});
		CtScript.setDefaultValue({name: "FlxSpriteGroup", value: FlxSpriteGroup});
		CtScript.setDefaultValue({name: "BetterFlxOgmo3Loader", value: BetterFlxOgmo3Loader});
		CtScript.setDefaultValue({name: "Std", value: Std});
		CtScript.setDefaultValue({name: "FlxColor.interpolate", value: FlxColor.interpolate});
		CtScript.setDefaultValue({name: "FlxColor.fromInt", value: FlxColor.fromInt});
		CtScript.setDefaultValue({name: "LightingEffectShader", value: LightingEffectShader});
	}
}
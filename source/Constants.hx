package;

class Constants 
{
	//
	// BATTLE STUff !!!!!!11
	//
	// Battle
	public static final battleDataFolder:String = "assets/data/battles/";
	public static final battleDataPath:String = Constants.battleDataFolder + "battle_";
	public static final battleDataMusicPath:String = "assets/music/battletheme/theme_";
	// Grid
    public static final gridSize:Int = 80;
	public static final unitGridGraphicPath:String = "assets/images/grid/units/unit_";
	// Units
	public static final unitDataPath:String = "assets/data/units/unit_";
	// Skills
	public static final skillDataPath:String = "assets/data/skills/skill_";
	public static final unitMaxSkills:Int = 5;
	// Status Effects
	public static final statusEffectDataPath:String = "assets/data/status/status_";
	public static final statusEffectAnimTime:Float = 1;
	// UI
	public static final uiYOffset:Float = -60;
	// StatusEffectBar
	public static final statusEffectIconPath:String = "assets/images/statusicons/icon_";
	// MiniHealthBar
	public static final miniHealthBarFillColor:FlxColor = FlxColor.LIME;
	public static final miniHealthBarEmptyColor:FlxColor = FlxColor.RED;
	public static final miniHealthBarOutlineColor:FlxColor = FlxColor.BLACK;
	public static final miniHealthBarOutlineWidth:Int = 2;
	public static final miniHealthBarWidth:Int = 45;
	public static final miniHealthBarHeight:Int = 12;
	public static final miniHealthBarYSpacing:Int = -7;
	// TurnOrderIcon
	public static final turnOrderIconAllyPath:String = "assets/images/turnorder/ally.png";
	public static final turnOrderIconEnemyPath:String = "assets/images/turnorder/enemy.png";
	// BottomBar
	public static final bottomBarAlpha:Float = 0.4;
	public static final bottomBarAngle:Float = 3;
	public static final bottomBarY:Float = 540;
	public static final unitUiGraphicPath:String = "assets/images/bottombar/portraits/portrait_";
	public static final skillOutlineGraphicPath:String = "assets/images/bottombar/skills/box/box_outline.png";
	public static final skillBackgroundGraphicPath:String = "assets/images/bottombar/skills/box/box_bg.png";
	public static final skillIconGraphicPath:String = "assets/images/bottombar/skills/icons/icon_";
	public static final inspectButtonGraphicPath:String = "assets/images/bottombar/inspect.png";
	public static final endTurnButtonGraphicPath:String = "assets/images/bottombar/endturn.png";
	// Cursors
	public static final cursorArrowGraphic:String = "assets/images/cursors/cursor_arrow.png";
	// LevelSelectorState
	public static final levelSelectTextXPos:Int = 120;
	public static final levelSelectTextYPos:Int = 30;
	public static final levelSelectTextYSpacing:Int = 80;
	public static final levelSelectTextSize:Int = 30;
	public static final levelSelectNoLevelMessage:String = "There are no battles available!\nAdd some battle files to "
		+ Constants.battleDataFolder
		+ "\nand then press R to reload this menu!";
	// Exit
	public static final exitTime:Float = 1;
	// Death Effect
	public static final deathEffectTime:Float = 1;
	// Result State
	public static final resultTextWin:String = "WIN";
	public static final resultTextLose:String = "LOSS";
	public static final resultTextTie:String = "TIE";
	public static final resultTextPlaceholder:String = "???";
	public static final resultBgOpacity:Float = .9;
	public static final resultBigTextSize:Int = 50;
	public static final resultBigTextY:Int = 50;
	public static final resultTextSize:Int = 30;
	public static final resultTextX:Int = 300;
	public static final resultTextY:Int = 300;
	public static final resultTextSpacing:Int = 100;
	public static final resultAnimTiming:Float = .65;
	public static final resultAnimShakeTime:Float = 0.08;
	public static final resultAnimShakeIntensity:Float = 0.08;
	// TurnAttentionAnim
	public static final turnAttentionAnimTime:Float = .71;
	public static final turnAttentionAnimTimeSplit:Float = .7;
	public static final turnAttentionAnimScale:Float = .14;
	public static final turnAttentionAnimAlpha:Float = .7;
	//
	// OVERWORLD STUFF !!
	//
	// Pixel Sizing
	public static final overworldPixelScale:Float = 3;
	// Characters
	public static final playerCharacterName:String = "robin";
	public static final characterDataPath:String = "assets/data/characters/character_";
	public static final characterGraphicPath:String = "assets/images/characters/character_";
	public static final characterSpeed:Float = 300;
	public static final characterSpeedDiagonal:Float = characterSpeed * .707;
	public static final characterWalkFps:Int = 5;
	// Rooms
	public static final roomDataFolder:String = "assets/data/rooms/";
	public static final roomDataPath:String = roomDataFolder + "room_";
	// Tilemaps
	public static final ogmoFilePath:String = "assets/data/tilemaps/RPGENGINE.ogmo";
	public static final tilemapsDataPath:String = "assets/data/tilemaps/tilemap_";
	// Tilesets
	public static final tilesetDataPath:String = "assets/data/tilesets/tileset_";
	public static final tilesetGraphicPath:String = "assets/images/tileset/tileset_";
	// Encounters
	public static final encounterCooldown:Float = 3.5;
	//
	// DIALOGUE STUFF !!
	//
	public static final dialogueBoxGraphicPath:String = "box";
	public static final dialogueNameBoxGraphicPath:String = "nameBox";
	public static final dialogueNameBoxLeftEndGraphicPath:String = "nameBoxLeft";
	public static final dialogueNameBoxRightEndGraphicPath:String = "nameBoxRight";
	public static final dialogueGraphicsPath:String = "assets/images/dialogue/";
}
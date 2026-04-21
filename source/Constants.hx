package;

class Constants 
{
	// Battle
	public static final battleDataFolder:String = "assets/data/battles/";
	public static final battleDataPath:String = Constants.battleDataFolder + "battle_";
	// Grid
    public static final gridSize:Int = 80;
	public static final unitGridGraphicPath:String = "assets/images/grid/units/unit_";
	// Units
	public static final unitDataPath:String = "assets/data/units/unit_";
	// Skills
	public static final skillDataPath:String = "assets/data/skills/skill_";
	public static final unitMaxSkills:Int = 5;
	// UI
	public static final uiYOffset:Float = -60;
	// MiniHealthBar
	public static final miniHealthBarFillColor:FlxColor = FlxColor.RED;
	public static final miniHealthBarEmptyColor:FlxColor = FlxColor.LIME;
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
	// Exit
	public static final exitTime:Float = 3;
}
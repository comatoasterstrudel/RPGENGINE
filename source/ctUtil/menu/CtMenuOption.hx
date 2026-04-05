package ctUtil.menu;

/**
 * Info for each menu option in a CtMenuManager
 */
typedef CtMenuOption =
{
    /**
     * The sprite to go along with this option
     */
    var sprite:FlxSprite;
    
    /**
     * OPTIONAL; A function to trigger when you hover over an option
     */
    var ?hoverFunction:FlxSprite->Void;
    
    /**
     * OPTIONAL; A function to trigger when this option isnt being hovered over
     */
    var ?nonHoverFunction:FlxSprite->Void;
    
    /**
     * OPTIONAL; A function to trigger when you click an option
     */
    var ?clickFunction:FlxSprite->Void;
    
    /**
     * OPTIONAL; Which way the cursor should face when this option is selected.
     */
    var ?cursorDirection:FlxDirection;
}
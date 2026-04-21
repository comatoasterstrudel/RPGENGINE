package ui;

/**
 * This is an enum used to track what the current status of the ui is
 */
enum UIStatus{
    /**
     * There isnt any UI active on screen now
     */
    INACTIVE;
    
    /**
     * The player is selceting a skill for an allied unit to use
     */
    SELECTING_SKILLS;
    
    /**
     * The player is using the grid to select a unit
     */
    GRID_INSPECT;
    
    /**
     * The player is using the grid to target a skill
     */
    GRID_SKILL;
}
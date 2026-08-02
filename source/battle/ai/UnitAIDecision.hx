package battle.ai;

typedef UnitAIDecision = {
    var skillData:SkillData;
    var unit:Unit;
    var grid:Grid;
    var position:FlxPoint;
}
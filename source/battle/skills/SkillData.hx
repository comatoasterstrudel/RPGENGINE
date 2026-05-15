package battle.skills;

class SkillData extends CtJsonLoader
{
    var id:String = "";
    
    public var name:String;
    public var description:String;
    
    public var iconGraphic:String;
    
	public var selectType:String;
    
	public var rangeX:Int;
	public var rangeY:Int;

	public var effects:SkillEffects;
	
    public function new(id:String){
        this.id = id;
                
        super(Constants.skillDataPath + id + '.json', Constants.skillDataPath + 'stab.json');
        
        this.name = data.name;
        this.description = data.description;
        
        this.iconGraphic = data.iconGraphic;

		this.selectType = data.selectType ?? "";
		this.rangeX = data.rangeX ?? 1;
		this.rangeY = data.rangeY ?? 1;

		effects = mapSkillEffects(data);
	}

	public static function mapSkillEffects(data:Dynamic):SkillEffects
	{
		var thing:Array<StatusParams> = [];
		
		var effects:SkillEffects = {
			eff_damage: data.effects.eff_damage ?? 0,
			eff_heal: data.effects.eff_heal ?? 0,
			eff_statuses: StatusEffect.mapStatusParams(data.effects.eff_statuses) ?? thing,
		};

		return effects;
	}
}
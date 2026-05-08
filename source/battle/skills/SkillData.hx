package battle.skills;

class SkillData extends CtJsonLoader
{
    var id:String = "";
    
    public var name:String;
    public var description:String;
    
    public var iconGraphic:String;
    
	public var selectType:String;
    
	// skill effects hehe
	public var eff_damage:Int;
	public var eff_heal:Int;
    
    public function new(id:String){
        this.id = id;
                
        super(Constants.skillDataPath + id + '.json', Constants.skillDataPath + 'stab.json');
        
        this.name = data.name;
        this.description = data.description;
        
        this.iconGraphic = data.iconGraphic;

		this.selectType = data.selectType ?? "";
		// skill effects hehe
		this.eff_damage = data.eff_damage ?? 0;
		this.eff_heal = data.eff_heal ?? 0;
    }
}
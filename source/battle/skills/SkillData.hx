package battle.skills;

class SkillData extends CtJsonLoader
{
    var id:String = "";
    
    public var name:String;
    public var description:String;
    
    public var iconGraphic:String;
    
    public function new(id:String){
        this.id = id;
                
        super(Constants.skillDataPath + id + '.json', Constants.skillDataPath + 'stab.json');
        
        this.name = data.name;
        this.description = data.description;
        
        this.iconGraphic = data.iconGraphic;
    }
}
package units;

class UnitData extends CtJsonLoader
{
    var id:String = "";
    
    public var name:String;
    
    public var gridGraphic:String;

	public var maxHp:Int;
	public var speed:Int;
    
    public function new(id:String){
        this.id = id;
                
        super(Constants.unitDataPath + id + '.json', Constants.unitDataPath + 'chair.json');
        
        this.name = data.name;
        this.gridGraphic = data.gridGraphic;
		this.maxHp = data.maxHp;
		this.speed = data.speed;
    }
}
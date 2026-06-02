package overworld.character;

class CharacterData extends CtJsonLoader
{
	public var id:String;
    
    public var name:String;
    public var graphic:String;
	public var noclip:Bool;
    public function new(id:String){
        this.id = id;
        
		super(Constants.characterDataPath + id + '.json', Constants.characterDataPath + 'mc.json');
        
        this.name = data.name ?? "";
        this.graphic = data.graphic ?? "mc";
		this.noclip = data.noclip ?? false;
    }
}
package overworld.door;

class DoorData extends CtJsonLoader
{
    var id:String;
    
    public var name:String;
    public var graphic:String;
    
    public var openSound:String;
    public var lockSound:String;

    public function new(id:String){
        this.id = id;
        
        super(Constants.doorDataPath + id + '.json', Constants.doorDataPath + 'placeholder.json');
        
        this.name = data.name;
        this.graphic = data.graphic;
        
        this.openSound = data.openSound ?? "";
        this.lockSound = data.lockSound ?? "";
    }
}
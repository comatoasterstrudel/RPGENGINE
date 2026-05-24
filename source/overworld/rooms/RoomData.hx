package overworld.rooms;

class RoomData extends CtJsonLoader
{
	public var id:String;
    
    public var name:String;
    public var map:String;
    
    public function new(id:String){
        this.id = id;
        
		super(Constants.roomDataPath + id + '.json', Constants.roomDataPath + 'test.json');
        
        this.name = data.name ?? "";
        this.map = data.map ?? "test";
    }
}
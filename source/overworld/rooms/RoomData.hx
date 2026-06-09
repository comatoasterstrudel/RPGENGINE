package overworld.rooms;

class RoomData extends CtJsonLoader
{
	public var id:String;
    
    public var name:String;
    public var map:String;
    
	public var encounters:Array<EncounterData>;
	public var encounterChance:Float;
    
	public var lighting:Float;
	
	public var script:Array<String>;
	
    public function new(id:String){
        this.id = id;
        
		super(Constants.roomDataPath + id + '.json', Constants.roomDataPath + 'test_test.json');
        
        this.name = data.name ?? "";
        this.map = data.map ?? "test";
		if (data.encounters == null)
		{
			encounters = [];
		}
		else
		{
			encounters = data.encounters.map(function(item)
			{
				return {
					battleName: item.battleName,
					rarity: item.rarity
				};
			});
		}
		this.encounterChance = data.encounterChance ?? 10;
		this.script = data.script ?? cast [];
		this.lighting = data.lighting == null ? 0 : data.lighting;
    }
}
package save.storyflags;

class StoryFlagData extends CtJsonLoader
{
    public var id:String;

    public var val_string:String;
    public var val_bool:Bool;
    public var val_int:Int;
    public var val_float:Int;
    
    public function new(id:String){
        this.id = id;
        
		super(Constants.storyFlagsDataPath + id + '.json', Constants.storyFlagsDataPath + 'test_test.json');
        
        this.val_string = data.val_string ?? "";
        this.val_bool = data.val_bool ?? false;
        this.val_int = data.val_int ?? 0;
        this.val_float = data.val_float ?? 0;
    }
}
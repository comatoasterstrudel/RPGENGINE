package save.storyflags;

class StoryFlag
{
    public var id:String = "";
    
    public var data:StoryFlagData;
    
    public var val_string:String = "";
    public var val_bool:Bool = false;
    public var val_int:Int = 0;
    public var val_float:Int = 0;
    
    public function new(id:String):Void{
        this.id = id;
        
        data = new StoryFlagData(id);
    }
    
    public function restoreDefault():Void{
        this.val_string = data.val_string;
        this.val_bool = data.val_bool;
        this.val_int = data.val_int;
        this.val_float = data.val_float;
    }
}
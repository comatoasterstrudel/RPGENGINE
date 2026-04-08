package cursor;

class Cursor extends CtSprite
{
    public function new(path:String):Void{
        super();
        
		createFromImage(path);
    }
}
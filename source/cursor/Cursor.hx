package cursor;

class Cursor extends CtSprite
{
    public function new(path:String):Void{
		super(0, 0, false);
        
		createFromImage(path);
    }
}
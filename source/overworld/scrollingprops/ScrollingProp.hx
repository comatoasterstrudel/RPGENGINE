package overworld.scrollingprops;

class ScrollingProp extends CtCroppedBackdrop
{
    public var tag:String = "";
    
    public function new(tag:String, graphicPath:String, x:Int, y:Int, cropWidth:Int, cropHeight:Int):Void{
        super(graphicPath, x, y, cropWidth, cropHeight);
        this.tag = tag;
    }
}
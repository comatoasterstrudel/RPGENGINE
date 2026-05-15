package battle.result;

class ResultState extends FlxSubState
{
    var bg:CtSprite;
        
    var bigText:CtText;
    
    var texts:FlxTypedGroup<CtText>;
    
    var camMenu:FlxCamera;
    
    var type:ResultType;
    
    var optionList:Array<String> = ["Replay", "Exit to Menu"];
    
    var menuManager:CtMenuManager;
    
    var animManager:CtEventManager;
    
    public function new (type:ResultType){
        super();
        
        this.type = type;
        
        camMenu = new FlxCamera();
		camMenu.bgColor.alpha = 0;
		FlxG.cameras.add(camMenu, false);
        
        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = .9;
        bg.camera = camMenu;
        add(bg);
        
        bigText = new CtText(0,50,getBigText(),FlxAssets.FONT_DEFAULT, 50);
        bigText.screenCenter(X);
        bigText.camera = camMenu;
        add(bigText);
        
        texts = new FlxTypedGroup<CtText>();
        texts.camera = camMenu;
        add(texts);
        
        setUpMenu();
        populateOptions();
        
        doAnim();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        menuManager.update();
        animManager.update();
    }
    
    function getBigText():String{
        return switch(type){
            case WIN: "WIN";
            case LOSS: "LOSE";
            case TIE: "TIE";
            default: "???";
        };
    }
        
    function setUpMenu():Void{
        menuManager = new CtMenuManager(CtControls.getInputFunction("up", JUSTPRESSED), CtControls.getInputFunction("down", JUSTPRESSED),
			CtControls.getInputFunction("accept", JUSTPRESSED), CtControls.getInputFunction("cancel", JUSTPRESSED));
            
        var cursor = new Cursor(Constants.cursorArrowGraphic);
        cursor.camera = camMenu;
        add(menuManager.addCursor(cursor, 20, false));
    }
    
    function populateOptions():Void{
        var options:Array<CtMenuOption> = [];
        
        for(i in 0...optionList.length){
            var text = new CtText(300, 300 + 100 * i, optionList[i], FlxAssets.FONT_DEFAULT, 30, false);
            text.color = FlxColor.WHITE;
            texts.add(text);
                        
            options.push({sprite: text, cursorDirection: LEFT, clickFunction: function(spr):Void{
                switch(optionList[i]){
                    case "Replay":
                        FlxG.resetState();
                    case "Exit to Menu":
                        FlxG.switchState(LevelSelectorState.new);
                }
            }});
        }
        
        menuManager.setMenuOptions([options]);
    }
    
    function doAnim():Void{
        bg.scale.set(0, 0);

        bigText.visible = false;
        
        for(i in texts.members){
            i.visible = false;    
        }
        
        animManager = new CtEventManager();
        animManager.reset();
            
        animManager.addEvent(function():Void{
            animManager.startTransaction("bgZoom");
            
            FlxTween.tween(bg.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut, onUpdate: function(s):Void{
                bg.updateHitbox();
                bg.screenCenter();               
            }, onComplete: function(f):Void{
                animManager.finishTransaction("bgZoom");
            }});
        });
        
        animManager.addEvent(function():Void{
            animManager.startTransaction("bigText");
            bigText.visible = true;
            
            FlxTween.shake(bigText, 0.1, .05, X);
            
            new FlxTimer().start(1, function(f):Void{
                animManager.finishTransaction("bigText");
            });
        });    
            
        for(i in texts.members){
            animManager.addEvent(function():Void{
                animManager.startTransaction("txt_" + i.text + i.ID);
                i.visible = true;
                
                FlxTween.shake(i, 0.05, .05, X);
                
                new FlxTimer().start(1, function(f):Void{
                    animManager.finishTransaction("txt_" + i.text + i.ID);
                });
            });    
        }
        
        animManager.addEvent(function():Void{
            menuManager.enable();
        });
    }  
}
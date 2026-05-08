package battle.events;

class EventManager
{
    public var eventQueue:Array<Void->Void> = [];
    
    public var currentTransactions:Array<EventTransaction> = [];
    
    public function new():Void{
        eventQueue = [];
        currentTransactions = [];
    }
    
    public function update():Void{
        if(currentTransactions.length <= 0 && eventQueue.length > 0){
            eventQueue[0]();
            eventQueue.remove(eventQueue[0]);
        }
    }
    
    public function addEvent(event:Void->Void):Void{
        this.eventQueue.push(event);
    }
    
    public function startTransaction(name:String):EventTransaction{
        var transaction = new EventTransaction(name);
        currentTransactions.push(transaction);
        return transaction;
    }
    
    public function finishTransaction(name:String):Void{
        var transaction = getTransactionFromName(name);
        
        if(transaction != null){
            currentTransactions.remove(transaction);
        }
    }
    
    function getTransactionFromName(name:String):EventTransaction
    {
        for(transaction in currentTransactions){
            if(transaction.name == name) return transaction;
        }
        
        return null;
    }
    
    public function reset():Void{
        eventQueue = [];
        currentTransactions = [];
    }
}
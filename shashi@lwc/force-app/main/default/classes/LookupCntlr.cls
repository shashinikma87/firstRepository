public class LookupCntlr {

    public User u {get; set ;}
    public Contact c {get; set ;}

    public LookupCntlr(){
        system.debug('in std constructor...stdSetController');
        
        c = new Contact();
    }
}
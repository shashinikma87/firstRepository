public class NEWDATATABLECNTLR {

    public List<Account> actList {get; set;}
    public boolean reRenderedPB2 {get; set;}
    
    public NEWDATATABLECNTLR ()
    {
        reRenderedPB2 = false;
        actList = new List<Account>();
        
        actList = [select Id, name from Account];
    }
    
}
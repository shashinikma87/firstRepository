public class testCntlr {
    
    Private static  Double rate = 7.75;
    
    //Integer w, x, y = 123, x = "abc";
    
    public Contact c {get; set;}
    public Account a {get {return new Account();} set;}
    List<Account> acctList = new List<Account>{new Account()};
        
    public testCntlr(ApexPages.StandardController cntlr){
     
        system.debug('in extension constructor..');
        this.c = (Contact)cntlr.getRecord();
    }

}
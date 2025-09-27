public class SampleController
{
    public List<Account> accList {get; set;}
    public List<accWrapper> wrapper {get; set;}
    public boolean isAllChecked {get; set;}
     
    public SampleController()
    {
        isAllChecked = false;
        wrapper = new List<accWrapper>();
        
    	accList = [SELECT Name, AccountNumber, Phone FROM Account LIMIT 10000];
        
        for (Account a : accList)
        {
            accWrapper wrapObj = new accWrapper();
            wrapObj.act = a;
            wrapObj.check = false;
            
            wrapper.add(wrapObj);
        }
    }
 
    public class accWrapper
    {
        public Account act {get; set;} 
        public boolean check {get; set;}
        
        public accWrapper()
        {
            act = new Account();
            check = false;
        }
    }
}
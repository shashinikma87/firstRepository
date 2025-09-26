public class nestedqueryexample
{
    public List<accWrapper> wrapList {get; set;}
    public boolean isParentChecked {get; set;}
    
    
    public nestedqueryexample()
    {
        wrapList = new List<accWrapper>();
        isParentChecked = true;
    }
    
    public void processData()
    {
        accWrapper accWrap = wrapList[0];
		accWrap.isAccChecked = false;
        accWrap.isDisabled = true;
        
        for(conWrapper cc : accWrap.conWrapperList)
        {
            cc.isChecked = false;
            cc.isDisabled = true;
        }
    }
    
    public void fetchData()
    {
        List<Account> accounts = [Select Id,(Select ID, FirstName From Contacts), Name, BillingCountry from Account  limit 10];
        
        for (Account a : accounts)
        {
            accWrapper wr = new accWrapper();
            wr.a = a;
            wr.isAccChecked = true;
           
            List<conWrapper> conWrapList = new List<conWrapper>();
            For(Contact cc : a.contacts)
            {
                conWrapper conWrap = new conWrapper();
                conWrap.isChecked = true;
				conWrap.con = cc;
                
                conWrapList.add(conWrap);
            }
            
            wr.conWrapperList = conWrapList;
            wrapList.add(wr);
        }
        
        //return wrapList;
    }
    
    
    public class accWrapper {
        
        public Account a {get; set;}
        public List<conWrapper> conWrapperList {get; set;}
        public boolean isAccChecked {get; set;}
        public boolean isDisabled {get; set;}
        
        public accWrapper()
        {
            a = new Account();
            isAccChecked = true;
            conWrapperList = new List<conWrapper>();
            isDisabled = false;
        }
    }
    
    public class conWrapper {
        
        public boolean isChecked {get; set;}
        public Contact con {get; set;}
        public boolean isDisabled {get; set;}
        
        public conWrapper()
        {
            con = new Contact();
            isChecked = true;
            isDisabled = false;
        }
    }
}
global class DTTBTry4 {

    public static String name {get; set;}
    public String accountName { get; set; }
    public static Account account { get; set; }
    
    public DTTBTry4()
    {
        name = 'XYZ';
    }
    
    
    
    @RemoteAction
    global static List<Account>  getAccount(String accountName) {
        List<Account> account = [SELECT Id, Name, Phone, Type, NumberOfEmployees FROM Account ];
        
        return account;
    }
    
    @RemoteAction
    public static List<contactsWrapper> getContacts ()
    {
        List<contactsWrapper> wrapList = new List<contactsWrapper>();
        
        List<Contact> cntList = new List<Contact>([SELECT Id, Name, AccountId, Email, Title FROM Contact ]);
        
        Integer i = 1;
        
        for(Contact c: cntList)
        {
            contactsWrapper wrapObj = new contactsWrapper();
            
			wrapObj.cnt = i;
            wrapObj.contID = c.id;
            wrapObj.contName = c.Name;
            if(c.AccountId!= NULL)
            	wrapObj.accId = c.AccountId;
            else 
                wrapObj.accId = '';
            
            wrapList.add(wrapObj);
            
            i++;
        }
        
        system.debug('wrapList size : '+wrapList.size());
        
        return wrapList;
    }
    
    
    @RemoteAction
    public static List<contactsWrapper> getNextContacts()
    {
        List<contactsWrapper> wrapList = new List<contactsWrapper>();
        
        List<Contact> cntList = new List<Contact>([SELECT Id, Name, AccountId, Email, Title FROM Contact Limit 5]);
        
        Integer i = 1;
        
        for(Contact c: cntList)
        {
            contactsWrapper wrapObj = new contactsWrapper();
            
			wrapObj.cnt = i;
            wrapObj.contID = c.id;
            wrapObj.contName = c.Name;
            if(c.AccountId!= NULL)
            	wrapObj.accId = c.AccountId;
            else 
                wrapObj.accId = '';
            
            wrapList.add(wrapObj);
            
            i++;
        }
        
        system.debug('wrapList size : '+wrapList.size());
        
        return wrapList;
    }
    
    
    
    public class contactsWrapper
    {
        Integer cnt {get; set;}
        ID contID {get; set;}
        String contName {get; set;}
        String accId {get; set;}
    }
    
    @RemoteAction
    public static String getName(String ipVal)
    {
        system.debug('passParam : '+ipVal);
        name = 'ABC';
        return name;
    }
}
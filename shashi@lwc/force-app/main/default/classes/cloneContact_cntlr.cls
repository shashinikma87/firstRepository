public class cloneContact_cntlr {
    
    @AuraEnabled
    public static ID createContact(Contact cnt)
    {
        System.debug(cnt);
        
        /*
        Contact newContact = new Contact();
        newContact.FirstName = cnt.FirstName;
        newContact.LastName = cnt.LastName;
        newContact.Email = cnt.Email;
        
        system.debug('Contact : '+cnt);
        Database.insert(newContact); 

		return newContact.id;
		*/
        
        return cnt.id;
    }

}
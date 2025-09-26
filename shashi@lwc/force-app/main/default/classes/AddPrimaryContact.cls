public class AddPrimaryContact implements Queueable  {

    private Contact contact;
    private String state;
    
    public AddPrimaryContact (Contact ct, String str){
        
        this.contact = ct;
        this.state = str;
	}
    
    public void execute (QueueableContext q) {
        
        List<Account> account_list = [select id, name from Account where BillingState =: state limit 200];
    
        List<Contact> contact_list = new List<Contact>();
        for (Account act : account_list) {
            
        	Contact ct_clone = contact.clone(false, true);
            ct_clone.AccountId = act.id;
            contact_list.add(ct_clone);
        }
        insert contact_list;
        System.debug('All contacts inserted..');
    }
}
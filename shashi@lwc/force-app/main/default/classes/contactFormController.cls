public class contactFormController extends contactFormController_Base
{
    
    public String firstName { get; set; }
	public String lastName { get; set; }
    
    public Contact resultingContact {get; set; }
    
    public void seachContact()
    {
        system.debug('firstName : '+firstName);
        system.debug('lastName : '+lastName);
        resultingContact = new Contact();
        
        resultingContact = [select ID, Name, Email From Contact WHERE Name like 'Test Contact%' LImit 1];
    }
}
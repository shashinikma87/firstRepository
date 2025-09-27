public class RandomContactFactory {

    public static List<Contact> generateRandomContacts (Integer num, String lastname){
        
        List<Contact> contacts = new List<Contact>();
        
        Account act = new Account (Name='Test Account');
        
        Integer i=0;
        for (i=0; i< num; i++){
            
            Contact cont = new Contact(FirstName='Test '+ i,LastName=lastname, AccountId = act.Id );
			contacts.add(cont);
            
        }
        return contacts;
    }
}
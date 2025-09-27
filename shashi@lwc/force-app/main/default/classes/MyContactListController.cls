public class MyContactListController {

    @AuraEnabled
	public static List<Contact> getContacts(Id recordId) {
   		return [Select Id, FirstName, LastName, Email, Phone From Contact Where AccountId = :recordId];
	}
    
    @AuraEnabled(cacheable=true)
    public static String getMessage() {
   		return 'Method called successfully..';
	}
}
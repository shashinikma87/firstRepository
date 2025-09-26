@isTest
public class AccountProcessorTest {
	
    @isTest static void testcountContacts() {
        List<ID> acc_ids = createTestRecords();
        Test.startTest();
        AccountProcessor.countContacts(acc_ids);
        Test.stopTest();
    }
    
    static List<Id> createTestRecords(){
        
        Account a1 = new Account(Name ='Account 1');
		insert a1;
        
        Contact c1 = new Contact(LastName = 'Contact 1', AccountId = a1.id);
        Contact c2 = new Contact(LastName = 'Contact 2', AccountId = a1.id);

        insert c1;
        insert c2;
        
        List<ID> ids = new List<ID>();
        ids.add(a1.id);
        
        return ids;
    }
}
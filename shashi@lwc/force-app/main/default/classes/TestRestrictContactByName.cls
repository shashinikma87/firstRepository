@isTest 
public class TestRestrictContactByName {

    @isTest static void testContactLastName (){
        
        Account acct = new Account(Name='Test Account');
        insert acct;
        
        Contact cont = new Contact (AccountId=acct.Id, LastName='INVALIDNAME');
        insert cont;
        
        Test.startTest();
        Database.saveResult result = Database.insert(cont, false);
        Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Cannot insert contact with this lastname.',
                             result.getErrors()[0].getMessage());
    }
}
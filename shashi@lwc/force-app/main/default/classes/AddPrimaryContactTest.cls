@isTest public class AddPrimaryContactTest {

    @testSetup static void createData(){
        
        List<Account> act_list = new List<Account>();
        Integer i=0;
        for (i=0; i<50; i++){
        	Account a = new Account (name = 'Name_'+i, BillingState='NY');
            Account b = new Account (name = 'Name_'+i, BillingState='CA');
            act_list.add(a);
            act_list.add(b);
        }
        insert act_list;
    }
    
    @isTest static void testAddPrimaryContact(){
    
        Contact ct = new Contact(LastName='lastname');
        
        AddPrimaryContact add = new AddPrimaryContact(Ct, 'CA');
        Test.startTest();
        ID jobID = System.enqueueJob(add);
		Test.stopTest();
    }
}
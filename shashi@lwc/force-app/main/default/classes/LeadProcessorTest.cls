@isTest public class LeadProcessorTest {

    @isTest static void setup(){
        
        Lead l1 = new Lead(LastName='lastname 1', Company = 'c1', LeadSource ='Web');
        insert l1;
        Lead l2 = new Lead(LastName='lastname 2', Company = 'c2',LeadSource ='Purchased List');
        insert l2;
        
        Test.startTest();
        
        LeadProcessor le = new LeadProcessor();
		Id batchId = Database.executeBatch(le, 100);
        
		Test.stopTest();
        
        System.assertEquals(2, [select count() from Lead where LeadSource = 'Dreamforce']);
	}
}
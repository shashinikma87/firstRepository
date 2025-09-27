@isTest
public class TestDataFactory {

    @isTest public static void createData(){
        
        DataFactory df = new DataFactory();
        df.createRecords(1);
        
        // Test Accounts
        List<String> act_name_list = new List<String>();
        act_name_list.add('Name 0');
        act_name_list.add('Name 1');
        List<Account> act_list = [select id, Name from Account where Name IN: act_name_list ];
        System.assertEquals(2,act_list.size());
     
        // Test Products
		List<String> prod_list = new List<String>();
        prod_list.add('Product 0');
        prod_list.add('Product 1');
        List<Product2> p_list = [select Name from Product2 where Name IN: prod_list ];
        System.assertEquals(2,p_list.size());
        
        // Test Opportunities
		List<String> op_list = new List<String>();
        op_list.add('Opty 0');
        op_list.add('Opty 1');
		Date dt = Date.newInstance(2017,06,02);
        List<Opportunity> opp_list = [select Name from Opportunity where Name IN: op_list and CloseDate = 2017-06-02 ];
        System.assertEquals(2,opp_list.size());
        
        // Create list od Ids of Opportunity
        List<Id> opp_ids = new List<ID>();
        opp_ids.add(opp_list[0].Id);
        opp_ids.add(opp_list[1].Id);
        
        // Retrieve Standard Pricebook ID
        Id pbStd = Test.getStandardPricebookId();
        System.assertEquals(pbStd, '01s6F000006qgGdQAI');
        
        // Test Pricebook2
        Pricebook2 pb = [select Name from Pricebook2 where Name = 'Price 1'];
        System.assertEquals(pb.Name, 'Price 1');
        
        // Test ProcebookEntry
        PricebookEntry pbe = [select Pricebook2Id from PricebookEntry where Pricebook2Id =: pbStd ];
        System.assertEquals(pbe.Pricebook2Id, '01s6F000006qgGdQAI');
        
        // Test OpportunityLineItem
        PricebookEntry pbe1 = [select Pricebook2Id from PricebookEntry where Pricebook2Id =: pb.Id and Product2Id =: p_list[0].Id ];
        List<OpportunityLineItem> oli = [select Id from OpportunityLineItem where OpportunityId IN: opp_ids and PricebookEntryId =: pbe1.Id];
        System.assertEquals(oli.size(),2);
    }
}
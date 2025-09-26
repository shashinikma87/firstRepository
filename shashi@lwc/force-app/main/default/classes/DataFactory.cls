public class DataFactory {
	
    public void createRecords (Integer cnt) {
        
        // Insert Accounts        
        Integer i = 0;
        List<Account> acts = new List<Account>();
        for (i=0; i<=cnt; i++) {
        	Account a = new Account (Name = 'Name '+i);
            acts.add(a); 
        }
        insert acts;

        // Insert Products
        Integer p = 0;
        List<Product2> prods = new List<Product2>();
        for (p=0; p<=cnt; p++) {
            
        	Product2 p2 = new Product2 (Name = 'Product '+p, ProductCode = 'Code '+p);
            prods.add(p2);
        }
		insert prods;

        // Insert Opportunities
        Integer j = 0;
        List<Opportunity> optys = new List<Opportunity>();
        Date dt = Date.newInstance(2017,06,02);
        for (j=0; j<=cnt; j++) {
            
        	Opportunity o = new Opportunity (Name = 'Opty '+j, CloseDate = dt, StageName= 'Prospecting', Discount_Percent__c = 0);
            optys.add(o);
        }
		insert optys;
        
       	// Retrieve Standard Pricebook ID
        Id pbStd = Test.getStandardPricebookId();

        // Insert Custom Pricebook
        Pricebook2 pb = new Pricebook2(Name = 'Price 1');
        insert pb;
        
        // Insert ProcebookEntry
        PricebookEntry pbeStd = new PricebookEntry(Pricebook2Id = pbStd, Product2Id = prods[0].Id, UnitPrice = 300, IsActive = true);
        insert pbeStd;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prods[0].Id, UnitPrice = 200,  IsActive = true);
        insert pbe;
        
        // Insert OpportunityListItem
        Integer k = 0;
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        for (k=0; k<=cnt; k++) {
            
        	OpportunityLineItem oli = new OpportunityLineItem (OpportunityId = optys[k].Id, Quantity = 1, TotalPrice = 100, PricebookEntryId = pbe.Id );
            olis.add(oli);
        }
		insert olis;        
    } 
}
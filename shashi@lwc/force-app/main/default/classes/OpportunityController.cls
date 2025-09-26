public with sharing class OpportunityController {

    public ApexPages.StandardController stdCntrlr {get; set;}
    public Opportunity currentRecord{get; set;}
    public static String Id {get; set;}
    
    public static String Id1;
    
    public OpportunityController(ApexPages.StandardController controller) {
        
        stdCntrlr = controller;
        String a = ApexPages.currentPage().getParameters().get('id');
        System.debug('IDDD : ' + a);
        currentRecord = [SELECT Id, Name, Amount FROM Opportunity WHERE Id =: a ];
        System.debug('Current Record : ' + currentRecord );
        Id1 = a;
    }

    @RemoteAction
    public static List<List<String>> doGetText(String Ids) {
        
        System.debug('in doGetTExt method..' + Ids );      
        List<OpportunityLineItem> opty_list = [ SELECT Name,UnitPrice, OpportunityId,Product2Id,ProductCode FROM OpportunityLineItem where OpportunityId =: Ids ];
        
        List<List<String>> total_list = new List<List<String>>();
        for (OpportunityLineItem  o: opty_list) {
        
            List<String> lst = new List<String>();
            String b ='';
            lst.add(b);
            lst.add(o.id);
            lst.add(o.Name);
            lst.add(String.valueOf(o.UnitPrice));
            total_list.add(lst);
        }
        
        return total_list;
    }
    
    @RemoteAction
    public static void addOptys(List<OpportunityLineItem> optys){
        
        System.debug('Upsert data : ' + optys);
        upsert optys;
    }
}
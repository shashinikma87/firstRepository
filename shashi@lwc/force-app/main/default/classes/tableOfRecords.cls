public class tableOfRecords {

    public List<Lead> leads {get;set;}
    public boolean isSelectAll {get;set;}
    public boolean eachRow {get;set;}
    
    
    public tableOfRecords(ApexPages.StandardController controller){
        
        leads = [select id, name, Company, Email, Status from Lead];
    }
}
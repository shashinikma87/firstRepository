public class insetDataIncustom {

    public void insertData(String value ){
        
        googleDrive__c g = new googleDrive__c(Name=value, accessToken__c=value);
        
        insert g;
        
        System.debug(g);
    }
}
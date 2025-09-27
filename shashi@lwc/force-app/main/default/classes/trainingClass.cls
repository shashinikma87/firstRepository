public with sharing class trainingClass {

    public trainingClass() {

    }

    @AuraEnabled
    public static List<Account> fetchAccountsList(String accLimit){

        String q = 'select Id, Name from Account Limit '+accLimit;
        List<Account> aList = Database.query(q);

        //List<Account> aList = new List<Account>([select Id, Name from Account Limit : accLimit]);
        return aList;
    }

    @AuraEnabled
    public static List<Account> fetchAccountsList1(Date dt1, Date dt2){
        
        system.debug('dt1 : '+dt1);
        system.debug('dt2 : '+dt2);
        return ([select Id, Name from Account where createdDate >=: dt1  AND createdDate <=: dt2]);
        //List<Account> aList = Database.query(q);

        //List<Account> aList = new List<Account>([select Id, Name from Account Limit : accLimit]);
        //return aList;
    }

    @AuraEnabled
    public static List<Opportunity> fetchAccountsList2(Date dt1, Date dt2){
        
        system.debug('dt1 : '+dt1);
        system.debug('dt2 : '+dt2);
        return ([select Id, Name from Opportunity where createdDate >=: dt1  AND createdDate <=: dt2]);
        //List<Account> aList = Database.query(q);

        //List<Account> aList = new List<Account>([select Id, Name from Account Limit : accLimit]);
        //return aList;
    }
}
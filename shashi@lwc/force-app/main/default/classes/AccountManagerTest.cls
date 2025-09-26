@isTest public class AccountManagerTest {

    @isTest static void testAccountManager() {
        ID acc_id = createTestRecord();
        
        RestRequest request = new RestRequest();
        
        request.requestUri = 'https://ap4.salesforce.com/services/apexrest/Accounts/' + acc_id + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Account acm = AccountManager.getAccount();
        System.assert(acm != null);
        System.assertEquals('test record',acm.Name);
    }
    
    static ID createTestRecord() {
    
        Account ac = new Account(Name = 'test record');
        insert ac;
        
        System.debug('Acount ID : ' + ac.id);
        
        Contact ct = new Contact(LastName = 'contact 1', AccountId = ac.id);
        //insert ct;
        return ac.id;
    }
}
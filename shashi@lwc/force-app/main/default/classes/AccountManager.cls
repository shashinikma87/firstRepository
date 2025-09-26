@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {

    @HttpGet 
    global static Account getAccount () {

        RestRequest request = RestContext.request;
        System.debug('URI => ' + request.requestUri);
        String acc_id = request.requestUri.substringBetween('/Accounts/', '/contacts');
        
        system.debug('between id : ' + acc_id); 
        
        Account acc = [ SELECT Id,Name, (select id, name from Contacts) FROM Account where Id =: acc_id ];
System.debug('Result : ' + acc);
        return acc;
    }
}


// write test class for the above class
@isTest
private class AccountManagerTest {

    @IsTest
    static void testGetCaseById() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test Contact');
        insert con;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();  
        req.requestUri = 'https://ap5.salesforce.com/services/apexrest/Accounts/'+acc.Id+'/contacts';
        req.httpMethod = 'GET';
        RestContext.request = req;  
        RestContext.response = res;
    }
} 

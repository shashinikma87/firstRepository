public class createRemoteSiteSettings {

	public String sessionId;
    private String serverUrl;
	private String orgId;     
    private String origLocale;    
    private String userId;    

    public void createRemoteSiteSetting()
    {} 
    
    public void login() 
    {   
        string sEndPoint = 'https://login.salesforce.com/services/Soap/u/26.0'; 
        
        PartnerRemote.Soap soap = new PartnerRemote.Soap();

        //PartnerRemote.LoginResult loginResult = soap.login('shashi@test.com', 'May@1234' + 'N7wh4BPXNRTfxnmhkgq7zoxi', sEndPoint);
        PartnerRemote.LoginResult loginResult = soap.login('shashi1@test.com', 'May@1234' + 'xUIpUk7C6VpEGqoI52IhJQFR', sEndPoint);
        
        soap.endpoint_x = loginResult.serverUrl; 
        serverUrl = loginResult.serverUrl.split('/services')[0]; 
        sessionId = loginResult.sessionId; 
        orgId = loginResult.userInfo.organizationId; 
        origLocale = loginResult.userInfo.userLocale; 
        userId = loginResult.userInfo.userId; 
        
        //createListView();
    }
    
    public void login1() 
    {   
        string sEndPoint = 'https://login.salesforce.com/services/Soap/u/26.0'; 
        
        PartnerRemote.Soap soap = new PartnerRemote.Soap();

        PartnerRemote.LoginResult loginResult = soap.login('shashi@test.com', 'Jan@2020' + 'v1DYIo42bJWUCYsp3dXiTXmA', sEndPoint);
        //PartnerRemote.LoginResult loginResult = soap.login('shashi1@test.com', 'May@1234' + 'xUIpUk7C6VpEGqoI52IhJQFR', sEndPoint);
        
        soap.endpoint_x = loginResult.serverUrl; 
        serverUrl = loginResult.serverUrl.split('/services')[0]; 
        sessionId = loginResult.sessionId; 
        orgId = loginResult.userInfo.organizationId; 
        origLocale = loginResult.userInfo.userLocale; 
        userId = loginResult.userInfo.userId; 

        retrieveWorkflows();
    }
        
    public void retrieveWorkflows()
    {
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl = baseUrl.replace('visual.force', 'salesforce');
        baseUrl = baseUrl.replace('https://c.', 'https://');
		MetadataService.SERVER_URL = baseUrl;
        String userId = UserInfo.getUserId();
        sessionId = UserInfo.getSessionId();
        
        
        MetadataService.MetadataPort service = createService();     
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();        
        
        MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
        queryWorkflow.type_x = 'WorkflowRule';
        queries.add(queryWorkflow);     
        MetadataService.ListMetadataQuery queryValidationRule = new MetadataService.ListMetadataQuery();
        queryValidationRule.type_x = 'ValidationRule';
        //queries.add(queryValidationRule);           
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
            System.debug(fileProperty.id);
        	System.debug(fileProperty.fullName);
            //system.debug('fileProperty : '+fileProperty);
        }
        
    }
    
   
    
	//@future(callout=true)
    public static void futureRestCallout(String sessId, String serverURL)
    {
        string sEndPoint = 'https://login.salesforce.com/services/Soap/u/26.0'; 
        
        PartnerRemote.Soap soap = new PartnerRemote.Soap();

        //PartnerRemote.LoginResult loginResult = soap.login('shashi@test.com', 'May@1234' + 'N7wh4BPXNRTfxnmhkgq7zoxi', sEndPoint);
        PartnerRemote.LoginResult loginResult = soap.login('shashi1@test.com', 'May@1234' + 'xUIpUk7C6VpEGqoI52IhJQFR', sEndPoint);
        
        soap.endpoint_x = loginResult.serverUrl; 

        PageReference theUrl = new PageReference(serverUrl + '/setup/systemOverview.apexp');
        HttpRequest request1 = new HttpRequest();
        request1.setEndpoint(theUrl.getUrl());     
        //request1.setEndpoint('https://shashi1-dev-ed.my.salesforce.com/setup/systemOverview.apexp');
        
        request1.setMethod('GET');
        
        request1.setHeader('Authorization', 'OAuth ' + loginResult.sessionId);
        request1.setHeader('X-PrettyPrint', '1');
        //request1.setTimeout(60000);
        HttpResponse response1 = new HttpResponse();
        response1 = (new Http()).send(request1);
        system.debug('Body : '+response1.getBody());
    }
    
    public void createListView()
    {
        //string sEndPoint = 'https://cs25.salesforce.com/services/Soap/u/26.0'; 
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        baseUrl = baseUrl.replace('visual.force', 'salesforce');
        baseUrl = baseUrl.replace('https://c.', 'https://');
		MetadataService.SERVER_URL = baseUrl;
        String userId = UserInfo.getUserId();
        sessionId = UserInfo.getSessionId();
        String userName = UserInfo.getName();
        String s = 'Invoices_' + userId;
        
        
        
        system.debug(' MetadataService.SERVER_URL : '+MetadataService.SERVER_URL);
        system.debug('serverUrl : '+serverUrl);

        //PageReference theUrl = new PageReference('https://shashi1-dev-ed.my.salesforce.com/setup/systemOverview.apexp');
        PageReference theUrl = new PageReference(serverUrl + '/setup/systemOverview.apexp');
        
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(theUrl.getUrl());     
     	//request.setEndpoint('https://snikam-dev-ed.my.salesforce.com/setup/systemOverview.apexp');

        system.debug('Requested End Point URL : '+theUrl.getUrl());
        
        request.setMethod('GET');
        Boolean setSid = false;
        if (setSid) 
        {
            request.setHeader('Cookie', 'sid=' + sessionId + ';');  
        }
        else 
        {
            request.setHeader('Authorization', 'OAuth ' + sessionId);
            request.setHeader('X-PrettyPrint', '1');
        }
        request.setTimeout(60000);
        HttpResponse response = new HttpResponse();
        
        try 
        {
            system.debug('m here 1...');
        	response = (new Http()).send(request);
            system.debug('Response Body : '+response.getBody());
        }
        catch(Exception e)
        {
            system.debug('Exception while sending request : '+e);
            
            MetadataService.MetadataPort service = createService();
            MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
            remoteSiteSettings.fullName = 'shashi1';
            remoteSiteSettings.url = serverUrl;
            //remoteSiteSettings.url = 'https://shashi1-dev-ed.my.salesforce.com';
            remoteSiteSettings.description = 'ewf';
            remoteSiteSettings.isActive = true;
            remoteSiteSettings.disableProtocolSecurity = false;
            
            List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
            results = service.createMetadata(new MetadataService.Metadata[] { remoteSiteSettings });
            system.debug('chk : ' + results );
            
            system.debug('body : '+response.getBody());
            
            futureRestCallout(sessionId, serverUrl);
            
            /*
            theUrl = new PageReference(serverUrl + '/setup/systemOverview.apexp');
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint(theUrl.getUrl());     
            //request.setEndpoint('https://snikam-dev-ed.my.salesforce.com/setup/systemOverview.apexp');
            
            system.debug('Requested End Point URL 2 : '+theUrl.getUrl());
            
            request1.setMethod('GET');
            setSid = false;
            if (setSid) 
            {
                request1.setHeader('Cookie', 'sid=' + sessionId + ';');  
            }
            else 
            {
                request1.setHeader('Authorization', 'OAuth ' + sessionId);
                request1.setHeader('X-PrettyPrint', '1');
			}
            request1.setTimeout(60000);
            HttpResponse response1 = new HttpResponse();
            response1 = (new Http()).send(request1);
            system.debug('Body : '+response1.getBody());
			*/
        }
    }
    
    public MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        return service;		
    }

/*
    // PARSING FUNCTIONS ===========================================================================================    
    private Boolean parseSystemOverview()
    {
        String body = getPage('/setup/systemOverview.apexp', false);
        system.debug('body=='+body);
        // IF PASSWORD CHANGED, BAIL
        if (detectChangePassword(body))
        {
            return false;
        }
        Matcher pattApiUsage = Pattern.compile('usage_block_api_num_1"><span class="textOnly">(.+)<').matcher(body);
        Matcher pattApiAllocation = Pattern.compile('</span>\\(.*? (\\d.+)\\)').matcher(body.substringAfter('j_id0:j_id12:1:j_id16:j_id17:j_id24:0:j_id52')); 
        Matcher pattDataStorage = Pattern.compile('usage_block_schema_num_3">.*>(.+)&nbsp;(GB|MB|KB)</a>').matcher(body);
        Matcher pattDataAllocation = Pattern.compile('</span>.*? (\\d.+)&nbsp;(MB|GB|KB)\\)').matcher(body.substringAfter('j_id0:j_id12:0:j_id16:j_id17:j_id24:2:j_id52'));

        pattApiUsage.find();
        
        system.debug('pattApiUsage : '+pattApiUsage.find());
        
        result.ApiUsage__c = getDecimal(pattApiUsage.group(1).replace(',', ''));        
        pattApiAllocation.find();
        result.ApiAllocation__c = getDecimal(pattApiAllocation.group(1));           
        pattDataStorage.find();
        result.DataStorageUsage__c = getGbAmount(pattDataStorage.group(1), pattDataStorage.group(2));       
        if (!pattDataAllocation.find()) 
        {
            pattDataAllocation = Pattern.compile('&nbsp;.*? .*? (\\d.*?)&nbsp;(GB|MB|KB)').matcher(body.substringAfter('j_id0:j_id12:0:j_id16:j_id17:j_id24:2:j_id46'));
            pattDataAllocation.find();
        }
        result.DataStorageAllocation__c = getGbAmount(pattDataAllocation.group(1), pattDataAllocation.group(2));
        return true;
    }
     */

}
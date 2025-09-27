public class testMetadataApi {

    //public static final Integer METADATA_API_VERSION = Integer.valueOf(new MetadataService.MetadataPort().endpoint_x.substringAfterLast('/'));
    public static final Integer METADATA_API_VERSION = 40;
    public static map<String, String> session_info = new map<String, String>();
    
    public static MetadataService.MetadataPort createService()
	{ 
        connect('Production', 'riach@cyb.com','Papa@456','','00D28000001eYe4');
        
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = session_info.get('SESSION_ID');
        System.debug('service.SessionHeader :'+service.SessionHeader);
		return service;		
        
	}
    
    public static void getMetadata () {
        
        /*
        System.debug('METADATA_API_VERSION :'+METADATA_API_VERSION);
        // ============= 1 =================
        MetadataService.MetadataPort service = createService();        
        MetadataService.RetrieveRequest retrieveRequest = new MetadataService.RetrieveRequest();
        retrieveRequest.apiVersion = METADATA_API_VERSION;
        retrieveRequest.packageNames = null;
        retrieveRequest.singlePackage = true;
        retrieveRequest.specificFiles = null;
        retrieveRequest.unpackaged = new MetadataService.Package_x();
        retrieveRequest.unpackaged.types = new List<MetadataService.PackageTypeMembers>();
        MetadataService.PackageTypeMembers packageType = new MetadataService.PackageTypeMembers();
        packageType.name = 'InstalledPackage'; 
        //packageType.members = new String[] { MetadataFolder, MetaDataItem };
        packageType.members = new String[] { '', 'copado' };
            retrieveRequest.unpackaged.types.add(packageType);
        MetadataService.AsyncResult AsyncResult = service.retrieve(retrieveRequest);
        System.debug('AsyncResult :'+AsyncResult);
        
        //List<MetadataFile> MetadataFiles;
		MetadataService.RetrieveResult retrieveResult = service.checkRetrieveStatus(AsyncResult.Id,false);
		if(retrieveResult.done)
		{
            String MetaDataRetrieveZip = retrieveResult.zipFile;
            System.debug('MetaDataRetrieveZip :'+MetaDataRetrieveZip);
			//MetadataFiles = new List<MetadataFile>();
            //System.debug('MetadataFiles :'+MetadataFiles);
        }*/
        

        /*	
		// ============= 2 =================
		MetadataService.MetadataPort service = createService();	
		List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();		
		MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
		queryWorkflow.type_x = 'InstalledPackage';
		queries.add(queryWorkflow);		
		
		MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 32);
		
        List<String> folderNames = new List<String>();
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
            //System.debug('fileProperty : '+fileProperty);
            //System.debug('Fullname : '+fileProperty.fullName);
            System.debug('namespacePrefix : '+fileProperty.namespacePrefix);
            folderNames.add(fileProperty.fileName.replace('documents/', ''));
        }
        */
        
        //MetadataService.MetadataPort service = createService();	
        
        // ============= 3 =============== 
        MetadataService.MetadataPort service = createService();	
        List<String> NameList = new List<String>();
        NameList.add('agf');	// QOTD, trailheadapp
        MetadataService.IReadResult readResult = service.readMetadata('InstalledPackage', NameList);
        	System.debug('readResult : '+readResult);
        
        //List<MetadataService.Metadata> t = readResult.getRecords();
        List<MetadataService.InstalledPackage> t = (List<MetadataService.InstalledPackage>)readResult.getRecords();
        //MetadataService.InstalledPackage ins = (MetadataService.InstalledPackage)t[0];
        //system.debug('ins'+ins.versionNumber);
        system.debug('t'+t[0].versionNumber);
        
        
        

        /*
        // ============= 4 ==============
		MetadataService.MetadataPort service = createService();
        //service.SessionHeader = new MetadataService.SessionHeader_element();
        //service.SessionHeader.sessionId = UserInfo.getSessionId();
        
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery queryDocumentFolder = new MetadataService.ListMetadataQuery();
        queryDocumentFolder.type_x = 'InstalledPackage';
        queries.add(queryDocumentFolder);
        system.debug('========queries====='+queries);
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 42);
        system.debug('========fileProperties====='+fileProperties);
        //List folderNames = new List();
        List<String> folderNames = new List<String>();
		for(MetadataService.FileProperties fileProperty : fileProperties){

            //System.debug('fileProperty :' +fileProperty); 
            System.debug('fullName : '+fileProperty.fullName);
            //System.debug('namespacePrefix_type_info : '+fileProperty.namespacePrefix_type_info);
        }
        //System.debug('folderNames :'+folderNames);
        */
        
    }
    
    
    //-----------------------------------
    // Login via SOAP/XML web service api
    //-----------------------------------
    public static map<String, String> connect(String org_type, string loginUsername,string loginPassWd, string secToken,String srcOrgID) 
    {
		String login_success = 'false';
       
        // CONCATINATE PASSWORD AND SECURITY TOKEN FOR LOGIN THROUGH API
        string loginPass = loginPassWd+''+secToken;
        
		session_info.put('login_success', login_success);
		session_info.put('orgId', srcOrgID);
        session_info.put('ExpiredPassword', 'False');
        
        // IF USERNAME IS NULL SKIP CALLING API'S
        if(loginUsername  != '') {
            try {
                // CREATE NEW HTTP REQUEST TO LOGIN IN ORG  
                Httprequest request = getHttpRequests('https://login.salesforce.com/services/Soap/u/36.0');
                
                if (org_type.contains('Sandbox')) {
                    request = getHttpRequests('https://test.salesforce.com/services/Soap/u/36.0');
                }
                   
                request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + loginUsername+ '</username><password>' + loginPass +secToken+ '</password></login></Body></Envelope>');
                System.debug('request :'+request);
                httpresponse bodyresp2 = (new Http()).send(request);
                string Loginresp= bodyresp2.getBody(); // read login body
				system.debug('Login Response => '+Loginresp);
                
                // CHECK FOR INVALID LOGIN 
                if(Loginresp.containsignorecase('<soapenv:Fault><faultcode>'))
                {
                    Dom.XmlNode resultElmt1 = bodyresp2 .getBodyDocument().getRootElement()
                    .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/');
                    String faultcode = resultElmt1.getChildElement('faultcode',null).getText();
                    String faultstring = resultElmt1.getChildElement('faultstring',null).getText();
					System.debug('faultstring : '+faultstring);
					
                    session_info.put('login_success', 'false');
                    return session_info;
                }
                
                // CHECK FOR EXPIRED PASSWORD
                if (Loginresp.containsignorecase('<passwordExpired>true<')) 
                {
                    System.debug('Password Expired..');
                    session_info.put('login_success', 'false');
                    session_info.put('ExpiredPassword', 'True');
					return session_info;
                }

                // LOGIN IS UNSUCCESSFUL THEN SKIP ALL OTHER PROCESSES 
                if(!Loginresp.containsignorecase('<soapenv:Fault><faultcode>'))
                {
                    Dom.XmlNode resultElmt = bodyresp2 .getBodyDocument().getRootElement()
                        .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                        .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
                        .getChildElement('result', 'urn:partner.soap.sforce.com');
                    
                    // FETCH SESSION ID AND SERVER URL FROM RESPONSE
                    String SERVER_URL = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com') .getText().split('/services')[0];
                    String SESSION_ID = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com') .getText();
                    login_success = 'true';
                    session_info.put('SERVER_URL', SERVER_URL);
                    MetadataService.SERVER_URL = SERVER_URL;
                    session_info.put('SESSION_ID', SESSION_ID);
                    session_info.put('login_success', login_success);
                    system.debug('session_info'+session_info);
                }
            }
            catch (Exception e) {
                system.debug('Exception occured at '+e.getlinenumber()+'\n\n'+e.getMessage());
            }
        }
        return session_info;
    }
    
	public static httprequest getHttpRequests(string SERVER_URL){
        
        Httprequest request = new HttpRequest();
        //request.setEndpoint(SERVER_URL + '/services/Soap/c/36.0');
        request.setEndpoint(SERVER_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        //request.setHeader('Authorization', 'OAuth ' + SESSION_ID);
        return request;
    }

    public static HttpResponse getHttpResponse (Httprequest request, String SESSION_ID, String sql){
        
        HttpResponse permiResp = new HttpResponse();
        try {
        	request.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com">'+
                        '<soapenv:Header><urn:QueryOptions><urn:batchSize>2</urn:batchSize></urn:QueryOptions>'+
                        '<urn:SessionHeader><urn:sessionId>'+SESSION_ID+'</urn:sessionId></urn:SessionHeader>'+
                        '</soapenv:Header><soapenv:Body>'+
                        '<urn:query><urn:queryString>'+sql+'</urn:queryString>'+
                        '</urn:query></soapenv:Body></soapenv:Envelope>');      
        
        	permiResp = (new Http()).send(request);
        } 
        catch(Exception e) {
            System.debug('Exception captured in getHttpRespose : '+e.getlinenumber()+'\n\n'+e.getMessage());
        }
        return permiResp;
    }
    
}
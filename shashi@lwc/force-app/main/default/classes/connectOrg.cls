public class connectOrg {

    public static String sessionId;
    public static String SERVER_URL = '';
    public static String SESSION_ID = '';
    public Map<String, String> UserInfo{get; set;}

	public void connectOrg(){
    }
    
    public void connect() {
        
        UserInfo = new Map<String, String>();
            
        String loginUsername = 'shashi1@test.com';
        String loginPass = 'Newpass@123' + 'oTY4KUgaq5VnLIlmdFBez1eOk';
        
        Httprequest request = getHttpRequests('https://login.salesforce.com/services/Soap/u/36.0');
        request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + loginUsername+ '</username><password>' + loginPass + '</password></login></Body></Envelope>');
        HttpResponse resp = (new Http()).send(request);
        system.debug('Response : '+resp);
        
        DOM.Document xmlDOC = new DOM.Document();
        DOM.XmlNode node = resp.getBodyDocument().getRootElement()
            .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
            .getChildElement('loginResponse','urn:partner.soap.sforce.com')
            .getChildElement('result','urn:partner.soap.sforce.com');
        
        system.debug('Node : '+node);
        
        String org_type = '';
        String userId = '';
        String passwordExpired = '';
        String organizationName = '';
        String sessionSecondsValid = '';
        String userEmail = '';
        String userFullName = '';
        String userLanguage = '';
        String userName = '';
        String userType = '';
        String organizationId = '';
        String orgHasPersonAccounts = '';
        String orgAttachmentFileSizeLimit = '';
        
        
        for (Dom.XmlNode child : node.getChildElements()){
            
            system.debug('Node Name : '+child.getName() +' : '+child.getText());
            if (child.getName() == 'metadataServerUrl' && child.getName() != NULL)
                SERVER_URL = child.getText();
            	system.debug('SERVER_URL : '+SERVER_URL);
            	UserInfo.put('serverUrl',SERVER_URL);
            if (child.getName() == 'sandbox' && child.getName() != NULL)
                org_type = child.getText();
            	UserInfo.put('sandbox',org_type);
            if (child.getName() == 'sessionId' && child.getName() != NULL)
                SESSION_ID = child.getText();
            	UserInfo.put('sessionId',SESSION_ID);
            if (child.getName() == 'passwordExpired' && child.getName() != NULL)
                passwordExpired = child.getText();
            	UserInfo.put('passwordExpired',passwordExpired);
            if (child.getName() == 'userInfo' && child.getName() != NULL) {
                for (Dom.XmlNode innerChild : child.getChildElements()){
                    system.debug('Inner Node Name : '+innerChild.getName() +' : '+innerChild.getText());
                    if (innerChild.getName() == 'organizationName' && innerChild.getName() != NULL)
                		organizationName = innerChild.getText();
                    	UserInfo.put('organizationName',organizationName);
                    if (innerChild.getName() == 'sessionSecondsValid' && innerChild.getName() != NULL)
                		sessionSecondsValid = innerChild.getText();
                    	UserInfo.put('sessionSecondsValid',sessionSecondsValid);
                    if (innerChild.getName() == 'userEmail' && innerChild.getName() != NULL)
                		userEmail = innerChild.getText();
                    	UserInfo.put('userEmail',userEmail);
                    if (innerChild.getName() == 'userFullName' && innerChild.getName() != NULL)
                		userFullName = innerChild.getText();
                    	UserInfo.put('userFullName',userFullName);
                    if (innerChild.getName() == 'userLanguage' && innerChild.getName() != NULL)
                		userLanguage = innerChild.getText();
                    	UserInfo.put('userLanguage',userLanguage);
                    if (innerChild.getName() == 'userName' && innerChild.getName() != NULL)
                		userName = innerChild.getText();
                    	UserInfo.put('userName',userName);
                    if (innerChild.getName() == 'userType' && innerChild.getName() != NULL)
                		userType = innerChild.getText();
                    	UserInfo.put('userType',userType);
                    if (innerChild.getName() == 'organizationId' && innerChild.getName() != NULL)
                		organizationId = innerChild.getText();
                    	UserInfo.put('organizationId',organizationId);
                    if (innerChild.getName() == 'orgHasPersonAccounts' && innerChild.getName() != NULL)
                		orgHasPersonAccounts = innerChild.getText();
                    	UserInfo.put('orgHasPersonAccounts',orgHasPersonAccounts);
                    if (innerChild.getName() == 'orgAttachmentFileSizeLimit' && innerChild.getName() != NULL)
                		orgAttachmentFileSizeLimit = innerChild.getText();
                    	UserInfo.put('orgAttachmentFileSizeLimit',orgAttachmentFileSizeLimit);
                }
            }
         }
        system.debug('UserInfo : '+UserInfo); 
        
    }
    
    public void getData (){
        List<String> nameList1 = new List<String>();
        // METADATA API CALL TO GET PACKAGE VERSION NUMBER                                
        MetadataService.MetadataPort service = createService();
        List<String> nameList2 = new List<String>();
        nameList2.add('QOTD');
        MetadataService.IReadResult readResult = service.readMetadata('InstalledPackage', nameList2);
        //System.debug('readResult : '+readResult);
        List<MetadataService.InstalledPackage> t = (List<MetadataService.InstalledPackage>)readResult.getRecords();
        
        for(MetadataService.InstalledPackage ins : t){
            //String HRMPackageVersion = ins.versionNumber;
            system.debug('HRMPackageVersion : '+ins);
        }
    }
    
    private HttpRequest getHttpRequests (String URL){
        
    	HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        
        return request;
    }
    
    public MetadataService.MetadataPort createService()
	{   
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
		return service;		
	}
}
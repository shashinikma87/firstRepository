public class callApexRestAPI {


    public callApexRestAPI (){
        
        login('shashi1@test.com', 'sept@123', 'xamKjDDAotMo6yy2kjf6Tg8s', 'https://shashi1-dev-ed.my.salesforce.com/');
        system.debug('Login successful...');
        callRESTAPI();
    }

    
    public void callRESTAPI () {
        
        //Make sure your Salesforce instance URL is added in remote site settings
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        //String restAPIURL = 'https://shashi1-dev-ed.my.salesforce.com/services/apexrest/Cases/';
        String restAPIURL = 'https://shashi1-dev-ed.my.salesforce.com/services/apexrest/Cases/';
        
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');   
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); 
        httpRequest.setEndpoint(restAPIURL);  
        String response = '';
        try {  
            Http http = new Http();   
            HttpResponse httpResponse = http.send(httpRequest);  
            if (httpResponse.getStatusCode() == 200 ) {  
                response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) );  
            } else {  
                System.debug(' httpResponse ' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getBody() );  
            }   
        } catch( System.Exception e) {  
            System.debug('ERROR: '+ e);  
            throw e;  
        }  
        System.debug(' ** response ** : ' + response );  
        
    }
    
    
    
    public String sessionId;
    private String serverUrl;
    private String orgId;     
    private String origLocale;    
    private String userId;   
    
    // LOGIN USING WSDL / SOAP API 	-	(PartnerRemote FILE IS GENERATED USING PARTNER WSDL FILE)
    public void login(String uName, String pwd, String securityToken, String endPoint) 
    {   
        try {
            string sEndPoint = 'https://login.salesforce.com/services/Soap/u/26.0'; 
            
            PartnerRemote.Soap soap = new PartnerRemote.Soap();
            
            //PartnerRemote.LoginResult loginResult = soap.login('shashi@test.com', 'Jan@2020' + 'zZAWqE4wTsSZC5TzdrAYy6KJ', sEndPoint);
            PartnerRemote.LoginResult loginResult = soap.login(uName, pwd + securityToken, sEndPoint);
            
            soap.endpoint_x = loginResult.serverUrl; 
            serverUrl = loginResult.serverUrl.split('/services')[0]; 
            sessionId = loginResult.sessionId; 
            orgId = loginResult.userInfo.organizationId; 
            origLocale = loginResult.userInfo.userLocale; 
            userId = loginResult.userInfo.userId; 
                
        }
        catch(Exception e){
            system.debug('Found exception : '+e);
            system.debug('Line Nmber : '+e.getLineNumber());
        }
        
    }
    
    
    public static httprequest getHttpRequests(string SERVER_URL){
        
        Httprequest request = new HttpRequest();
        request.setEndpoint(SERVER_URL + '/services/Soap/c/36.0');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
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


/*
<apex:page standardController="Opportunity">
    
    <apex:form>
        <apex:outputLabel value="Account Name"/>
        <apex:inputText value="{!Opportunity.Account.Name}" Id="AccNameId"/> &nbsp;
        
        <!-- Custom Lookup for Account Record -->
        <apex:outputLink value="javascript:void(0);" onclick="openDialog('{!$Component.AccNameId}');">
            find
        </apex:outputLink>
    </apex:form>
    
    <script>
    	function openDialog(fieldId) {
            window.open('{!URLFOR($Page.myDialogPage)}' + '?accTagId=' + fieldId,
                        'Popup',
                        'height=500,width=800,resizable=no,left=100,top=100');
        }
    </script>
    
</apex:page>







<apex:page standardController="Account" recordSetVar="recs" sidebar="false" showHeader="false">
    
    <apex:form>
        <apex:pageBlock title="Select a Account from the list">
            <apex:pageBlockSection>
                <apex:pageBlockTable value="{!recs}" var="rec">
                    <apex:column>
                        <apex:inputCheckbox onchange="onchecked(this, '{!rec.Name}')" />
                    </apex:column>
                    <apex:column value="{!rec.Name}"/>
                    <apex:column value="{!rec.TickerSymbol}"/>
                    <apex:column value="{!rec.Website}"/>
                    <apex:column value="{!rec.AccountSource}"/>
                    <apex:column value="{!rec.Industry}"/>
                </apex:pageBlockTable>
            </apex:pageBlockSection>        
        </apex:pageBlock>        
    </apex:form>
    
    <script>
    	function onchecked(elmt, accName) {
            if (!elmt.checked || !window.parent || !accName) return;
            
            var document = (window.opener && window.opener.document) || 
                (indow.parent.opener && window.parent.opener.document);
            var accTag = document.getElementById('{!$CurrentPage.Parameters.accTagId}');
            accTag.value = accName;
            
            window.close();
        }
    </script>
</apex:page>



*/
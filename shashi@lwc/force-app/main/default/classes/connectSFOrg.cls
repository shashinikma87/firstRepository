// IMP LINK : https://www.gosquared.com/blog/salesforce-rest-api-integration
// authentication is the process of verifying who a user is, while authorization is the process of verifying what they have access to.
// 
// COPY BELOW URL IN BROWSER DIRECTLY 
// https://shashi1-dev-ed.my.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9d8..z.hDcPKhkfjsFBy.cePWRiUeTN9tWPoDya0waykohRTyP.2q9CQy37cypQS0SiB6FSnk29OT3HvW&redirect_uri=https://snikam-dev-ed.my.salesforce.com/services/oauth2/callback

// https://medium.com/@bpmmendis94/obtain-access-refresh-tokens-from-salesforce-rest-api-a324fe4ccd9b



//  Integration Interview Questions : 
//  
//  
//  https://www.apexhours.com/salesforce-integration-interview-questions/
//  



public class connectSFOrg {

    String instanceURL = 'https://shashi1-dev-ed.my.salesforce.com';
    String clientId = '3MVG9d8..z.hDcPKhkfjsFBy.cePWRiUeTN9tWPoDya0waykohRTyP.2q9CQy37cypQS0SiB6FSnk29OT3HvW';
    String clientSecret = 'C5CA1C02375F87BB65062566E481296B7CEF3409E3BDFD639ED37DC9FE6C2A82';
    String username= 'shashi1@test.com';
    String password= 'Newpass@123' + 'qzwT06Ty1Pli59WxQ9fLIZPN4';
    Map<String, Object> results;    
    
    public static boolean b = false;
    
    public connectSFOrg() { 
        
        system.debug('in constructor ... ');
        String code = ApexPages.currentPage().getParameters().get('code');
    } 
    
    
    public void generateEquifaxToken(){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Blob headerValue = Blob.valueOf('woZVT1JBSppdqMPNPuMEBOsnxPblAJe7' + ':' + 'jzkz3XSC2nYCLKyE');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);      
        request.setHeader('Authorization', authorizationHeader);
        request.setEndpoint('https://api.sandbox.equifax.com/v2/oauth/token');
        request.setBody('&grant_type=client_credentials');
        HttpResponse response = new HttpResponse();
        response = http.send(request);
        
        system.debug('in else response Status : ' + response.getStatusCode() + ' ' + response.getStatus());
        System.debug('response : '+response.getBody());
        
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        system.debug('results : '+results);
        system.debug('results : '+results.get('access_token'));
        
        
        /*
         Successful CURL -



curl -i -X POST \

-H "Content-Type:application/json" \

-H "scope:https://api.equifax.com/business/account-verification" \

-H "Authorization:Bearer GZ16G6epnG81MP0hYN7ZU7rxEDIN" \

-d \

'{

"merchantId": "efxtest",

"serviceType": "CV",

"identity": {

"name": {

"firstName": "Angela",

"lastName": "Ayers"

},

"addresses": {

"type": "CURRENT",

"streetAddress": "PO Box 29",

"city": "Abernant",

"state": "AL",

"zipCode": 35440

},

"identification": {

"ssn": 666238692,

"dob": "02/05/1964"

},

"contact": {

"emailAddress": "swimfan@aol.com",

"homePhone": 1234567890

},

"accounts": {

"creditCardNumber": "567808xxxxxx5120"

}

},

"consumerConsent": {

"consentEventDate": "2018-09-11T14:00:19.195Z",

"consentEvent": "opt-in",

"consentType": "whitelist",

"consentMethod": "TCO",

"consentForServices": [

"accountVerification"

]

}

}' \

'https://api.sandbox.equifax.com/business/account-verification/v2/account-validations'

OUTPUT -

{

"transactionId": "22345678-1234-1234-1234-123456789012",

"identity": {

"name": "Y",

"address": "Y",

"identification": {

"ssn": "Y",

"dob": "Y"

},

"contact": {

"emailAddress": "N",

"homePhone": "Y"

},

"account": {

"creditCardNumber": "Y"

}

}

}

 

         */
        
        
    }
    
    
    public void getToken()
    {
        system.debug('in getToken ... ');
        system.debug('params ... '+ ApexPages.currentPage().getParameters());
        String code = ApexPages.currentPage().getParameters().get('code');
        String authorization_endpoint = 'https://zoom.us/oauth/token';
        String reqBody = 'code='+ code +'&grant_type=authorization_code&client_id=sskOp3N8RRWnZyu_z4oxqg&client_secret=UtHXrOEU3Q1AepG8g7DRj1GVeIUF7nYP';
        //String reqBody = 'code='+ code +'&grant_type=authorization_code&client_id=sskOp3N8RRWnZyu_z4oxqg&client_secret=UtHXrOEU3Q1AepG8g7DRj1GVeIUF7nYP&state=123456&redirect_uri=https://snikam-dev-ed--c.ap4.visual.force.com/apex/loginPage';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setBody(reqBody);
        req.setEndpoint( authorization_endpoint); 
        HttpResponse res = h.send(req);
        system.debug('response : '+res.getBody());

        results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug('results : '+results);
        system.debug('results : '+results.get('access_token'));
		
    }
    
    // authorization Code 
    public void loginWithoutCreds ()
    {
        //String authorization_endpoint = 'https://shashi1-dev-ed.my.salesforce.com/services/oauth2/authorize';
        
        String callBackURI = 'https://snikam-dev-ed.my.salesforce.com/services/oauth2/callback';
        
        String authorization_endpoint = 'https://shashi1-dev-ed.my.salesforce.com/services/oauth2/authorize?response_type=code&client_id='+clientId+'&redirect_uri='+callBackURI;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        //req.setBody(reqbody);
        req.setMethod('GET');
        req.setEndpoint( authorization_endpoint); 
        HttpResponse res = h.send(req);
        system.debug('response : '+res.getBody());
    }
    
    
    // USING OAUTH AUTHORIZATION SEND CREDENTIALS IN BODY USING POST 
    // grant_type   =   password
    // LOGIN USING REST API
    public PageReference connectUsingOAuth()
    {
        /*
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        */
        String redirect_URI = 'https://snikam-dev-ed--c.ap4.visual.force.com/apex/loginPage';
        

        // USE BELOW URL AS CALLBACK URL IN CONNECTED APP IN shashi1@test.com
        // https://snikam-dev-ed--c.ap4.visual.force.com/apex/loginPage

        String authorization_endpoint = 'https://shashi1-dev-ed.my.salesforce.com/services/oauth2/authorize';
        
        //String scope = 'com.intuit.quickbooks.accounting';
        
        String final_EndPoint = authorization_endpoint+'?client_id='+clientId+'&response_type=code&state=123445633443&redirect_uri='+redirect_URI;
        
        final_EndPoint = 'https://zoom.us/oauth/authorize?client_id=sskOp3N8RRWnZyu_z4oxqg&response_type=code&redirect_uri=https://snikam-dev-ed--c.ap4.visual.force.com/apex/loginPage';
        
        PageReference pageRef = new PageReference(final_EndPoint);
        b = true;
        return pageRef;

/*        
 * 
 * JSON WEB TOKEN
 * 
 * 
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint( instanceURL +'/services/oauth2/token'); // Note if my domain is set up use the proper domain name else use login.salesforce.com 
                                                                //  for prod or developer or test.salesforce.com for sandbox instance
        HttpResponse res = h.send(req);
        system.debug('response : '+res.getBody());
        results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        system.debug('results : '+results.get('access_token'));
        //getRESTRESOURCEAccounts ();
        
        */
    }
    
    // grant_type=client_credentials
    // grant_type=password
    // grant_type=refresh_token
    // grant_type=authorization_code
    // https://login.salesforce.com/services/oauth2/authorize?response_type=code
    // &client_id=YOURCONSUMERID&redirect_uri=https://www.yourappname.com/api/callback
    
    // LOGIN USING SOAP API
    public void loginUsingSOAP_XML()
    {
        String LOGIN_DOMAIN = 'www';
        String pwd = 'sept@123';
        String userName = 'shashi1@test.com';
        string security_token = 'DWCUQVHKIepWamBY6Xs7UAK0B';
        
        try
        {
            //-----------------------------------
            // Login via SOAP/XML web service api
            //-----------------------------------
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://login.salesforce.com/services/Soap/u/50.0');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            request.setHeader('SOAPAction', '""');
            //not escaping username and password because we're setting those variables above
            //in other words, this line "trusts" the lines above
            //if username and password were sourced elsewhere, they'd need to be escaped below
            request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + 
                            userName+ '</username><password>' + pwd + security_token + '</password></login></Body></Envelope>');
            
            httpresponse bodyresp2 = (new Http()).send(request);
                
            Dom.XmlNode resultElmt = bodyresp2.getBodyDocument().getRootElement()
                .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
                .getChildElement('result', 'urn:partner.soap.sforce.com');
                  
            string Loginresp= bodyresp2.getBody(); // read login body
            system.debug('Loginresp : '+Loginresp);
            
            // CHECK FOR INVALID LOGIN 
            if(Loginresp.containsignorecase('<soapenv:Fault><faultcode>'))
            {
                Dom.XmlNode resultElmt1 = bodyresp2 .getBodyDocument().getRootElement()
                    .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/');
                String faultcode = resultElmt1.getChildElement('faultcode',null).getText();
                String faultstring = resultElmt1.getChildElement('faultstring',null).getText();
                System.debug('faultstring : '+faultstring);
                
            }
            
            // CHECK FOR EXPIRED PASSWORD
            if (Loginresp.containsignorecase('<passwordExpired>true<')) 
            {
                System.debug('Password Expired..');
            }
            

            //-------------------------------
            // Grab session id and server url
            //--------------------------------

            // LOGIN IS UNSUCCESSFUL THEN SKIP ALL OTHER PROCESSES 
            if(!Loginresp.containsignorecase('<soapenv:Fault><faultcode>'))
            {
                Dom.XmlNode resultElmt3 = bodyresp2 .getBodyDocument().getRootElement()
                    .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('loginResponse', 'urn:partner.soap.sforce.com')
                    .getChildElement('result', 'urn:partner.soap.sforce.com');
                
                // FETCH SESSION ID AND SERVER URL FROM RESPONSE
                String SERVER_URL = resultElmt3.getChildElement('serverUrl', 'urn:partner.soap.sforce.com') .getText().split('/services')[0];
                String SESSION_ID = resultElmt3.getChildElement('sessionId', 'urn:partner.soap.sforce.com') .getText();

                system.debug('SERVER_URL  : '+SERVER_URL);
            }
            
        }
        catch(Exception e)
        {
            system.debug('Exception while loging using SOAP/XML API : '+e);
        }
    }
    
    public void loginUsingNamedCredentials()
    {
        //NAMES CREDENTIALS ANON WINDOW CODE 

        HttpRequest feedRequest = new HttpRequest();
        //feedRequest.setEndpoint('callout:Shashi1_test_com_Org/services/data/v48.0/sobjects');
        feedRequest.setEndpoint('callout:testCred1/services/data/v48.0/sobjects');
        feedRequest.setMethod('GET');
        Http http = new Http();
        HTTPResponse feedResponse = http.send(feedRequest);
        while (feedResponse.getStatusCode() == 302) 
        {
            feedRequest.setEndpoint(feedResponse.getHeader('Location'));
            feedResponse = new Http().send(feedRequest);
        }
        System.debug('feedResponse : '+feedResponse.getBody());
        
        /*
            IF ERROR COMES THEN USE BELOW CODE 
            Error : System.HttpResponse[Status=Moved Temporarily, StatusCode=302]
            
            while (feedResponse.getStatusCode() == 302) 
            { 
                feedRequest.setEndpoint(feedResponse.getHeader('Location')); 
                feedResponse = new Http().send(feedRequest); 
            }
        */
    }

    // FOR SINGLE SIGN ON 
    // REFER CONNECTED APP ON shashi1@test.com ORG 
    // AND 
    // Auth. provider on current shashi@test.com ORG
    // MAKE ENTRY IN My Domains
    // CALLBACK URL IS ALWAYS THE URL OF SOURCE ORG
    //Callback url already present in shashi1@test.com connected app : https://shashi1-dev-ed.my.salesforce.com/services/oauth2/callback//
    //Now replacing with auth. provider generated callback url 
    
    // ACCESS REMOTE ORG DATA USING REST WEBSERVICE 
    // WHERE DATA IS EXPOSED AS REST WEBSERVICE ON REMOTE ORG  === class name : FetchAccount on shashi1@test.com    // ALSO CaseManager class available as RestResource
    public void getRESTRESOURCEAccounts ()
    {            
        if(results.get('access_token') != null){
            
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer '+results.get('access_token'));
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setMethod('GET');
            req1.setEndpoint(instanceURL + '/services/apexrest/v1/getAccounts/');   //URL will be your Salesforce REST API end point where you will do POST, PUT, DELETE or GET
            //req1.setBody(jsonstr);    //Send JSON body

            HttpResponse res1 = h1.send(req1);
            system.debug('RESPONSE_BODY'+res1 .getbody());
            
            List<account> ListAccount = new List<account>();

            String trimmedResponse = res1.getBody().unescapeCsv().remove('\\');
            system.debug('@@@RESPONSE@@'+trimmedResponse);
            JSONParser parser = JSON.createParser(res1.getBody());
            set<account> accList=new set<account>();
            
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) ) {
                    Account acc;
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Id')) {
                        parser.nextToken();
                        String sId= parser.getText();
                        acc=new Account();
                        acc.Id=sId;
                        system.debug('Id@@@' + sId);
                        parser.nextToken();
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'Name')) {
                            parser.nextToken();
                            string sName= parser.getText();
                            acc.Name=sName;
                            system.debug('Name@@@' + sName );
                        }
                    }
                    accList.add(acc); 
                }
                accList.remove(null);
            }
            ListAccount.AddAll(accList);
            //system.debug('AccountList@@@@'+Json.serialize(ListAccount));
            for(Account acc : ListAccount)
            {
                system.debug(acc);
            }
        }
    }
    
    
    // ACCESS REMOTE ORG DATA USING REST WEBSERVICE 
    // WHERE DATA IS EXPOSED AS SOAP WEBSERVICE ON REMOTE ORG
    // IS YOU WANT TO ACCESS ORG USING SOAP THEN ENTERPRISE WSDL FILE IS REQUIRED
    
    // PARTNER WSDL CAN BE USED ACCROSS MULTIPLE ORGS 
    // 
}


//  Connected App enables Salesforce to recognize and authenticate an external application as a new entry point. 
//  OAuth is used for this authentication. We need to create a Connected App record in Instance T so it can inform 
//  Salesforce about the new authentication entry point (Instance S). 

//SELECT count() FROM OpportunityShare


/*

BASIC AUTHORIZATION

Try the below code snippet as reference:

HTTP h = new HTTP();
HTTPRequest r = new HTTPRequest();
r.setEndpoint('https://my.domain.com');
Blob headerValue = Blob.valueOf(username + ':' + password);
String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
r.setHeader('Authorization', authorizationHeader);
r.setMethod('GET');
HTTPResponse resp = h.send(r);



*/


// https://github.com/jejhgithub/saml-bearer-assertion-apex-example
// https://developer.salesforce.com/blogs/isv/2015/04/integrating-multi-orgs-using-oauth.html
// 
// https://www.jitendrazaa.com/blog/salesforce/login-to-salesforce-from-salesforce-using-authentication-provider/#more-4516
// 
// https://www.jitendrazaa.com/blog/salesforce/salesforce-to-salesforce-integration-using-named-credentials-in-just-5-lines-of-code/
/*
NAMES CREDENTIALS ANON WINDOW CODE 


HttpRequest feedRequest = new HttpRequest();
feedRequest.setEndpoint('callout:Shashi1_test_com_Org/services/data/v48.0');
feedRequest.setMethod('GET');
Http http = new Http();
HTTPResponse feedResponse = http.send(feedRequest);
while (feedResponse.getStatusCode() == 302) 
{
    feedRequest.setEndpoint(feedResponse.getHeader('Location'));
    feedResponse = new Http().send(feedRequest);
}
System.debug('feedResponse : '+feedResponse.getBody());

///*
IF ERROR COMES THEN USE BELOW CODE 
    Error : System.HttpResponse[Status=Moved Temporarily, StatusCode=302]


while (feedResponse.getStatusCode() == 302) 
{ 
    feedRequest.setEndpoint(feedResponse.getHeader('Location')); 
    feedResponse = new Http().send(feedRequest); 
}
//*




    The minimum size for Batch Apex is 1.
    The maximum size for Batch Apex is 2000.
    The default is 200.


    Total number of records retrieved by Database.getQueryLocator   10,000
    Total number of records retrieved by SOQL queries   			50,000
    Total number of SOQL queries issued                 			100         200
    
    
$A.enqueueAction(action) adds the server-side controller action to the queue of actions to be executed. All actions that are enqueued will run at the end of the event loop. 
Rather than sending a separate request for each individual action, the framework processes the event chain and batches the actions in the queue into one request. 
The actions are asynchronous and have callbacks.





        $(document).ready(function()
        {           
            checkAllFunction();
            checkAllGrpsFunction();
            checkAllPermsFunction();
            checkAllQueuesFunction();
        });
        
        function checkAllFunction(){
            $(".checkAllAttribs").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".checkbox").prop('checked', isChecked);
            });
            
            $(".checkbox").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".checkAllAttribs").prop('checked', isChecked);
            });
        }
            
        function checkAllGrpsFunction () 
        {
            $(".checkAllGroups").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".grpCheckbox").prop('checked', isChecked);
            });
            
            $(".grpCheckbox").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".checkAllGroups").prop('checked', isChecked);
            });
        }
        
        function checkAllPermsFunction () 
        {
            $(".checkAllpermSets").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".permCheckbox").prop('checked', isChecked);
            });
            $(".permCheckbox").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".checkAllpermSets").prop('checked', isChecked);
            });
        }
    
        function checkAllQueuesFunction () 
        {
            $(".checkAllqueues").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".queueCheckbox").prop('checked', isChecked);
            });
            $(".queueCheckbox").on("click", function(e){
                var isChecked = $(this).is(':checked');
                $(".checkAllqueues").prop('checked', isChecked);
            });
        }
    
        function openLookup(baseURL, width, modified, searchParam)
        {
            var originalbaseURL = baseURL;
            var originalwidth = width;
            var originalmodified = modified;
            var originalsearchParam = searchParam;
            
            console.log('originalsearchParam : '+originalsearchParam);
            var srchArr = originalsearchParam.split('=');
            var searchString = '';
            if (srchArr.length > 0){
                searchString = srchArr[1];
            }
            
            var user1 = '';
            var user2 = '';
            
            if (searchString == '')
            {
                console.log('searchString : '+searchString);
                user1 = document.getElementById('Page:myForm:PageBlock:PBSectId:uId1').value;
                user2 = document.getElementById('Page:myForm:PageBlock:PBSectId:uId2').value;
            }
            
            var lookupType = baseURL.substr(baseURL.indexOf('lktp')+5, 18);
            if (modified == '1') baseURL = baseURL + searchParam;
            
            var isCustomLookup = false;
            
            // Following "StandardUserLookup" is the lookup type for User object
            if(lookupType == "StandardUserLookup")
            {
                var urlArr = baseURL.split("&");
                var txtId = '';
                if(urlArr.length > 2) {
                    console.log('in if..baseURL : ' +urlArr[1]);
                    urlArr = urlArr[1].split('=');
                    txtId = urlArr[1];
                }
                
                // FOLLOWING IS THE URL OF CUSTOM LOOKUP PAGE 
                baseURL = "/apex/AH_CustomUserLookup?txt=" + txtId + "&user1="+user1+"&user2="+user2;
                
                // Following is the id of apex:form control "myForm".
                baseURL = baseURL + "&frm=" + escapeUTF("{!$Component.myForm}");
                if (modified == '1') {
                    baseURL = baseURL + "&lksearch=" + searchParam;
                }
                
                // Following is the ID of inputField that is the lookup to be customized as custom lookup
                if(txtId.indexOf('uId1') > -1 ){
                    isCustomLookup = true;
                }
                if(txtId.indexOf('uId2') > -1 ){
                    isCustomLookup = true;
                }
            }
            
            console.log('baseURL : ' +baseURL);
            
            if(isCustomLookup == true){
                
                openPopup(baseURL, "lookup", 350, 480, "width="+width+",height=480,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", false);
            }
            else {
                if (modified == '1') originalbaseURL = originalbaseURL + originalsearchParam;
                openPopup(originalbaseURL, "lookup", 350, 480, "width="+originalwidth+",height=480,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", false);
            } 
        }
        
        //Loading modal functions
        function showLoadingModal(){
            $("#spinner").css({"display":"inline"});
        }
        
        function hideLoadingModal(){
            $("#spinner").css({"display":"none"});
        }
    
        
        function colorPageBlock(pageblock, color) {
            if (pageblock != null) 
            {
                pageblock.firstChild.style.cssText = "background-color: lightblue; font-size:13px; ";
                //color:#FFFFF0;
            }
        }
    

Integer classLines = 0;
Integer triggerLines = 0;

for(ApexClass a : [Select Body From ApexClass]){
    List<String> lines = a.Body.split('\n');
    classLines += lines.size();
}

for(ApexTrigger a : [Select Body From ApexTrigger]){
    List<String> lines = a.Body.split('\n');
    triggerLines += lines.size();
}

system.debug('Apex Class lines: ' + classLines);
system.debug('Apex Trigger lines: ' + triggerLines);
system.debug('Apex Total lines: ' + (classLines+ triggerLines));



Aggregate query don't work in Batch class 
    - 2 options:
        1. add code in schedulable class & pass map to batchable class
        2. Iterable class


What @ReadOnly annotation ?
When we run a query from schedulable class, need to add @ReadOnly annotation on execute method of schedulable class

What are the 4 options on deployment page ??

throw new DmlException();



Taken for granted? 

Posted: 02 Jul 2013 09:28 PM PDT

It’s your responsibility to let people know that you are not a relationship that can be taken for granted.
 Taken for granted<http://www.infinitheism.com/blog/wp-content/uploads/Taken-for-granted.jpg> 

Many of us have a strange tendency in relationships.  We tend to feel something about someone – some 
hurt, some pain, some resentment, and yet we wait and wait for things to go really out of hand before 
we do something about it.  One of the most common feelings a lot of us go through every now and then 
is the feeling of being taken for granted.

While others taking you for granted is not in your hands, you letting people know that you are feeling 
taken for granted is.  Since quite some time, I had been feeling that someone very close to me has been 
very preoccupied and while he is there when I call, or want, there had been no initiative from his side at 
all.  While there was no doubt as to how this person felt for me, it still didn’t feel good to know that for 
weeks at end we wouldn’t be in touch.

While I kept feeling slightly uncomfortable and hurt – I somehow convinced myself that he was busy – 
so much was happening in his life – I should just be a silent strength for him.  However, as my guru so 
beautifully puts it, “In the realm of emotions – we are all children.”  No matter how much you rationalise 
with the mind – the heart feels what the heart feels.  Somewhere the distance between us kept growing 
– without him even knowing it.

One of those days the feelings just reached their threshold and in a fit of anger all those suppressed 
emotions of months came gushing forth.  He was surprised at the intensity of my reaction, and I was 
dismayed at the way it happened.  Fortunately, we are close enough and the fabric of our relationship 
could contain everything without the slightest tear.  He kept saying, “Sorry I took you for granted – I 
didn’t even realise…”  I reached back home, drained, but definitely wiser.

I realised that there is little point in trying to convince yourself you are not feeling something when you 
are.  If the relationship matters – and if you matter in the relationship – you need to let people know, as 
something doesn’t seem right.  You may take a few days to communicate – but not longer because it’s 
such an unnecessary burden you carry.  And when it finally does get expressed the magnitude is so 
much greater… and the harm it can do is more.  Rather than sawing and sawing at the tree – just dig out 
the seeds… it takes lesser time, energy and efforts – and is easier on the soil of the relationship.

I realised expressing is equally important at the workplace with the employer.  Most employees, who 
leave, leave because somewhere they begin to feel taken for granted.  They search for a company that 
will value them.  The boss is shocked when he receives the resignation letter not knowing what went 
wrong in the first place – if only the two had communicated when they needed to, the years of sharing a 
vision and training wouldn’t go wasted.

No one likes to be taken for granted.  However, one needs to recognise that the other may not even 
realise they are feeling this way.  Communication is a must.  Communication is needed.  It’s your 
responsibility to let people know that you are not a relationship that can be taken for granted.  You need 
to teach people to not take you for granted – and trust me – you probably matter much more to the 
other than you realise and things may become much better than you ever believed, once you express.  
It’s worth trying.

-Megha Bajaj

http://www.infinitheism.com/blog

*/
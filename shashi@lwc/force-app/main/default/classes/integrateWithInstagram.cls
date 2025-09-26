public class integrateWithInstagram 
{

    String instanceURL = 'https://shashi1-dev-ed.my.salesforce.com';
    String clientId = '3MVG9d8..z.hDcPKhkfjsFBy.cePWRiUeTN9tWPoDya0waykohRTyP.2q9CQy37cypQS0SiB6FSnk29OT3HvW';
    String clientSecret = 'C5CA1C02375F87BB65062566E481296B7CEF3409E3BDFD639ED37DC9FE6C2A82';
    String username= 'shashi1@test.com';
    String password= 'sept@123' + 'DWCUQVHKIepWamBY6Xs7UAK0B';
    
    // api.instagram.com — for getting Instagram User Access Tokens
	// graph.instagram.com — for getting Instagram user profiles and media

    public static void login(){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.instagram.com');
        
 /* https://api.instagram.com/oauth/authorize
  ?client_id={app-id}
  &redirect_uri={redirect-uri}
  &scope=user_profile,user_media
  &response_type=code
*/
      
        Blob headerValue = Blob.valueOf('snikam0587' + ':' + 'Perfection_05');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('GET');
        HttpResponse response = http.send(req);
       
        System.debug('Response : '+ response.getBody());
    }
}
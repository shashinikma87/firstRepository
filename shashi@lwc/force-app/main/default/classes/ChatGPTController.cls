public with sharing class ChatGPTController {
    
    //private static ChatGPTKey__c customSetting = ChatGPTKey__c.getOrgDefaults(); //Custom Setting
    private static final String ENDPOINT ='https://api.openai.com/v1/completions';
    
    @AuraEnabled
    public static String getSearchData(String searchString){
        try{
            String seachQueryEscaped = (searchString).trim();
            Http http = new Http();
            String reqBody = '{"model": "text-davinci-003","prompt":"'
                +seachQueryEscaped+
                '","max_tokens": 4000,"temperature": 0,'
                +'"stream": false,"top_p": 0.5}';

            HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'Bearer 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');
            request.setHeader('Content-Type', 'application/json');
            request.setEndpoint(ENDPOINT);
            request.setMethod('POST');
            request.setBody(reqBody);
            HttpResponse response = http.send(request);
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' +
                             response.getBody());
                return response.getBody();
            }
            System.debug('Response : '+ response.getBody());
            
            return response.getBody();
        }
        catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
/**
 * ClassName :  FileUploader
 * Description : This class used to insert the data into Custom Object
**/
public with sharing class FileUploader {

    List<Financial_Information__c> forInsert = new List<Financial_Information__c>();
    public Integer size {get;set;}
    public String myString {get;set;}
    public Boolean status {get;set;}
    public String message {get;set;}

    public FileUploader(){
        myString= '';
        size = 0;
        status= false;
    }
    public PageReference parseData(){
        myString = Apexpages.currentPage().getParameters().get('data');
        
        List<String> arr = new List<String>();
        arr = myString.split('\\n');
        Integer i;
        //for (i=0 ; i< arr.length; i++) {
            
            //Sysytem.debug(arr[i].Unique_ID__c);
        //}
        //System.debug('myString Data ==> ' + myString);
        
        System.debug('Array => ' + arr);
        List<String> ids = parseJSONString();
        if(forInsert.size()>0){
            try{
                size = forInsert.size();
                status = true;
                upsert forInsert Unique_ID__c ;
            } 
            catch(Exception e) {
                status = false;
                message = e.getMessage();
            }
        }
        
            // send mail of ids who have errors 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { 'shashikantn@cybage.com' };
            message.subject = 'Failed Records of Excel Import POC';
            //message.plainTextBody = 'Please find below the list of Unique IDs failed to insert' + ids;
            message.setHtmlBody('Hi,<br/><p>'+'Please find the attachment or below list of Unique IDs failed at insert.<p>' + ids);
        
            //String str = ids[0];
            String str = String.join( ids, ' ' );
            String strUrlUTF8 = EncodingUtil.urlEncode(str, 'UTF-8');
            String s2 = strUrlUTF8.replaceAll('\\+', '\n');

            Blob b = Blob.valueOf(s2);
        
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setContentType('text/plain');
            efa.setFileName('Report.txt');
            efa.setBody(b);
            message.setFileAttachments(new Messaging.EmailFileattachment[]{efa});

            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        //    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        //  if (results[0].success) {
          //      System.debug('The email was sent successfully.');
            //} else {
           //     System.debug('The email failed to send: ' + results[0].errors[0].message);
            //}
        
        return Null;
    }
    
    public List<String> parseJSONString() {
        String jsonStr = myString;
        forInsert = new List<Financial_Information__c>();
        JSONParser parser = JSON.createParser(jsonStr);
        
        List<String> error_ids = new List<String>();
        
        Map<String,Id> CodeMap=new map<String,Id>();        
        List<Account> codelist=[select id,Comp_Info_ID__c from account];
        for(Account acmap:codelist){
        	CodeMap.put(acmap.Comp_Info_ID__c,acmap.id); 
        } 
        
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {                // This token is returned when '[' is encountered.
                while (parser.nextToken() != null) {                                // Check if tokens are present
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {       // This token is returned when '{' is encountered.
                        
                        Financial_Information__c cus = (Financial_Information__c)parser.readValueAs(Financial_Information__c.class);
                        //System.debug('Customer :  '+ cus);
						cus.Account__c = CodeMap.get(cus.Company_Code__c);
                        forInsert.add(cus);
                        String s = JSON.serialize(cus);
                        parser.skipChildren();
                    }
                }
            }
        }  // end of while loop
        return error_ids;
    }
}
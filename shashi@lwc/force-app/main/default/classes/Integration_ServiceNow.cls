public class Integration_ServiceNow {

    public string user_name {get; set;}
    public List<ServiceNow__c> tasks_list {get; set;}
    public List<selectOption> getusernames (){
        List<SelectOption> usernames = new List<SelectOption>();
        usernames.add(new SelectOption('','-- None --'));
        usernames.add(new SelectOption('Shashikant.Nikam','Shashikant Nikam'));
        usernames.add(new SelectOption('Tabrez.Ansari','Tabrez Ansari'));

        return usernames;
    }

    public void getIncidentsList () {
        
        /*if (user_name == null){
            return null;
        }*/
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Blob headerValue = Blob.valueOf('Shashikant.Nikam' + ':' + '$ruzAj2n');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);
        if (user_name == null || user_name == ''){
            return ;
        }
        //req.setEndpoint('https://invitationhomes.service-now.com/api/now/table/incident?sysparm_query&assigned_to=' + user_name);
        //req.setEndpoint('https://invitationhomes.service-now.com/api/now/table/task?sysparm_query&assigned_to='+ user_name +'&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=closed_at,location,category,subcategory,caller_id,assignment_group,number,sys_created_on,short_description,description,sys_id,state,assigned_to,closed_by&sysparm_limit=5000');
        
        //req.setEndpoint('https://invitationhomes.service-now.com/api/now/table/task?sysparm_query&assigned_to=Shashikant.Nikam&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=closed_at,location,category,subcategory,caller_id,assignment_group,number,sys_created_on,short_description,description,sys_id,state,assigned_to,closed_by&sysparm_limit=5000');
        //req.setEndpoint('https://invitationhomes.service-now.com/api/now/table/task?sysparm_query&assigned_to=Tabrez.Ansari&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=closed_at,location,category,subcategory,caller_id,assignment_group,number,sys_created_on,short_description,description,sys_id,state,assigned_to,closed_by&sysparm_limit=5000');       
        
        req.setEndpoint('https://invitationhomes.service-now.com/api/now/table/task?sysparm_query&assigned_to='+ user_name +'&sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=closed_at,location,category,subcategory,caller_id,assignment_group,number,sys_created_on,short_description,description,sys_id,state,assigned_to,closed_by&sysparm_limit=5000');
        
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('GET');
        HttpResponse response = http.send(req);

        if (response.getStatusCode() == 200) {
            
            List<ServiceNow__c> list_service_now = new List<ServiceNow__c>();
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> result_list = (List<Object>) results.get('result');
            //tasks_list.clear();
            
            //System.debug(response.getBody());
            for (Object incident: result_list){
                
                Map<String,Object> i = (Map<String, Object>) incident;

                ServiceNow__c s_now = new ServiceNow__c();
                
                s_now.Name = String.valueOf(i.get('number'));
                s_now.State__c = String.valueOf(i.get('state'));
                s_now.Aassigned_to__c = String.valueOf(i.get('assigned_to'));
                s_now.Created_On__c = parsemyString(String.valueOf(i.get('sys_created_on')));
                s_now.Closed_at__c = parsemyString(String.valueOf(i.get('closed_at')));
                s_now.Closed_by__c = String.valueOf(i.get('closed_by'));
                s_now.Description__c = String.valueOf(i.get('description'));
                s_now.Short_Description__c = String.valueOf(i.get('short_description'));

                list_service_now.add(s_now);
            }
            
            // insert records in ServiceNow__c
            //insert list_service_now;
            tasks_list = list_service_now;
        }
    }
    
    public void sendMail (){
        
        // send mail of ids who have errors 
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'shashikantn@cybage.com', 'tabreza@cybage.com'}; //
        message.subject = 'Report';
        
        message.setHtmlBody('Hi User,<br/><p>'+'Please find the attached report of Tasks & Incidents.<br/><br/>This is a system generated mail. Please do no reply.<p><br/> - Salesforce Team' );

        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error'));

        Blob b; 
        if (tasks_list != null ) {
            
            String str;
            str = 'Ticket No.' + '\t' +'Assigned To' + '\t' +'Status' + '\t' +'Created Date'+'\n';
            for (ServiceNow__c s : tasks_list) {

                str = str + s.Name + '\t' + s.Aassigned_to__c  + '\t' +  s.State__c  + '\t' +  s.Created_On__c +'\n';
            }
            System.debug('str : '+ str);
            String strUrlUTF8 = EncodingUtil.urlEncode(str, 'UTF-8');
            //String s2 = strUrlUTF8.replaceAll('\\+', '\n');

            b = Blob.valueOf(str);
                
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            //efa.setContentType('text/plain');
            //efa.setFileName('Report.txt');
            efa.setContentType('application/vnd.ms-excel');
            efa.setFileName('Ticket Report.xls');
            efa.setBody(b);
            message.setFileAttachments(new Messaging.EmailFileattachment[]{efa});
            
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) {
                System.debug('The email sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }
        } 
        else {
          return;
        }
    }
    
    public Static Date parsemyString(String datetimestring){
        
        datetimestring = datetimestring.substringBeforeLast(':') +' ' + datetimestring.right(2);  
        String dt ='2000-01-01 00:00:00';
        try {
            Pattern MyPattern = Pattern.compile('(\\d+)\\/(\\d+)\\/(\\d+)\\s+(.*?)\\s+.*$');
            Matcher myMatcher = myPattern.matcher(datetimestring);
            if (myMatcher.matches()) {
                dt = myMatcher.group(3) +'-'+ myMatcher.group(1) +'-'+ myMatcher.group(2) +'-'+ myMatcher.group(4);
            } 
        } catch(Exception e) {
            return null;
        }
        return (Date.valueOf(dt));
    }
}
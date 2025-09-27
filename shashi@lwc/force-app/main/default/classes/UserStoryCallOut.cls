/**
* -------------------------------------------------------------------------------------------------+
* Rally REST API Call 
* --------------------------------------------------------------------------------------------------
* @author         Shashikant Nikam
* @version        1.0
* @created        07-Jun-2017
* @modified       16-Jun-2017
* @systemLayer    Domain
* --------------------------------------------------------------------------------------------------
* @changes
* v1              
* -------------------------------------------------------------------------------------------------+
*/
public with sharing class UserStoryCallOut {

    //public List<Rally__c> rally_list = new List<Rally__c>();
    public List<Rally__c> rally_list {get; set;}
    public String iteration_name {get; set;}
    //private final Rally__c rally;
    
    public UserStoryCallOut(ApexPages.StandardController stdController) { 
        rally_list = new List<Rally__c>();
        //this.rally = (Rally__c)stdController.getRecord();
    }
    
    public PageReference getUserStory() {

        //u_story_id = '122790960980';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //req.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/' + u_story_id);
        String iteration_name1 = iteration_name;
        iteration_name = iteration_name.replace(' ', '%20');
        iteration_name = iteration_name.replace(':', '%3A');
        
        //req.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?fetch=FormattedId,Description,Name,Blocked,PlanEstimate,TaskRemainingTotal,ScheduleState&query=(Iteration.Name%20%3D%20%22Iteration%201%20-%20Browse%20and%20Book%22)&start=1&pagesize=20');
        //req.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?fetch=FormattedId,owner,Description,Name,Blocked,PlanEstimate,TaskRemainingTotal,ScheduleState&query=((Iteration.Name%20%3D%20%22'+ iteration_name +'%22)AND(Project.Name%3D%22SFDC%22))&start=1&pagesize=20');
        //req.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?fetch=FormattedId,owner,Description,Name,Blocked,PlanEstimate,TaskEstimateTotal,TaskActualTotal,TaskRemainingTotal,ScheduleState&query=((Iteration.Name%20%3D%20%22' +iteration_name+'%22)%20AND%20(%20Project.Name%20%3D%20%22SFDC%22))&start=1&pagesize=200');
        req.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?fetch=Iteration,FormattedId,owner,Description,Name,Blocked,PlanEstimate,TaskEstimateTotal,TaskActualTotal,TaskRemainingTotal,ScheduleState&query=(Iteration.Name%20%3D%20%22' +iteration_name+'%22)&start=1&pagesize=200');
        
        //Blob headerValue = Blob.valueOf('shashikantn@cybage.com' + ':' + 'rally@123');
        Blob headerValue = Blob.valueOf('nitishsharma@travelclick.com' + ':' + 'nishu*292');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setMethod('GET');
        HttpResponse response = http.send(req);
       
        //System.debug('Response : '+ response.getBody());
        
        List<Rally__c> rally_list1 = new List<Rally__c>();
        
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            
            //System.debug(JSON2ApexMain.parse(response.getBody()));
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> QueryResult = (Map<String, Object>) results.get('QueryResult');
            List<Object> story_list = (List<Object>) QueryResult.get('Results');

            // Empty Map objects 
            results.clear();
            QueryResult.clear();
     
            //{"attributes":{"type":"Account","url":"/services/data/v51.0/sobjects/Account/0012w0000043J4aAAE"},"Id":"0012w0000043J4aAAE"}
            
            
            List<String> formatted_id_list = new List<String>();
          
            for (Object story: story_list ){

                //System.debug('Story : ' + story);
                String story_owner;
                Map<String, Object> i = (Map<String, Object>) story;  
                try {
                    Map<String, Object> Owner = (Map<String, Object>) i.get('Owner');
                    story_owner = String.valueOf(Owner.get('_refObjectName'));
                    //System.debug('Owner : ' + story_owner);
                } catch (Exception e) { }
                
                Map<String, Object> Iteration = (Map<String, Object>) i.get('Iteration');
                String story_iteration = String.valueOf(Iteration.get('_refObjectName'));
                //System.debug('Owner : ' + story_iteration);
                
                String FormattedID =  String.valueOf(i.get('FormattedID'));
                Integer PlanEstimate;
                PlanEstimate = Integer.valueOf(i.get('PlanEstimate'));
                if (PlanEstimate == null) { 
                    PlanEstimate = 0;
                }
                String Name =  String.valueOf(i.get('Name'));
                Boolean Blocked =  Boolean.valueOf(i.get('Blocked'));
                String ScheduleState =  String.valueOf(i.get('ScheduleState'));
                Integer TaskRemainingTotal =  Integer.valueOf(i.get('TaskRemainingTotal'));
                String Description =  String.valueOf(i.get('Description'));
                Integer TaskEstimateTotal =  Integer.valueOf(i.get('TaskEstimateTotal'));
                Integer TaskActualTotal =  Integer.valueOf(i.get('TaskActualTotal'));
                                
                Rally__c rally = new Rally__c();
                rally.FormattedID__c = FormattedID;
                rally.User_Story_Name__c = Name;
                rally.Story_Description__c = Description;
                rally.Planned_Estimate__c = PlanEstimate;
                rally.Schedule_State__c = ScheduleState;
                rally.Blocked__c = Blocked;
                rally.Story_Owner__c = story_owner;
                rally.Task_Remaining_Total__c = TaskRemainingTotal;
                rally.Task_Estimate_Total__c = TaskEstimateTotal;
                rally.Task_Actual_Total__c = TaskActualTotal;
                rally.Iteration__c = story_iteration;

                formatted_id_list.add(FormattedID);
                rally_list1.add(rally);
            }
            //System.debug('Rally List : ' + rally_list1);
            
            // Call API to get all the tasks in above specified Iteration Tasks
            Http http1 = new Http();
            HttpRequest task_req = new HttpRequest();
            task_req.setHeader('Authorization', authorizationHeader);
            task_req.setMethod('GET');
            task_req.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/task?fetch=WorkProduct,FormattedId,Task&query=(Iteration.Name%20%3D%20%22' + iteration_name + '%22)&start=1&pagesize=200');
            System.debug('Task Request : https://rally1.rallydev.com/slm/webservice/v2.0/task?fetch=WorkProduct,FormattedID,Task&query=(Iteration.Name%20%3D%20%22' + iteration_name + '%22)&start=1&pagesize=200');
            HttpResponse task_response = http1.send(task_req);
            System.debug('Task Response : ' + task_response.getBody());
            
            iteration_name = iteration_name1;
            
            Map<String, Object> task_results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> task_QueryResult = (Map<String, Object>) task_results.get('QueryResult');
            List<Object> task_list = (List<Object>) task_QueryResult.get('Results');

            Map<String, Object> tasks = new Map<String, Object>();
            for (Object task: task_list) {
                Map<String, Object> t = (Map<String, Object>) task; 
                String task_name = String.valueOf(t.get('_refObjectName'));
                String task_id = String.valueOf(t.get('FormattedID'));
                
                String u_id = String.valueOf(t.get('FormattedID'));
                
                Map<String, Object> task_details = new Map<String, Object>();
                task_details.put('Task_FormattedID', task_id);
                task_details.put('Task_Name', task_name);

                tasks.put(u_id,task_details);
            }

            System.debug('Map of  task object : ' + tasks);
            
            // Delete all existing records
            //List<Rally__c> delete_list = [select Id from Rally__c where FormattedID__c in : formatted_id_list ];
            List<Rally__c> delete_list = [ select Id from Rally__c ];
            delete delete_list;
            
            // Insert records in Rally Object of SF
            insert rally_list1; 
            
        }
        for (Rally__c r : rally_list1){
            r.recalculateFormulas();
        }
        rally_list = rally_list1.clone();
        
        // Clear the list to enable search on VF page multiple times
        rally_list1.clear();
        return null;
    }
    
    public static void createStory ()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Blob headerValue = Blob.valueOf('shashikantn@cybage.com' + ':' + 'Rally@123');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);      
        request.setHeader('Authorization', authorizationHeader);
        String apiKey = '_84arjdETS9erMHwoAhg2AvToImyjg0mNrXOMCLiaweA';
        request.setHeader('ZSESSIONID', apiKey);
		
        //String reqString = 'https://rally1.rallydev.com/slm/webservice/v2.0/task?query=((Owner.Name%20=%20shashikantn@cybage.com)%20and%20(State%20!=%20Completed))&order=Rank&fetch=true';//&stylesheet=/slm/doc/webservice/browser';
        request.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/create?');
        request.setBody('{"HierarchicalRequirement":{"Description":"Updated from SF Code.", "Name":"XXXXXXXXXX"}}');
        
        //request.setEndpoint(reqString);
        HttpResponse response = new HttpResponse();
		response = http.send(request);
        
        system.debug('in else response Status : ' + response.getStatusCode() + ' ' + response.getStatus());
        System.debug('response : '+response.getBody());
        
        
        //u_story_id = '122790960980';
        Http http1 = new Http();
        HttpRequest request1 = new HttpRequest();
		request1.setMethod('GET');
        request1.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Blob headerValue1 = Blob.valueOf('shashikantn@cybage.com' + ':' + 'Rally@123');
        String authorizationHeader1 = 'Basic  ' + EncodingUtil.base64Encode(headerValue1);      
        request1.setHeader('Authorization', authorizationHeader1);
        String apiKey1 = '_84arjdETS9erMHwoAhg2AvToImyjg0mNrXOMCLiaweA';
        request1.setHeader('ZSESSIONID', apiKey1);

            
		String iteration_name1 = 'XXXXXXXXXX';
        iteration_name1 = iteration_name1.replace(' ', '%20');
        iteration_name1 = iteration_name1.replace(':', '%3A');
        request1.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?fetch=Iteration,FormattedId,owner,Description,Name,Blocked,PlanEstimate,TaskEstimateTotal,TaskActualTotal,TaskRemainingTotal,ScheduleState&query=(Name%20%3D%20%22XXXXXXXXXX%22)&start=1&pagesize=200');
        
            HttpResponse response1 = new HttpResponse();
            response1 = http.send(request1);
System.debug('response : '+response1.getBody());
        
        
    }
    
    public void sendMail (){
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { UserInfo.getUserEmail() }; 
        message.toAddresses = new String[] { 'nitishsh@cybage.com','abhayl@cybage.com','anandkulk@cybage.com' }; 
        message.subject = 'Rally Iteration - '+ rally_list[0].Iteration__c;
       
        String htmlBody = '';
        
        //open table..
        htmlBody = '<table border="1" style="border-collapse: collapse"><caption>User Story Details</caption><tr><th>Formatted ID</th><th>User Story Name</th><th>Schedule State</th><th>Story Owner</th><th>Completion %</th></tr>';

        //iterate over list and output columns/data into table rows...
        for(Rally__c rally : rally_list){
            htmlBody += '<tr><td>   ' + rally.FormattedID__c + '</td><td>' + rally.User_Story_Name__c + '</td><td>'+ rally.Schedule_State__c +'</td><td>' + rally.Story_Owner__c + '</td><td>' + rally.Task_Completion__c +'</td></tr>';
        }

        //close table...
        htmlBody += '</table>';

        System.debug('htmlBody : ' + htmlBody);
        message.setHtmlBody('Hi '+ UserInfo.getFirstName()+ ',<br/><p>'+'Please find the details about requested Iteration - '+ rally_list[0].Iteration__c +'.<br/>' + htmlBody +'<br/>This is a system generated mail. Please do no reply.<p><br/>- Salesforce Team' );
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }

    public static HttpResponse updateUserStory (String u_story_id) {
        
        // Update Description in User Story       
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        //request.setHeader('Content-Type','text/javascript;charset=utf-8');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Blob headerValue = Blob.valueOf('shashikantn@cybage.com' + ':' + 'rally@123');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);      
        request.setHeader('Authorization', authorizationHeader);
        String apiKey = '_84arjdETS9erMHwoAhg2AvToImyjg0mNrXOMCLiaweA';
        request.setHeader('ZSESSIONID', apiKey);
        request.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/' + u_story_id);
        request.setBody('{"HierarchicalRequirement":{"Description":"Updated from SF Code."}}');
        /*HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200){
            System.debug('Successfully updated..');
            system.debug('in if response Status : ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('response : '+response.getBody());
        } else {
            system.debug('in else response Status : ' + response.getStatusCode() + ' ' + response.getStatus());
            System.debug('response : '+response.getBody());
        }*/
        HttpResponse response = new HttpResponse();
        return response; 
    }

    
        
    public static HttpResponse getDefect (String defect_id) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/defect/' + defect_id);
        Blob headerValue = Blob.valueOf('shashikantn@cybage.com' + ':' + 'rally@123');
        String authorizationHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setMethod('GET');
        HttpResponse response = Http.send(request);
        if (response.getStatusCode() == 200){
            //defect = (Map<String, Object>) results.get('Defect');
        }
        return response;
    }
}
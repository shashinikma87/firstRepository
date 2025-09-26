public class AH_JobScheduler_Ctlr 
{
    public Map<String, Map<String, String>> schldClassDetails {get; set;}
    public Boolean isCheckAllJobs  {get; set;}
    public String jobName {get; set;}
    public String selectedClass {get;set;}
    public List<SelectOption> classOptions {get;set;}
    public Set<String> classNamesSet;
    
    // VARIABLE TO DISPLAY DATA FROM COMPONENT.
    public ComponentData  theData{get;set;}
    
    public String sessionId;
    public String serverUrl;
    private String orgId;     
    private String origLocale;    
    private String userId;   
    
    private String endPointUrl;
    
    public String status {get; set;}
    
    public AH_CronBuilder_ctlr_Sean vfc;
    
    public static String cronExpr {get; set;}
    
    public Boolean renderClassList {get; set;}
    
    public List<jobData> schldJobsData {get; set;}
    
    public class jobData {
        
        public Boolean check {get; set;}
        public String jobId {get; set;}
        public String ClassName {get; set;}
        public String JobType {get; set;}
        public String status {get; set;}
        public String CreatedBy {get; set;}
    }
    
    
    // CONSTRUCTOR METHOD
    public AH_JobScheduler_Ctlr()
    {
        isCheckAllJobs = false;
        schldClassDetails = new Map<String, Map<String, String>>();
        schldJobsData = new List<jobData>();
        renderClassList = false;
        theData = new ComponentData();
        
        system.debug('in VF page constructor...'+theData);
        
        ////////////OUTPUT TEXT RETRIEVE FROM COMPONENT DATA////////////
        //AH_CronBuilder_ctlr_Sean test = new AH_CronBuilder_ctlr_Sean();
        //System.debug('theData==>'+test.strCronString);
        //system.debug('cronExpr : '+cronExpr);
        ////////////OUTPUT TEXT RETRIEVE FROM COMPONENT DATA////////////
        
        jobName = 'Hiiii';
        
        AH_Scheduled_Job_Setting__mdt jobMDT = retrieveCredentials();
        
        endPointUrl = jobMDT.Endpoint__c;
        
        // RETRIEVE DATA FROM CUSTOM SETTING - AH_Scheduled_Job_Credentials__c 
        AH_Scheduled_Job_Credentials__c credentials = new AH_Scheduled_Job_Credentials__c();
        credentials = AH_Scheduled_Job_Credentials__c.getValues(jobMDT.Running_User_Profile_Name__c);
        system.debug('credentials : '+credentials);
        
        if(credentials != NULL){
            
            setClassOptsList(String.valueOf(jobMDT.Schedulable_Classes__c));
            renderClassList = true;
            
            // LOGIN TO REMOTE SF ORG
            login(jobMDT.Context_Username__c, credentials.Context_User_Password__c, credentials.Context_User_Security_Token__c, jobMDT.Endpoint__c);
        }
    }
    
    public void deleteJobs()
    {
        
        system.debug('in delete jobs function...');
    }
    
    public AH_Scheduled_Job_Setting__mdt retrieveCredentials()
    {
        
        // GET RUNNING USER'S PROFILE ID
        String profileId = UserInfo.getProfileId(); 
        system.debug('profileId : '+profileId);
        
        // GET RUNNING USER'S PROFILE NAME OF USING RUNNING USER'S PROFILE ID
        Profile prf = [SELECT ID, NAME FROM Profile WHERE ID =: profileId];
        
        // RETRIEVE CUSTOM METADATA TYPE INFO FOR RUNNING USER PROFILE
        AH_Scheduled_Job_Setting__mdt jobMDT = [ SELECT ID, DeveloperName, 
                                                Label, 
                                                Endpoint__c, 
                                                Context_Username__c, 
                                                Schedulable_Classes__c, 
                                                Running_User_Profile_Name__c 
                                                FROM AH_Scheduled_Job_Setting__mdt 
                                                WHERE Label =: prf.Name];
        
        system.debug('jobMDT : '+jobMDT);
        
        return jobMDT;
    }
    
    
    public void login(String uName, String pwd, String securityToken, String endPoint) 
    {   
        
        // GET RUNNING USER'S PROFILE ID
        String profileId = UserInfo.getProfileId(); 
        system.debug('profileId : '+profileId);
        
        // GET RUNNING USER'S PROFILE NAME OF USING RUNNING USER'S PROFILE ID
        Profile prf = [SELECT ID, NAME FROM Profile WHERE ID =: profileId];
        
        // RETRIEVE CUSTOM METADATA TYPE INFO FOR RUNNING USER PROFILE
        AH_Scheduled_Job_Setting__mdt jobMDT = [ SELECT ID, DeveloperName, 
                                                Label, 
                                                Endpoint__c, 
                                                Context_Username__c, 
                                                Schedulable_Classes__c, 
                                                Running_User_Profile_Name__c 
                                                FROM AH_Scheduled_Job_Setting__mdt 
                                                WHERE Label =: prf.Name];
        
        system.debug('jobMDT : '+jobMDT);
        
        classNamesSet = new Set<String>(jobMDT.Schedulable_Classes__c.split(','));
        system.debug('classNamesSet : '+classNamesSet);
        
        endPointUrl = jobMDT.Endpoint__c;
        
        // TO BE REMOVED LATER 
        //status = jobMDT.Context_Username__c +', '+  jobMDT.Running_User_Profile_Name__c   +', '+   jobMDT.Schedulable_Classes__c  +', '+ jobMDT.Endpoint__c;
        //endPointUrl = 'https://shashi1-dev-ed.my.salesforce.com/'; //remove later 
        
        // RETRIEVE DATA FROM CUSTOM SETTING - AH_Scheduled_Job_Credentials__c 
        AH_Scheduled_Job_Credentials__c credentials = new AH_Scheduled_Job_Credentials__c();
        credentials = AH_Scheduled_Job_Credentials__c.getValues(jobMDT.Running_User_Profile_Name__c);
        system.debug('credentials : '+credentials);
        
        if(credentials != NULL){
            
            // LOGIN TO REMOTE SF ORG
            //login(jobMDT.Context_Username__c, credentials.Context_User_Password__c, credentials.Context_User_Security_Token__c, jobMDT.Endpoint__c);
            status = 'login successful';
            
            
            try {
                string sEndPoint = 'https://login.salesforce.com/services/Soap/u/26.0'; 
                
                PartnerRemote.Soap soap = new PartnerRemote.Soap();
                
                //PartnerRemote.LoginResult loginResult = soap.login('shashi1@test.com', 'Jan@2020' + 'vokjkLXjiwbm3non2ZBHohSuK', sEndPoint);
                PartnerRemote.LoginResult loginResult = soap.login(uName, pwd + securityToken, sEndPoint);
                system.debug('loginResult.serverUrl : '+loginResult.serverUrl);
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
            
            
            // 
            Set<String> jobTypes = new Set<String>();
            jobTypes.add('ScheduledApex');
            String clsName = 'ScheduledApex';
            
            getScheduledJobsList();
        }
    }

    public void getScheduledJobsList() 
    {
        Map<String, String> classNameMap = new Map<String, String>();
        
        schldClassDetails = new Map<String, Map<String, String>>();
        
        if(!classNamesSet.isEmpty())
        {
            //String sql = 'SELECT Id, Name FROM CronJobDetail';
            String sql = 'SELECT ApexClass.Name, ApexClass.Namespaceprefix, Id, JobItemsProcessed, JobType, Status, NumberOfErrors, CreatedBy.Name, MethodName FROM AsyncApexJob ';
            //' where ApexClass.Name =: clsName';
            //' AND ApexClass.Name IN '+ classNamesSet ;
            system.debug('sql : '+sql);
            Httprequest request = getHttpRequests(endPointUrl);
            httpresponse permiResp = getHttpResponse(request, sessionId, sql);
            string resp= permiResp.getBody();
            system.debug('resp : '+resp);
            
            if (!resp.containsignorecase('<soapenv:Fault><faultcode>'))
            {
                Dom.XmlNode resultElmtPerm = permiResp.getBodyDocument().getRootElement()
                    .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('queryResponse', 'urn:enterprise.soap.sforce.com')
                    .getChildElement('result', 'urn:enterprise.soap.sforce.com');
                System.debug('resultElmtPerm : '+ resultElmtPerm);
                
                if (resultElmtPerm != null) {
                    for(Dom.XMLNode child : resultElmtPerm .getChildElements()) {
                        
                        if(child.getName() == 'records' ) {
                            
                            String status = '';
                            Map<String, String> innerMap = new Map<String, String>();
                            
                            for (Dom.XMLNode innerChild : child.getChildElements()) {
                                
                                system.debug('in for loop');
                                
                                if (innerChild.getName() != null && innerChild.getName() == 'Id') 
                                {
                                    system.debug('Id : '+innerChild.getText());
                                    innerMap.put('Id', innerChild.getText());
                                }
                                if (innerChild.getName() != null && innerChild.getName() == 'Status') 
                                {
                                    system.debug('Status : '+innerChild.getText());
                                    status = innerChild.getText();
                                    innerMap.put('Status', status);
                                }
                                if (innerChild.getName() != null && innerChild.getName() == 'JobType') 
                                {
                                    system.debug('JobType : '+innerChild.getText());
                                    innerMap.put('JobType', innerChild.getText());
                                }
                                if (innerChild.getName() != null && innerChild.getName() == 'CreatedBy') 
                                {                                        
                                    for (Dom.XMLNode innerChild1 : innerChild.getChildElements()) {
                                        
                                        if (innerChild1.getName() != null && innerChild1.getName() == 'Name') 
                                        {
                                            system.debug('CreatedBy : '+innerChild1.getText());
                                            innerMap.put('CreatedBy', innerChild1.getText());
                                        }
                                    }
                                }
                                
                                if (innerChild.getName() != null && innerChild.getName() == 'ApexClass') 
                                {
                                    for (Dom.XMLNode innerChild1 : innerChild.getChildElements()) {
                                        
                                        if (innerChild1.getName() != null && innerChild1.getName() == 'Name') 
                                        {
                                            system.debug('ApexClass : '+innerChild1.getText());
                                            innerMap.put('ApexClass', innerChild1.getText());
                                        }
                                    }
                                }                                    
                            }
                            if (status == 'Queued')
                            {
                                schldClassDetails.put(innerMap.get('ApexClass'), innerMap);
                            }
                        }
                    }
                    system.debug('schldClassDetails : '+schldClassDetails);
                    
                }
            }
            // PARSING RESPONSE COMPLETED
            
            for(String clName : classNamesSet)
            {
                classNameMap.put(clName, clName);
            }
            classNameMap.put('schedulerForContactCreation_1', 'schedulerForContactCreation_1');
            classNameMap.put('schedulerForContactCreation_2', 'schedulerForContactCreation_2');
        }
        
        system.debug('classNameMap : '+classNameMap);
        schldJobsData = new List<jobData>();
        // IF COMPLETED HERE
        if (classNameMap != NULL)
        {
            for(String clssName : schldClassDetails.keySet())
            {
                system.debug('in for loop : '+clssName);
                if(classNameMap.containsKey(clssName))
                {
                    Map<String, String> innerMap = schldClassDetails.get(clssName);
                    
                    jobData job = new jobData();
                    job.jobId = innerMap.get('Id');
                    job.ClassName = innerMap.get('ApexClass');
                    job.JobType = innerMap.get('JobType');
                    job.status = innerMap.get('Status');
                    job.CreatedBy = innerMap.get('CreatedBy');
                    
                    schldJobsData.add(job);
                }
            }
        }
        system.debug('schldJobsData : '+schldJobsData);
    }
    
    public void setClassOptsList(String classNames)
    {
        classOptions = new List<SelectOption>();
        
        List<String> classList = classNames.split(',');
        classOptions.add(new SelectOption('','-None-'));
        
        for(String className : classList)
        {
            classOptions.add(new SelectOption(className,className));
        }
    }

    public void saveFunc()
    {
        
        system.debug('theData : '+theData.cronExpression);
        if(theData.cronExpression != NULL)
        {
            scheduleClasses(theData.cronExpression);
        }

    }
    
    public void doCancel()
    {
        system.debug('in doCancel func '+theData);
    }
    
    public void scheduleClasses(String cronString)
    {
        
        try 
        {
            system.debug('Scheduling classes...'+endPointUrl);
            
            // CREATE NEW HTTP REQUEST TO LOGIN IN ORG  
            Httprequest request = getHttpRequests(endPointUrl+'services/Soap/s/36.0');
            
            //String apexString = 'schedulerForContactCreation sch2 = new schedulerForContactCreation();String sch = \'0 40 17 * * ?\'; system.schedule(\''+jobName+'\', sch, sch2);';
            String apexString = selectedClass+' sch2 = new '+selectedClass+'();String sch = \''+cronString+'\'; system.schedule(\''+jobName+'\', sch, sch2);';
            
            system.debug('apexString : '+apexString);
            
            request.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:apex="http://soap.sforce.com/2006/08/apex"><soapenv:Header><apex:DebuggingHeader><apex:categories><apex:category>Apex_code</apex:category><apex:level>ERROR</apex:level></apex:categories><apex:debugLevel>NONE</apex:debugLevel></apex:DebuggingHeader><apex:SessionHeader><apex:sessionId>'+ sessionId +'</apex:sessionId></apex:SessionHeader></soapenv:Header><soapenv:Body><apex:executeAnonymous><apex:String>'+ apexString +'</apex:String></apex:executeAnonymous></soapenv:Body></soapenv:Envelope>');
            httpresponse bodyresp2 = (new Http()).send(request);
            string resp= bodyresp2.getBody(); 
            system.debug(' **** Response = ' + resp);
            
            // CHECK FOR INVALID LOGIN 
            if (resp.containsignorecase('<soapenv:Fault><faultcode>'))
            {
                Dom.XmlNode resultElmt1 = bodyresp2 .getBodyDocument().getRootElement()
                    .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('Fault','http://schemas.xmlsoap.org/soap/envelope/');
                String faultcode = resultElmt1.getChildElement('faultcode', null).getText();
                String faultstring = resultElmt1.getChildElement('faultstring', null).getText();
                
                system.debug(' **** faultstring = ' + faultstring);
                //NI_Error_Logger.WriteToLogwithOrgDetailId(srcOrgID, faultstring, 'NI_Org_Details__c', 'AH_FetchTrialExpirationBatchHelper', 'Insert');

            }
            
            // LOGIN IS UNSUCCESSFUL THEN SKIP ALL OTHER PROCESSES 
            if (!resp.containsignorecase('<soapenv:Fault><faultcode>'))
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Confirm,  'Job scheduled succesfully.'));
               /* Dom.XmlNode resultElmt = bodyresp2 .getBodyDocument().getRootElement()
                    .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
                    .getChildElement('executeAnonymousResponse', 'urn:apex.soap.sforce.com')
                    .getChildElement('result', 'urn:apex.soap.sforce.com');
                
                system.debug('resultElmt : '+resultElmt);
                */
                // FETCH SESSION ID AND SERVER URL FROM RESPONSE
                //String SERVER_URL = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
                //String SESSION_ID = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();
            }
        }
        catch (Exception e) 
        {
            system.debug('Exception occured at ' + e.getlinenumber() + '\n\n' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,  + e.getMessage()));
            //NI_Error_Logger.WriteToLogwithOrgDetailId(srcOrgID, 'Exception occured at line no. :' + e.getlinenumber() + '. ' + e.getMessage(), 'NI_Org_Details__c', 'AH_FetchTrialExpirationBatchHelper', 'Insert');
        }
    }
   
    public static httprequest getHttpRequests(string SERVER_URL)
    {
        Httprequest request = new HttpRequest();
        request.setEndpoint(SERVER_URL + '/services/Soap/c/36.0');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        return request;
        
        // CALL SCHEDULE CLASS METHOD HERE THIS WILL EXECUTE AFTER POST AND SCHEDULE CLASS FOR EXTERNAL ORG.
    }
    
    public static HttpResponse getHttpResponse (Httprequest request, String SESSION_ID, String sql)
    {
        
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
        
        //USE METHOD HERE TO GET THE SCHEDULED CLASS LIST AND DISPLAY ON THE VF PAGE.
    }    
    
        /*
    public MetadataService.MetadataPort createService()
    {   
    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    service.SessionHeader = new MetadataService.SessionHeader_element();
    service.SessionHeader.sessionId = sessionId;
    return service;     
    }
    */
    
}
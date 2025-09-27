public class findObejctDetails {

    public Set<String> stdObjects;
    private String serverUrl;     
    private String orgId;     
    private String origLocale;    
    private String userId;
    public String sessionId { get; set; } 
    
    public void login() 
    {   
        string sEndPoint = 'https://login.salesforce.com/services/Soap/u/26.0'; 
        
        //if (account.Org_Type__c.Contains('Salesforce Sandbox'))
        //{   
        //    sEndPoint = 'https://test.salesforce.com/services/Soap/u/26.0'; 
        //}

        PartnerRemote.Soap soap = new PartnerRemote.Soap();
        //PartnerRemote.LoginResult loginResult = soap.login(account.AdminLoginName__c, account.AdminPassword__c); <-- ORIGINAL
        // PartnerRemote.LoginResult loginResult = soap.login(account.AdminLoginName__c, account.AdminPassword__c, sEndPoint); 
        //PartnerRemote.LoginResult loginResult = soap.login(account.AdminLoginName__c, account.AdminPassword__c.trim() + account.SecurityToken__c.trim(), sEndPoint); 
        //if(!Test.isRunningTest()){
	        PartnerRemote.LoginResult loginResult = soap.login('shashi1@test.com', 'Mypass@1234' + 'YK7Zpnb93gk224erfONugJJs', sEndPoint);  
	        soap.endpoint_x = loginResult.serverUrl; 
	        serverUrl = loginResult.serverUrl.split('/services')[0]; 
	        sessionId = loginResult.sessionId; 
	        orgId = loginResult.userInfo.organizationId; 
	        origLocale = loginResult.userInfo.userLocale; 
	        userId = loginResult.userInfo.userId; 
        //}
    }
    
    
    public void getDetails()
    {
        stdObjects = new Set<String>();
		stdObjects.add('ActivityHistory');
		stdObjects.add('AttachedContentDocument');
		//stdObjects.add('Attachment');
		stdObjects.add('CollaborationGroupRecord');
		stdObjects.add('CombinedAttachment');
		stdObjects.add('ContactRequest');
		stdObjects.add('ContentDistribution');
		stdObjects.add('ContentDocumentLink');
		stdObjects.add('ContentVersion');
		stdObjects.add('DuplicateRecordItem');
		stdObjects.add('EntitySubscription');
		//stdObjects.add('Event');
		stdObjects.add('EventChangeEvent');
		stdObjects.add('EventRelationChangeEvent');
		stdObjects.add('FeedComment');
		stdObjects.add('FeedItem');
		stdObjects.add('FlowRecordRelation');
		stdObjects.add('NI_Project_Backlog__c_hd');
		stdObjects.add('NetworkActivityAudit');
		stdObjects.add('NetworkUserHistoryRecent');
		//stdObjects.add('Note');
		stdObjects.add('NoteAndAttachment');
		stdObjects.add('OpenActivity');
		stdObjects.add('Opportunity__hd');
		stdObjects.add('ProcessInstance');
		stdObjects.add('ProcessInstanceHistory');
		//stdObjects.add('RecordAction');
		stdObjects.add('RecordActionHistory');
		//stdObjects.add('Task');
		stdObjects.add('TaskChangeEvent');
		stdObjects.add('TopicAssignment');
		stdObjects.add('OutgoingEmail');
        
        
        Integer cnt = 0;
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        system.debug('schemaMap size : '+schemaMap.size());
        for(String s : schemaMap.keyset())
        {
            String objName = String.valueOf(schemaMap.get(s));
            //system.debug('1 objName : '+objName);
            Pattern MyPattern = Pattern.compile('(.*?)(tag|history|feed|changeevent|Tag|History|Feed|Changeevent|ChangeEvent|share|Share|__c)$');
            Matcher MyMatcher = MyPattern.matcher(objName);
            
            if (!MyMatcher.matches())
            {
                //system.debug('Object Name : '+objName);
                try{
                    Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objName).getDescribe().fields.getMap();
                    Integer fieldsCnt = 0;
                    Integer managedPkgfieldsCnt = 0;
                    
                    Set<String> namespaceSet = new Set<String>();
                    
                    for(Schema.SObjectField sfield: fieldMap.Values())
                    {
                        schema.describefieldresult dfield = sfield.getDescribe();
                        String val = dfield.getType () + ' : ' + dfield.getName ();
                        
                        String fieldName = dfield.getName();
                        Pattern MyPattern1 = Pattern.compile('(.*?)(__c)$');
                        Matcher MyMatcher1 = MyPattern1.matcher(fieldName);
                        if (MyMatcher1.matches())
            			{      
                            //system.debug('Object Name : '+objName);
                        	system.debug('val : '+val);
                            fieldsCnt++;
                            
                            Pattern fieldPat = Pattern.compile('(.*?)__(.*?)__c$');
                            Matcher mtcher2 = fieldPat.matcher(fieldName);
                            if(mtcher2.matches())
                            {
                                system.debug('Managed Package Field Namespace : '+mtcher2.group(1));
                                String pkgNamespace = mtcher2.group(1);
                                namespaceSet.add(pkgNamespace);
                                managedPkgfieldsCnt++;
                            }
                        }
                    }
                    
                    cnt++;
                    system.debug('Object Name : '+objName + ' => '+fieldsCnt);
                    system.debug(objName+' : Managed Package Field count : '+managedPkgfieldsCnt +' : total pkgs count  : '+namespaceSet.size() +' : SET : '+namespaceSet);
                }
                catch(Exception e)
                {
                    system.debug('Exception found for objName : '+objName);
                }
            }
        }
        
        system.debug('Object\'s Count : '+cnt);
    }


    // METHOD TO RETRIEVE FIELDS FROM SELECTED OBJECT
	public void retrieveAllFields()
	{
        String objName = 'Lead';
        
        List<String> fieldsList = new List<String>();

        // RETRIEVE USING METADATA API CALL
		String queryURL = 'sobjects/' + objName + '/describe';
		HttpResponse res = getHttpResponse(queryURL);
		String responseBody = res.getBody();
		system.debug('Object Describe responseBody : ' + responseBody);
		Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
		system.debug('resultMap size : ' + resultMap.size());
		for(String s : resultMap.keyset())
		{
			if (s == 'fields')
			{
				List<Object> fieldsList1 = (List<Object>)resultMap.get(s);

				system.debug('Field List size : ' + fieldsList1.size());
				//system.debug('fieldsList : '+fieldsList);

				for(Object s1 : fieldsList1)
				{
					Map<String, Object> s1Map = (Map<String, Object>)s1;
					for(String s2 : s1Map.keyset())
					{
						//system.debug(s2+ ' : '+s1Map.get(s2));
						if (s2 == 'name')
						{
							//system.debug('s1Map Field Name : ' + s1Map.get(s2));
							fieldsList.add(String.valueOf(s1Map.get(s2)));
						}
					}
				}
			}
		}
        system.debug('fieldsList size from Metadata API call : ' + fieldsList);
        
        Integer fieldsCnt = 0;
        Integer managedPkgfieldsCnt = 0;
        Set<String> namespaceSet = new Set<String>();
        
        for(String fieldName : fieldsList)
        {
            system.debug('fieldName : '+fieldName);
            Pattern MyPattern1 = Pattern.compile('(.*?)(__c)$');
            Matcher MyMatcher1 = MyPattern1.matcher(fieldName);
            if (MyMatcher1.matches())
            {      
                fieldsCnt++;
                
                Pattern fieldPat = Pattern.compile('(.*?)__(.*?)__c$');
                Matcher mtcher2 = fieldPat.matcher(fieldName);
                if(mtcher2.matches())
                {
                    system.debug('Managed Package Field Namespace : '+mtcher2.group(1));
                    String pkgNamespace = mtcher2.group(1);
                    namespaceSet.add(pkgNamespace);
                    managedPkgfieldsCnt++;
                }
            }
            
        }
        system.debug('Object Name : '+objName + ' => '+fieldsCnt);
        system.debug(objName+' : Managed Package Field count : '+managedPkgfieldsCnt +' : total pkgs count  : '+namespaceSet.size() +' : SET : '+namespaceSet);
		
	}
    


	// SEND HTTP REQUEST
	private HttpResponse getHttpResponse(String URL)
	{
		String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
		system.debug('salesforceHost : ' + salesforceHost);

		String queryURL = salesforceHost + '/services/data/v45.0/' + URL;
		system.debug('queryURL : ' + queryURL);

		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(queryURL);
		req.setHeader('Content-type', 'application/json');
		req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
		Http http = new Http();
		HTTPResponse resp = http.send(req);

		return resp;
	}

    
/*
    Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    system.debug('schemaMap size : '+schemaMap.size());
    for(String s : schemaMap.keyset())
    {
        system.debug('Object Name : '+s);
        system.debug('Object Name : '+schemaMap.get(s).getDescribe());
    }
    Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Account').getDescribe().fields.getMap();
    for(Schema.SObjectField sfield : fieldMap.Values())
    {
        schema.describefieldresult dfield = sfield.getDescribe();
        system.debug('#######' + dfield );
        system.debug('Field Name : '+dfield.getname());
        String val = dfield.getType () + ' : ' + dfield.getLabel ();
        system.debug('val : '+val);
    }
    
*/
}
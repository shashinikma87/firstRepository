public class processBldrBatch {
/*
// CODE TO ITERATE OVE RPROCESS BUILDER
			String queryURL = 'tooling/query?q=Select+ID+from+Flow';
			HttpResponse res = getHttpResponse(queryURL);
			String responseBody = res.getBody();
			Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
			flowIdNameList = new List<String>();

			for (String s : resultMap.keyset())
			{

				if (s == 'records')
				{
					Integer cnt = 0;
					List<Object> records = (List<Object>)resultMap.get(s);

					for (Object s1 : records)
					{
						Map<String, Object> s1Map = (Map<String, Object>)s1;
						flowIdNameList.add(String.valueOf(s1Map.get('Id')));
						cnt++;
					}
				}
			}

			if (!Test.isRunningTest())
			{
				AH_RecordReferenceProcessBldr_Batch btch = new AH_RecordReferenceProcessBldr_Batch(finalstr, flowIdNameList, objectName, fieldName, keyword, timeStamp);
				Database.executeBatch(btch,1);
			}


/////////////////////// BATCH ///////////////////////
global class AH_RecordReferenceProcessBldr_Batch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts
{
	public List<String> IdNameList = new List<String>();
	public String timeStamp;
	public String objectName;
	public String fieldName;
	public String keyword;
	public String crossRefFieldName;
	public String label = '';
	public String csvString = 'Setup Record ID, Setup Record Name, Type \n';
	public List<String> csvList = new List<String>();

	// CONSTRUCTOR
	public AH_RecordReferenceProcessBldr_Batch(String csvData, List<String> lst, String obj, String field, String word, String timeString)
	{
		system.debug('In AH_RecordReferenceProcessBldr_Batch constructor...');

		for (string s : lst)
		{
			IdNameList.add(s);
		}

		objectName = obj;
		fieldName = field;
		keyword = word;
		csvString = csvString + csvData;
		timeStamp = timeString;

		crossRefFieldName = fieldName.replace('__c', '__r');
	}

	// ========================= START METHOD ================================
	global Iterable<String> start(Database.BatchableContext BC)
	{
		return IdNameList;
	}

	// ========================= EXECUTE METHOD ===============================
	global void execute(Database.BatchableContext BC, List<String> scope)
	{
		try
		{
			String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
			String flowId = scope[0];
			String url =  salesforceHost + '/services/data/v45.0/tooling/sobjects/Flow/' + flowId;

			HttpRequest req = new HttpRequest();
			req.setMethod('GET');
			req.setEndpoint(url);
			req.setTimeout(12000);
			req.setHeader('Content-type', 'application/json');
			req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
			Http http = new Http();
			HTTPResponse res = http.send(req);
			String responseBody = res.getBody();

			Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
			label = String.valueOf(resultMap.get('MasterLabel'));

			Map<String, String> varMap = new Map<String, String>();
			Map<String, String> condMap = new Map<String, String>();

			List<String> formulaList = new List<String>();

			for (String ss : resultMap.keyset())
			{
				if (ss == 'Metadata')
				{
					Map<String, Object> ss1Map = (Map<String, Object>)resultMap.get(ss);
					String crossRefObjName = objectName.replace('__c', '__r');
					String sss = '';
					Integer cnt = 1;
					Boolean formulaFlag = false;
					Map<String, String> formulaNamesMap = new Map<String, String>();

					// IF LOOP TO CHECK THE FORMULA IN WORKFLOW ONLY OBJECT NAME & FIELD NAME WILL BE CHECKED IN FORMULA
					if (ss1Map.get('decisions') != null)
					{
						for (Object o : (List<Object>)ss1Map.get('decisions'))
						{
							Map<String, Object> rulesMap = (Map<String, Object>)o;
							List<Object> rulesList = (List<Object>)rulesMap.get('rules');

							for (Object rule : (List<Object>)rulesMap.get('rules'))
							{
								Map<String, Object> conditionsMap = (Map<String, Object>)rule;

								for (Object condition : (List<Object>)conditionsMap.get('conditions'))
								{
									Map<String, Object> singleCondition = (Map<String, Object>)condition;
									Object ooo = singleCondition.get('rightValue');
									Map<String, Object> valueMap = (Map<String, Object>)ooo;

									String rightValue = '';

									if (String.valueOf(singleCondition.get('leftValueReference')).contains('formula_myRule'))
									{
										formulaFlag = true;
										String name = String.valueOf(singleCondition.get('leftValueReference'));
										formulaNamesMap.put(name, name);
									}
									else
									{
										if (valueMap != null)
										{
											for (String val : valueMap.keySet())
											{
												if (String.valueOf(valueMap.get(val)) != null)
												{
													rightValue = String.valueOf(valueMap.get(val));
												}
											}
											cnt++;

											condMap.put(cnt + '_' + String.valueOf(singleCondition.get('leftValueReference')), rightValue);
										}
									}
								}
							}
						}
					}

					// EXTRACT FORMULAS HERE
					if (formulaFlag)
					{
						for (Object o : (List<Object>)ss1Map.get('formulas'))
						{
							Map<String, Object> formMap = (Map<String, Object>) o;

							if (formulaNamesMap.containsKey(String.valueOf(formMap.get('name'))))
							{
								formulaList.add(String.valueOf(formMap.get('expression')) );
							}
						}
					}

					// EXTRACT VARIALBES HERE
					if (ss1Map.get('variables') != null)
					{
						for (Object o : (List<Object>)ss1Map.get('variables'))
						{
							Map<String, Object> vMap = (Map<String, Object>) o;
							varMap.put(String.valueOf(vMap.get('name')), String.valueOf(vMap.get('objectType')) );
						}
					}
				}
			}

			// MAKE MATCH IN CRITERIA ITEMS
			Boolean criteriaMatchFound = false;
			for (String s1 : condMap.keyset())
			{
				String regExp = '^\\d+_';
				String variable = s1.replaceAll(regExp, '');

				List<String> varList = variable.split('\\.');

				if (varMap.containsKey(varList[0]))
				{
					String objName = varMap.get(varList[0]);
					String actualValue = condMap.get(s1);

					if (varList.size() > 1)
					{
						String fName = varList[1];

						if (objName.containsIgnoreCase(objectName) &&  fName.containsIgnoreCase(fieldName)  &&  actualValue.containsIgnoreCase(keyword))
						{
							criteriaMatchFound = true;
						}
					}
				}
			}

			// MAKE MATCH IN FORMULA LIST
			Boolean isFormulaMatchFound = false;

			for (String varName : varMap.keyset())
			{
				String obName = varMap.get(varName);
				for (String formula : formulaList)
				{
					if (obName != null && obName.toLowerCase() == objectName.toLowerCase() &&
					    (formula.containsIgnoreCase(varName) || formula.containsIgnoreCase(fieldName) || formula.containsIgnoreCase(crossRefFieldName)))
					{
						isFormulaMatchFound = true;
					}
				}
			}

			// IF OBJECT NAME / FIELD NAME / VALUE MATCHES WITH FORMULA OR CRITERIA THEN
			// CREATE A STRING TO ADD IN CSV FILE
			if (criteriaMatchFound || isFormulaMatchFound)
			{
				String recordString = '"' + flowId + '","' + label + '","' + 'Process Builder' + '"\n';
				csvList.add(recordString);
			}
		}
		catch (Exception e)
		{
			system.debug('Found exception AH_RecordReferenceProcessBldr_Batch : ' + e + '... at line : ' + e.getLineNumber());
			AH_RecordReferenceSearch_Cntlr errLog = new AH_RecordReferenceSearch_Cntlr();
			errLog.WriteToLog('Error Type: ' + e.getTypeName() + ', \nCause: ' + e.getCause() + ', \nLine Number: ' + e.getLineNumber() + ', \nError Message: ' + e.getMessage() + ' \n', timeStamp, 'Process Builder Batch execute method', 'Tooling API Callout');
		}
	}

	// ========================= FINISH METHOD =========================
	global void finish(Database.BatchableContext BC)
	{
		List<String> CSVStringList = csvString.split('\n');

		Integer recSize = CSVStringList.size() + csvList.size();

		if (!csvList.isEmpty())
		{
			for (String line : csvList)
			{
				csvString = csvString + line;
			}
		}

		// SEND MAIL TO RUNNING USER
		String fileName = objectName + '_' + fieldName + '_' + keyword + '_' + String.valueof(DateTime.now().getTime());

		// SEND MAIL TO RUNNING USER
		Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
		blob csvBlob = Blob.valueOf(csvString);
		csvAttc.setFileName(fileName + '.csv');
		csvAttc.setBody(csvBlob);
		String userEmailID = Userinfo.getUserEmail();
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {userEmailID};
		String subject = 'Setup Object search details';
		email.setSubject(subject);
		email.setToAddresses(toAddresses);
		email.setPlainTextBody('Please find the attached CSV for associated records.');
		email.setFileAttachments(new Messaging.EmailFileAttachment[] {csvAttc});
		Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

		Job_Run_History__c runHist = new Job_Run_History__c();
		runHist.Apex_Class__c = 'ProcessBuilderBatch';
		runHist.Status__c = 'Run';
		runHist.No_of_Items_Processed__c = recSize;
		runHist.Target_Object__c = '';
		runHist.User__c = UserInfo.getUserName();
		runHist.Created_Date__c = Datetime.now();
		runHist.Unique_Timestamp__c = timeStamp;
		runHist.Status_Detail__c = 'Success';

		insert runHist;
	}
}






*/
}
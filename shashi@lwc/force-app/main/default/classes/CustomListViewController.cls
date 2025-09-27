public class CustomListViewController {
    
    private static String columnCSV = '';
    
    @AuraEnabled
    public static void updateColumnSelection(List<String> columnString1){
        
        system.debug('columnString1 : '+columnString1);
        DMT_SolutioningListViewCoulmns__c cs = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        
        if (!columnString1.isEmpty()) {
            String columnString = String.join(columnString1,',');
            system.debug('columnCSV : '+columnString);
            
            
            if (columnString != '' || columnString != null) {
                
                cs.ColumnNames__c = columnString;
                update cs;
            }
            system.debug('cs : '+cs.ColumnNames__c);
        }
        else {
            cs.ColumnNames__c = 'Band,PSL Roles,IBM Delivery Lead';
            update cs;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static DynamicLWCDataTableController.DataTableResponse  returnSelectedColumns(String solIdentifier, String deliveryHead){
        
        system.debug('I am in side returnSelectedColumns');
        
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        columnsMap = getColumnsMap(); 
        
        List<Case> cases = new List<Case>();
        cases = filteredCases(solIdentifier, deliveryHead);
        
        DynamicLWCDataTableController.DataTableResponse tableResponse = 
            DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(columnsMap, cases);
        system.debug('tableResponse : '+tableResponse);
        
        return tableResponse;
    }
    
    @AuraEnabled
    public static Map<String,String> returnColumns() {
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        system.debug('mfields : '+mfields);
        
        Map<String,String> fieldsMap = new Map<String,String> ();
        
        for (String fieldName: mfields.keySet()) {
            // changing to field label
            fieldsMap.put(fieldName,mfields.get(fieldName).getDescribe().getLabel());
        }
        
        return fieldsMap;
    }
    
    
    @AuraEnabled
    public static string updateDemands( Object data ) {
        
        List<Case> casesForUpdate = ( List<Case> ) JSON.deserialize(
            JSON.serialize( data ),
            List < Case >.class
        );
        try {
            update casesForUpdate;
            return 'Success: Demands(s) updated successfully';
        }
        catch (Exception e) {
            return 'The following exception has occurred:' + e.getMessage();
        }
        
    }
    
    /**
* Methos is getting called when Searched for Case Number
*/
    @AuraEnabled(Cacheable = true)
    public static list<Case> retriveCases(String strcasenumber) {
        string  caseNumber = '%' + strcasenumber + '%';
        list<Case> listOfCases = [SELECT Id, CaseNumber
                                  /*Band__c,Band_for_costing__c,Price__c,Demand_Status__c,PSL_Rate_Card__c, CaseNumber, Transaction_Cycle__c, TC_Cluster__c, Demand_Type__c,Engagement_Type__c,
PSL_Role__c,PSL_Skillset_only_for_Dev_roles__c,Skills__c,Skills_Mapping_to_PMP__c,Location__c,
Daily_Delivery_GP__c,Daily_Release_GP__c, Solution_identifier__c,Total_Group_Value__c */
                                  FROM Case WHERE CaseNumber LIKE :caseNumber];
        if(listOfCases.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        system.debug('listOfCases');
        return listOfCases; 
    }
    
    /**
*  Added this method on 15 March 2023 as part of ne filter criteria...
*/
    @AuraEnabled(cacheable=true)
    public static list<case> filteredCases(String solIdentifier, String deliveryHead) {
        
        List<Case> listofCases = new List<Case>();
        String solutionId = '%' + solIdentifier + '%';
        String ibmDeliveryHead = '%' + deliveryHead + '%';
        String loggedInUserName = userinfo.getName();
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        
        
        Map<String,String> fieldMap = new Map<String,String>();
        for (String fieldName: mfields.keySet()) {
            
            fieldMap.put(mfields.get(fieldName).getDescribe().getLabel(), fieldName );
            
            Map<String,String> innerColumnMap = new Map<String,String>();
            innerColumnMap.put('label',mfields.get(fieldName).getDescribe().getLabel());
            innerColumnMap.put('fieldName',fieldName);
            innerColumnMap.put('fieldType',String.valueOf(mfields.get(fieldName).getDescribe().getType()));
            columnsMap.put(mfields.get(fieldName).getDescribe().getLabel(), innerColumnMap);
        }
        
        system.debug('fieldMap : '+fieldMap);
        
        String colms = '';
        
        List<string> colList = new List<string>();
        DMT_SolutioningListViewCoulmns__c sls = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        List<String> columnsSet = new List<String>();
        columnsSet = sls.ColumnNames__c.split(',');
        system.debug('columnsSet :'+columnsSet);
        if (!columnsSet.isEmpty()){
            for (String fieldLabel : columnsSet) {
                if(fieldMap.containsKey(fieldLabel)){
                    colList.add(fieldMap.get(fieldLabel));
                }
            }
        }
        
        system.debug('colList : '+colList);
        colms = String.join(colList,',');
        
        system.debug('colms of api names : '+colms);
        //colms = '';
        try {
            system.debug('logged in username--> '+loggedInUserName);
            saveValuesToSettings(solIdentifier,deliveryHead,loggedInUserName);
            system.debug('colms : '+colms);
            
            String query = 'SELECT ' +colms ;  
            query +=' FROM Case ';
            
            if(!String.isBlank(solIdentifier) && !String.isBlank(deliveryHead)){
                query += ' WHERE IBM_Delivery_Lead__r.Name LIKE  \''+ibmDeliveryHead + '\'' +
                    ' AND Solution_identifier__c LIKE \''+solutionId + '\'';
            }
            else if(!String.isBlank(solIdentifier) && String.isBlank(deliveryHead)){
                query += ' WHERE Solution_identifier__c LIKE  \''+solutionId + '\'';
            }
            else if(String.isBlank(solIdentifier) && !String.isBlank(deliveryHead)){
                query += ' WHERE IBM_Delivery_Lead__r.Name LIKE  \''+ibmDeliveryHead + '\'';
            } 
            
            
            system.debug('query : '+query);
            
            listOfCases = Database.query(query);
            
            system.debug('listOfCases  : '+listOfCases);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        system.debug('listOfCases  : '+listOfCases);
        
        return listOfCases; 
    }
    
    @future
    public static void saveValuesToSettings(String solId, String delLead,String usrName){
        DTM_CustomListFilterSetting__c obj = DTM_CustomListFilterSetting__c.getInstance(usrName);
        if(delLead != null || delLead !=''){
            obj.IBM_Delivery_Lead__c = delLead;
        }else{
            obj.IBM_Delivery_Lead__c = '';
        }
        if(solId != null || solId !=''){
            obj.Solution_Identifier__c = solId;
        }else{
            obj.Solution_Identifier__c = '';
        }
        update obj;
    }
    
    	//Added on 16 March
    @AuraEnabled(Cacheable=true)
    public static Map<String,String> searchValuesResult(){
        Map<String,String> filterValMap = new Map<String,String>();
        String usrName = userinfo.getName();
        DTM_CustomListFilterSetting__c obj = DTM_CustomListFilterSetting__c.getInstance(usrName);
        if(obj.IBM_Delivery_Lead__c != null || obj.IBM_Delivery_Lead__c != ''){
            filterValMap.put('Delivery Lead',obj.IBM_Delivery_Lead__c);
        }
        else{
            filterValMap.put('Delivery Lead','');
        }
        if(obj.Solution_Identifier__c != null || obj.Solution_Identifier__c != ''){
            filterValMap.put('Solution Identifier',obj.Solution_Identifier__c);
        }
        else{
            filterValMap.put('Solution Identifier','');
        }
        
        system.debug('filterValMap : '+filterValMap);
        
        return filterValMap;
    }
    
    public static Map<String,Map<String,String>> getColumnsMap() {
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        
        DMT_SolutioningListViewCoulmns__c sls = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        system.debug('sls : '+sls.ColumnNames__c);
        columnCSV = sls.ColumnNames__c;
        List<String> selectedClmsList = new List<String>();
        selectedClmsList = sls.ColumnNames__c.split(',');
        
        for (SObjectField fieldName: mfields.values()) {
            
            String fieldAPI = String.valueOf(fieldName);
            system.debug('fieldAPI :' + fieldAPI);
            String fieldlabel = fieldName.getDescribe().getLabel();
            
            if (selectedClmsList.contains(fieldlabel)) { 
                
                Schema.DisplayType FldType = fieldName.getDescribe().getType();
                String fieldType = string.valueOf(FldType);
                
                Map<String,String> innerColumnMap = new Map<String,String>();
                innerColumnMap.put('label',fieldlabel);
                innerColumnMap.put('fieldName',fieldAPI);
                innerColumnMap.put('fieldType',fieldType);
                columnsMap.put(fieldlabel, innerColumnMap);
            }
        }
        
        system.debug('columnsMap----> '+columnsMap);
        
        return columnsMap;
    }
    
    
    // Generic function to return columns
    public static String returnCSVForFields(){
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        Map<String,String> fieldMap = new Map<String,String>();
        String colms = '';
        
        //for (String fieldName: mfields.keySet()) {
        for (SObjectField fieldName: mfields.values()) {
            
            String fieldAPI = String.valueOf(fieldName);
            system.debug('fieldAPI :' + fieldAPI);
            String fieldlabel = fieldName.getDescribe().getLabel();
            
            Schema.DisplayType FldType = fieldName.getDescribe().getType();
            String fieldType = string.valueOf(FldType);
            
            fieldMap.put(fieldlabel, fieldAPI );
            Map<String,String> innerColumnMap = new Map<String,String>();
            innerColumnMap.put('label',fieldlabel);
            innerColumnMap.put('fieldName',fieldAPI);
            innerColumnMap.put('fieldType',fieldType);
            columnsMap.put(fieldlabel, innerColumnMap);
            
        }
        
        system.debug('columnsMap----> '+columnsMap);
        system.debug('fieldMap : '+fieldMap);
        
        List<string> colList = new List<string>();
        DMT_SolutioningListViewCoulmns__c sls = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        List<String> columnsSet = new List<String>();
        columnsSet = sls.ColumnNames__c.split(',');
        system.debug('columnsSet :'+columnsSet);
        if (!columnsSet.isEmpty()){
            for (String fieldLabel : columnsSet) {
                if(fieldMap.containsKey(fieldLabel)){
                    if(columnsMap.get(fieldLabel).get('fieldType')!='REFERENCE'){
                        colList.add(fieldMap.get(fieldLabel));
                    }
                    //}
                    //TBD
                    if(columnsMap.get(fieldLabel).get('fieldType')=='REFERENCE'){
                        String s1 = fieldMap.get(fieldLabel);
                        system.debug('s1 in first---> '+s1);
                        String s2 = s1.substringBefore('__');
                        String finalAPIName = s2+'__r.Name';
                        system.debug('fieldLabel---> '+fieldLabel);
                        system.debug('columnsMap.get(fieldLabel)----> '+columnsMap.get(fieldLabel));
                        system.debug('finalAPIName----> '+finalAPIName);
                        colList.add(finalAPIName);
                        //colList.add(fieldMap.get(fieldLabel));
                    }
                    //TBD
                }//TBD
            }
        }
        system.debug('colList : '+colList);
        colms = String.join(colList,',');
        system.debug('colms of api names : '+colms);
        
        return colms;
    }
    
}



/*
public class CustomListViewController {
    
    private static String columnCSV = '';
 
    @AuraEnabled
    public static void updateColumnSelection(List<String> columnString1){
        
        system.debug('columnString1 : '+columnString1);
        DMT_SolutioningListViewCoulmns__c cs = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        
        if (!columnString1.isEmpty()) {
            String columnString = String.join(columnString1,',');
            system.debug('columnCSV : '+columnString);
            
            
            if (columnString != '' || columnString != null) {
                
                cs.ColumnNames__c = columnString;
                update cs;
            }
            system.debug('cs : '+cs.ColumnNames__c);
        }
        else {
            cs.ColumnNames__c = 'Band,PSL Roles,IBM Delivery Lead';
            update cs;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static DynamicLWCDataTableController.DataTableResponse  returnSelectedColumns(String solIdentifier, String deliveryHead){
        
        system.debug('I am in side returnSelectedColumns');
        
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        columnsMap = getColumnsMap(); 
                
        List<Case> cases = new List<Case>();
        cases = filteredCases(solIdentifier, deliveryHead);
        
        DynamicLWCDataTableController.DataTableResponse tableResponse = 
            DynamicLWCDataTableController.GetWrapperOfSObjectFieldColumnActionValues(columnsMap, cases);
        system.debug('tableResponse : '+tableResponse);

		return tableResponse;
    }
    
    @AuraEnabled
    public static Map<String,String> returnColumns() {
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        system.debug('mfields : '+mfields);
        Map<String,String> fieldsMap = new Map<String,String> ();
        
        for (SObjectField fieldName: mfields.values()) {
            
            String fieldAPI = String.valueOf(fieldName);
            system.debug('fieldAPI :' + fieldAPI);
            String fieldlabel = fieldName.getDescribe().getLabel();
            
            fieldsMap.put(fieldAPI,fieldlabel );
        }
        
        return fieldsMap;
    }
    
    @AuraEnabled
    public static String updateTotalGroupValue(String listOfDemands,String totalGPValue) {
        List<Case> demandList = (List<Case>) JSON.deserialize(listOfDemands, List<Case>.class);
        for(Case demand:demandList){
            system.debug('demand.Total_Group_Value__c : '+demand.Total_Group_Value__c);
            system.debug('Decimal.valueOf(totalGPValue) : '+Decimal.valueOf(totalGPValue));
            demand.Total_Group_Value__c = Decimal.valueOf(totalGPValue);
            system.debug('demand.Total_Group_Value__c : '+demand.Total_Group_Value__c);
        }
        update demandList;
        
        return 'Success';
    }
    
     @AuraEnabled
    public static string updateDemands( Object data ) {
        system.debug('inside update demands---> '+data);
        List<Case> casesForUpdate = ( List<Case> ) JSON.deserialize(
            JSON.serialize( data ),
            List < Case >.class
        );
        try {
            system.debug('inside update demands casesForUpdate---> '+casesForUpdate);
            update casesForUpdate;
            return 'Success: Demands(s) updated successfully';
        }
        catch (Exception e) {
            return 'The following exception has occurred casesForUpdate:' + e.getMessage();
        }

    }
    
    @AuraEnabled
    Public static String submitForApproval(String comments,List<String>listOfDemand){
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
        Approval.ProcessResult[] processResults = null;
        for(String demand : listOfDemand){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(comments);
            req.setObjectId(demand);
            requests.add(req);
            //  Approval.ProcessResult processResult = Approval.process(req);
        }
        String returnMessage = '';
        try {
            processResults = Approval.process(requests, true);
            returnMessage = 'Success';
        }
        catch (System.DmlException e) {
            System.debug('Exception Is ' + e.getMessage());
            returnMessage = e.getMessage();
        }
        
        return returnMessage;
    }
    
    /**
     * Method is getting called when Searched for Case Number
     * / 
    @AuraEnabled(Cacheable = true)
    public static list<Case> retriveCases(String strcasenumber) {
        string  caseNumber = '%' + strcasenumber + '%';
        String colms = '';
        
        colms = returnCSVForFields(); //get dynamic columns from custom setting
        
        String query = 'SELECT ' +colms ; 
        query +=' FROM Case WHERE CaseNumber LIKE \''+caseNumber + '\'';
        list<Case> listOfCases = Database.query(query);
        if(listOfCases.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        system.debug('listOfCases');
        return listOfCases; 
    }

    /**
     *  Added this method on 15 March 2023 as part of ne filter criteria...
	* /
    @AuraEnabled(cacheable=true)
    public static list<case> filteredCases(String solIdentifier, String deliveryHead) {
        
        List<Case> listofCases = new List<Case>();
        String solutionId = '%' + solIdentifier + '%';
        String ibmDeliveryHead = '%' + deliveryHead + '%';
        String loggedInUserName = userinfo.getName();
        String colms = '';
        
        colms = returnCSVForFields();

        try {
            system.debug('logged in username--> '+loggedInUserName);
            saveValuesToSettings(solIdentifier,deliveryHead,loggedInUserName);
            system.debug('colms : '+colms);
            //SELECT CaseNumber,final_demand_status__c,fp_project_name__c,ibm_delivery_lead__c FROM Case 
            String query = 'SELECT ' +colms ; //fp_project_name__c, IBM_Delivery_Lead__c, Final_Demand_Status__c 
                query +=' FROM Case '; // where psl_roles__r.name !=null ';
                
            if(!String.isBlank(solIdentifier) && !String.isBlank(deliveryHead)){
                query += ' WHERE IBM_Delivery_Lead__r.Name LIKE  \''+ibmDeliveryHead + '\'' +
                ' AND Solution_identifier__c LIKE \''+solutionId + '\'';
            }
            else if(!String.isBlank(solIdentifier) && String.isBlank(deliveryHead)){
            	query += ' WHERE Solution_identifier__c LIKE  \''+solutionId + '\'';
            }
            else if(String.isBlank(solIdentifier) && !String.isBlank(deliveryHead)){
                query += ' WHERE IBM_Delivery_Lead__r.Name LIKE  \''+ibmDeliveryHead + '\'';
            } 

            system.debug('query : '+query);
            
            listOfCases = Database.query(query);
            
            system.debug('listOfCases  : '+listOfCases);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        system.debug('listOfCases  : '+listOfCases);
        return listOfCases; 
    }

    @future
    public static void saveValuesToSettings(String solId, String delLead,String usrName){
        DTM_CustomListFilterSetting__c obj = DTM_CustomListFilterSetting__c.getInstance(usrName);
        if(delLead != null || delLead !=''){
            obj.IBM_Delivery_Lead__c = delLead;
        }else{
            obj.IBM_Delivery_Lead__c = '';
        }
        if(solId != null || solId !=''){
            obj.Solution_Identifier__c = solId;
        }else{
            obj.Solution_Identifier__c = '';
        }
        update obj;
    }
    
	//Added on 16 March
    @AuraEnabled(Cacheable=true)
    public static Map<String,String> searchValuesResult(){
        Map<String,String> filterValMap = new Map<String,String>();
        String usrName = userinfo.getName();
        DTM_CustomListFilterSetting__c obj = DTM_CustomListFilterSetting__c.getInstance(usrName);
        if(obj.IBM_Delivery_Lead__c != null || obj.IBM_Delivery_Lead__c != ''){
            filterValMap.put('Delivery Lead',obj.IBM_Delivery_Lead__c);
        }
        else{
            filterValMap.put('Delivery Lead','');
        }
        if(obj.Solution_Identifier__c != null || obj.Solution_Identifier__c != ''){
            filterValMap.put('Solution Identifier',obj.Solution_Identifier__c);
        }
        else{
            filterValMap.put('Solution Identifier','');
        }
        
        system.debug('filterValMap : '+filterValMap);
        
        return filterValMap;
    }
    
    
    public static Map<String,Map<String,String>> getColumnsMap() {
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        
        DMT_SolutioningListViewCoulmns__c sls = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        system.debug('sls : '+sls.ColumnNames__c);
        columnCSV = sls.ColumnNames__c;
        List<String> selectedClmsList = new List<String>();
        selectedClmsList = sls.ColumnNames__c.split(',');
        
        for (SObjectField fieldName: mfields.values()) {
            
            String fieldAPI = String.valueOf(fieldName);
            //system.debug('fieldAPI :' + fieldAPI);
            String fieldlabel = fieldName.getDescribe().getLabel();
            
            if (selectedClmsList.contains(fieldlabel)) { 
                
                Schema.DisplayType FldType = fieldName.getDescribe().getType();
                String fieldType = string.valueOf(FldType);
                
                Map<String,String> innerColumnMap = new Map<String,String>();
                innerColumnMap.put('label',fieldlabel);
                innerColumnMap.put('fieldName',fieldAPI);
                innerColumnMap.put('fieldType',fieldType);
                columnsMap.put(fieldlabel, innerColumnMap);
            }
        }
        
        system.debug('columnsMap----> '+columnsMap);
        
        return columnsMap;
    }
    
    
    // Generic function to return columns
    public static String returnCSVForFields(){
        
        SObjectType caseType = Schema.getGlobalDescribe().get('Case');
        Map<String,Schema.SObjectField> mfields = caseType.getDescribe().fields.getMap();
        Map<String,Map<String,String>> columnsMap = new Map<String,Map<String,String>>();
        Map<String,String> fieldMap = new Map<String,String>();
        String colms = '';
        
        //for (String fieldName: mfields.keySet()) {
        for (SObjectField fieldName: mfields.values()) {
            
            String fieldAPI = String.valueOf(fieldName);
            //system.debug('fieldAPI :' + fieldAPI);
            String fieldlabel = fieldName.getDescribe().getLabel();
          
            Schema.DisplayType FldType = fieldName.getDescribe().getType();
            String fieldType = string.valueOf(FldType);
            
            fieldMap.put(fieldlabel, fieldAPI );
            Map<String,String> innerColumnMap = new Map<String,String>();
            innerColumnMap.put('label',fieldlabel);
            innerColumnMap.put('fieldName',fieldAPI);
            innerColumnMap.put('fieldType',fieldType);
            columnsMap.put(fieldlabel, innerColumnMap);
        }
        
       	system.debug('columnsMap----> '+columnsMap);
        system.debug('fieldMap : '+fieldMap);
                     
        List<string> colList = new List<string>();
        DMT_SolutioningListViewCoulmns__c sls = DMT_SolutioningListViewCoulmns__c.getValues('columns');
        List<String> columnsSet = new List<String>();
        columnsSet = sls.ColumnNames__c.split(',');
        system.debug('columnsSet :'+columnsSet);
        if (!columnsSet.isEmpty()){
            for (String fieldLabel : columnsSet) {
                if(fieldMap.containsKey(fieldLabel)){
                    if(columnsMap.get(fieldLabel).get('fieldType')!='REFERENCE'){
                        colList.add(fieldMap.get(fieldLabel));
                    }
                    //}
                    //TBD
                    if(columnsMap.get(fieldLabel).get('fieldType')=='REFERENCE'){
                        String s1 = fieldMap.get(fieldLabel);
                        system.debug('s1 in first---> '+s1);
                        if(s1.contains('__c')){
                            String s2 = s1.substringBefore('__');
                            String finalAPIName = s2+'__r.Name';
                            system.debug('fieldLabel---> '+fieldLabel);
                            system.debug('columnsMap.get(fieldLabel)----> '+columnsMap.get(fieldLabel));
                            system.debug('finalAPIName----> '+finalAPIName);
                            colList.add(finalAPIName); 
                        }else{
                            colList.add(fieldMap.get(fieldLabel));
                        }
                    }
                }
            }
        }
        system.debug('colList : '+colList);
        colms = String.join(colList,',');
        system.debug('colms of api names : '+colms);
        
        return colms;
    }

}


LWC HTML 

<template>



	<lightning-card icon-name="standard:case" title="Demand Masters">

		<template if:true={isLoading}>
			<lightning-spinner alternative-text="Loading" variant="brand" size="large">
			</lightning-spinner>
		</template>

		<lightning-button label="New" slot="actions" class="slds-m-left_x-small" title="Non-primary action"
			onclick={handleCreateNew} variant="brand-outline">
		</lightning-button>
		<lightning-button label="Total Daily Deliver GP" slot="actions" class="slds-m-left_x-small"
			title="Non-primary action" onclick={calculateTotalDailyDelGP} variant="brand-outline">
		</lightning-button>
		<lightning-button label="Submit for Approval" slot="actions" class="slds-m-left_x-small" variant="brand-outline"
			onclick={openModal}>
		</lightning-button>



		<div class="slds-grid  slds-form-element slds-form-element_horizontal">

			<div class="slds-col slds-size_4-of-8">
				<div><span class="countSortedByFilteredBy" aria-live="polite" role="status" aria-label="All">
			• {recSize} item(s) • Filtered by - IBM Delivery Lead : <b>{ibmDeliveryLeadUI}</b>, Solution Identifier :<b> {solIdentifierUI}</b> </span>
				</div>
			</div>
			<div class="slds-col slds-size_4-of-8">
				<div class="filterClass">
					<lightning-input type="search" value={searchKey} class="slds-m-left_x-small search-case"
						onchange={handleSearch} placeholder="Search Case Number">
					</lightning-input><br>

					<lightning-button-icon icon-name="utility:filterList" variant="border-filled"
						alternative-text="Add Filter" class="slds-m-left_xx-small" title="Add Filter"
						onclick={onClickFilter}>
					</lightning-button-icon>

					<lightning-button-icon icon-name="utility:filter" variant="border-filled"
						alternative-text="Add/Remove Columns" class="slds-m-left_xx-small" title="Add/Remove Columns"
						onclick={onClickOpenColumnFilter}>
					</lightning-button-icon>

				</div>
			</div>
		</div>

		<!-- <p> Selected Values: {fieldValue}</p> -->

		<div class="myTable" style="height: 450px;">
			<lightning-datatable class="slds-table_header-fixed_container slds-scrollable_x slds-border_top "
				key-field="id" data={records} show-row-number-column row-number-offset={rowOffset}
				onrowselection={getSelectedRecord} sorted-by={sortBy} sorted-direction={sortDirection}
				onsort={doSorting} columns={columns} onsave={handleSave} draft-values={draftValues}
				onrowaction={handleRowAction}>

			</lightning-datatable>
		</div>


		<!-- Modal popup for displaying Filter -->
		<template if:true={isFilterOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container filter-modal">

					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
							<lightning-icon icon-name="utility:close"
								alternative-text="close"
								variant="inverse"
								size="small" ></lightning-icon>
							<span class="slds-assistive-text">Close</span>
            			</button>
						<h2 id="filter-heading-01" class="slds-text-heading_medium slds-hyphenate">
							Filters
						</h2>
					</header>


					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium slds-grid  slds-grid_vertical"
						id="filter-content-id-1">

						<div class="slds-col">
							<lightning-input type="text" value={solIdentifierModalVar}
								class="slds-m-left_x-small sol-Identifier2" onchange={handleInputSolId}
								placeholder="Enter Solution Identifier" label="Solution Identifier">
							</lightning-input><br>
						</div>
							<div class="slds-col">
								<lightning-input type="text" value={ibmDeliveryLeadModalVar}
									class="slds-m-left_x-small delivery-Lead2" onchange={handleInputIBMDelLead}
									placeholder="Enter IBM Delivery Lead" label="IBM Delivery Lead">
								</lightning-input><br>
						</div>

								<div class="slds-col">
									<lightning-button label="Apply Filter" slot="actions"
										class="slds-m-left_x-small search-btn2" variant="brand-outline"
										onclick={onBeforeClickSearch}>
									</lightning-button>

									<lightning-button label="Clear Filter" slot="actions"
										class="slds-m-left_x-small search-btn2" variant="brand-outline"
										onclick={onClearFilterClick}>
									</lightning-button>
								</div>
							</div>

							<!-- Modal/Popup Box LWC footer starts here -->
							<footer class="slds-modal__footer">
								<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
							</footer>

						</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>


		<!-- Modal popup for displaying Total Daily Deliver GP -->
		<template if:true={isGPModalOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container">

					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
							<lightning-icon icon-name="utility:close"
								alternative-text="close"
								variant="inverse"
								size="small" ></lightning-icon>
							<span class="slds-assistive-text">Close</span>
            			</button>
						<h2 id="GPmodal-heading-01" class="slds-text-heading_medium slds-hyphenate">Total Daily Deliver
							GP
						</h2>
					</header>

					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium" id="GPmodal-content-id-1">
						<p><b>
							{message}
						</b></p>
					</div>

					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
					</footer>

				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>


		<!-- Modal popup to Submit for Approval -->
		<template if:true={isModalOpen}>
			<!-- Modal/Popup Box LWC starts here -->
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true"
				aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container">
					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
                <lightning-icon icon-name="utility:close"
                    alternative-text="close"
                    variant="inverse"
                    size="small" ></lightning-icon>
                <span class="slds-assistive-text">Close</span>
            </button>
						<h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Submit for Approval
						</h2>
					</header>
					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium" id="modal-content-id-1">
						<p><b>
                <lightning-textarea class="slds-p-top_small" data-id="commentsData" label="Comments" ></lightning-textarea>
            </b></p>
					</div>
					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
						<button class="slds-button slds-button_brand" onclick={submitDetails} title="Submit">Submit</button>
					</footer>
				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>


		<!-- Modal/Popup for List View Coulmn Selection  -->
		<template if:true={isColumnFilterOpen}>
			<section role="dialog" tabindex="-1" aria-labelledby="modal-heading-04" aria-modal="true"
				aria-describedby="modal-content-id-4" class="slds-modal slds-fade-in-open">
				<div class="slds-modal__container dynamic-filter-modal">

					<!-- Modal/Popup Box LWC header here -->
					<header class="slds-modal__header">
						<button class="slds-button slds-button_icon slds-modal__close slds-button_icon-inverse" title="Close" onclick={closeModal}>
							<lightning-icon icon-name="utility:close"
								alternative-text="close"
								variant="inverse"
								size="small" ></lightning-icon>
							<span class="slds-assistive-text">Close</span>
            			</button>
						<h2 id="filter-heading-04" class="slds-text-heading_medium slds-hyphenate">
							Select Columns
						</h2>
					</header>


					<!-- Modal/Popup Box LWC body starts here -->
					<div class="slds-modal__content slds-p-around_medium slds-grid  slds-grid_vertical"
						id="filter-content-id-4">
						<!-- onmultipicklistgenericevent={multipicklistgenericevent}  -->
						<c-multi-pick-list-generic-component received-pick-list-values={pickListValues}
							onsaveevent={onsavefromchild} selected-values={fieldValue}
							field-api-name="Company_Category__c">
						</c-multi-pick-list-generic-component>
					</div>


					<!-- Modal/Popup Box LWC footer starts here -->
					<footer class="slds-modal__footer">
						<button class="slds-button slds-button_neutral" onclick={closeModal} title="Cancel">Cancel</button>
					</footer>

				</div>
			</section>
			<div class="slds-backdrop slds-backdrop_open"></div>
		</template>




	</lightning-card>
</template>


JS 


import { LightningElement, api, wire, track } from 'lwc';

import updateTotalGroupValue from '@salesforce/apex/CustomListViewController.updateTotalGroupValue';
import submitForApproval from '@salesforce/apex/CustomListViewController.submitForApproval';
import updateDemands from '@salesforce/apex/CustomListViewController.updateDemands';
import retriveCases from '@salesforce/apex/CustomListViewController.retriveCases';
//import filteredCasesResult from '@salesforce/apex/CustomListViewController.filteredCases';
import fetchFilterMap from '@salesforce/apex/CustomListViewController.searchValuesResult';
import returnAllCaseFields from '@salesforce/apex/CustomListViewController.returnColumns';
import returnSelectedColumns from '@salesforce/apex/CustomListViewController.returnSelectedColumns'
import updateColumns from '@salesforce/apex/CustomListViewController.updateColumnSelection'
import CASE_OBJECT from '@salesforce/schema/Case';

import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'View', name: 'view' },
    { label: 'Edit', name: 'edit' },
    { label: 'Clone', name: 'clone' }
];



export default class CustomListViewPage extends NavigationMixin(LightningElement)
{

    @track isLoading = true;
    isModalOpen = false;
    isGPModalOpen = false;
    isFilterOpen = false;
    isColumnFilterOpen = false;
    error;

    @track columns = [

    ];

    @track columnAction = [{ type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' } }];

    rowOffset = 0;
    totalDailyDeliveryGP = 0;
    selectedRows = [];
    message = 'Total Daily Delivery GP : '
    draftValues = [];

    @track records = [];

    mapData = [];
    wiredRecords;
    @track sortBy;
    @track sortDirection;
    @track ibmDeliveryLead = '';
    @track solIdentifier = '';
    @track ibmDeliveryLeadUI = '';
    @track solIdentifierUI = '';
    @track ibmDeliveryLeadModalVar = '';
    @track solIdentifierModalVar = '';
    @track recSize;
    @track htm = '<input type="text" placeholder="Your state" class="data-input"/>';
    @track multiselectAllValues = [
        {
            label: 'None',
            value: 'None'
        },
    ];
    @track finalLabel = [];
    @track finalChoosenVal = [];
    finalApiNamesList = [];
    finalApiCSV = ''; // it contains final CSV for api names of selected columns to display

    @track DataTableResponseWrappper;
    @track finalSObjectDataList;
    @track fieldValue = ''; //Case Number,Final Demand Status,FP Project Name,IBM Delivery Lead';

    get pickListValues() {
        console.log('Inside get picklist values---> ', JSON.parse(JSON.stringify(this.multiselectAllValues)));
        this.finalLabel = JSON.parse(JSON.stringify(this.multiselectAllValues));
        return this.finalLabel;
    }

    connectedCallback() {
        //this.isLoading = true;

        console.log('m in parent connected callback method');
        this.getCaseFields();       // TOTAL SCHEMA OF CASE OHJECT
        this.checkLeadAndSolIdValue();
    }

    handleCreateNew() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'new',
            },
            state: {
                nooverride: '1',
            }
        });
    }

    renderedCallback() {
        console.log('Inside rendered callback!!!!' + this.fieldValue);
    }


    returnSelectedColumns() {
        this.isLoading = true;
        console.log('Inside return selected colums!!!!!'+this.isLoading)
        // close the filter window
        this.isFilterOpen = false;
        this.columns = [];

        returnSelectedColumns({ solIdentifier: this.solIdentifier, deliveryHead: this.ibmDeliveryLead })
            .then(data => {
                if (data) {
                    //let sObjectRelatedFieldListValues = [];

                    this.DataTableResponseWrappper = data;
                    this.columns = [...this.columns, ...data.lstDataTableColumns, ...this.columnAction];
                    let colms = ''
                    console.log('data.lstDataTableColumns : ' + JSON.stringify(data.lstDataTableColumns));
                    //console.log('data.lstDataTableData : '+JSON.stringify(data.lstDataTableData));

                    for (let row of data.lstDataTableColumns) {
                        colms = colms + ',' + row.label;
                    }

                    this.fieldValue = colms.substring(1);
                    //sObjectRelatedFieldListValues = this.returnRows(data.lstDataTableData);
                    this.records = this.returnRows(data.lstDataTableData); //sObjectRelatedFieldListValues;
                    this.recSize = this.records.length;
                    this.isLoading = false;
                }
                else if (error) {
                    this.error = error;
                    console.log('Error ==> ' + this.error);
                    this.isLoading = false;
                }
            })
    }

    returnRows(lstDataTableData1) {

        let sObjectRows = [];

        for (let row of lstDataTableData1) {
            const finalSobjectRow = {}
            let rowIndexes = Object.keys(row);
            rowIndexes.forEach((rowIndex) => {
                const relatedFieldValue = row[rowIndex];
                if (relatedFieldValue.constructor === Object) {
                    this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)
                }
                else {
                    finalSobjectRow[rowIndex] = relatedFieldValue;
                }
            });
            sObjectRows.push(finalSobjectRow);
        }

        //console.log('sObjectRows : ' + JSON.stringify(sObjectRows));
        return sObjectRows;

    }

    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => {
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => {
            let finalKey = fieldName + '.' + key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }

    //Added on 15 march 2023
    onClickSearch() {
        
        this.returnSelectedColumns();
        return;
    }

    @wire(fetchFilterMap)
    wireMapData({ error, data }) {

        this.isLoading = true;
        console.log('this.isLoading - at the start of wire : '+this.isLoading);
        console.log('m in parent wire method');

        if (data) {
            console.log(data);
            var conts = data;
            for (var key in conts) {
                this.mapData.push({ value: conts[key], key: key });

                if (key == 'Delivery Lead') {
                    if (conts['Delivery Lead'] !== '' || conts['Delivery Lead'] !== null) {
                        this.ibmDeliveryLead = conts['Delivery Lead'];
                        console.log('this.ibmDeliveryLead wired--> ', this.ibmDeliveryLead);
                    } else {
                        this.ibmDeliveryLead = '';
                    }
                }
                if (key == 'Solution Identifier') {
                    if (conts['Solution Identifier'] !== '' || conts['Solution Identifier'] !== null) {
                        this.solIdentifier = conts['Solution Identifier'];
                        console.log('this.solIdentifier wired--> ', this.solIdentifier);
                    } else {
                        this.solIdentifier = '';
                    }
                }
            }
            this.returnSelectedColumns();
        } else if (error) {
            this.error = error;
        }

        this.isLoading = false;
        console.log('this.isLoading  - at the end of wire : '+this.isLoading);
    }


    getCaseFields() {

        const labelToAPINames = new Map();

        console.log('I am inside getCaseFields ');

        returnAllCaseFields()
            .then(response => {

                try {
                    console.log('I am inside response : ', response);
                    let caseAllFieldNames = [];

                    for (let key in response) {
                        let value = response[key];
                        caseAllFieldNames.push({ label: `${value}`, value: `${key}` });

                        //console.log('key : ', key);
                        //console.log('value : ', value);
                        labelToAPINames.set(key, value);
                        //console.log('this.labelToAPINames : ' + JSON.stringify(labelToAPINames));
                    }

                    this.multiselectAllValues = caseAllFieldNames;
                    //console.log('this.labelToAPINames : ' + JSON.stringify(labelToAPINames));
                }
                catch (err) {
                    console.log('err : ' + err);
                }
            })
    }


    onsavefromchild(event) {
        console.log('Inside parent post save from child!!!!')
        let val = event.detail.value;
        this.fieldValue = event.detail.selectedvalues;
        console.log('event val from child----> ', val);
        console.log('event val from child of field names----> ', this.fieldValue);

        let labelToAPINames = new Map();
        let returnStr = '';

        try {
            if (this.fieldValue !== undefined) {

                this.multiselectAllValues.forEach(allValues => {
                    //console.log('allValues : ' + JSON.stringify(allValues));

                    this.fieldValue.forEach(eachPicklistValue => {
                        console.log('eachPicklistValue : ' + JSON.stringify(eachPicklistValue));

                        if (eachPicklistValue === allValues.value) {
                            returnStr = returnStr + ',' + allValues.label;
                            console.log('returnStr ----> ', returnStr);
                        }
                    })
                })
                returnStr = returnStr.substring(1);
                console.log('returnStr Final : ' + returnStr);
                //Band,PSL Roles
            }
            else {
                returnStr = '';
            }
        }
        catch (err) {
            console.log('Error => ' + err);
        }
        console.log('returnStr Final : ' + returnStr);

        this.fieldValue = returnStr;

        updateColumns({ columnString1: returnStr })
            .then(
                response => {
                    if (response) {
                        console.log('Custon setting update successfully...');
                    }
                }
            )
            .catch(error => {
                console.log('Custon setting update error...' + JSON.stringify(error));
            });

        this.returnSelectedColumns();
        window.location.reload();

    }

    multipicklistgenericevent(event) {
        let myObj = {};
        this.fieldValue = event.detail.value;

        console.log('in multipicklistgenericevent : this.fieldValue : ' + this.fieldValue);

        //below part  - Aakash on 06 April
        if (this.fieldValue.length >= 1) {
            for (let val in this.fieldValue) { // this will be used to check the api names against the field names coming from multiselect picklist
                let newVal = this.fieldValue[val];
                const filtered = this.finalLabel.find((obj) => {
                    return (obj.value === newVal);
                });
                this.finalChoosenVal.push(filtered);
                console.log('filtered---> ', JSON.stringify(filtered));
            }
            console.log('this.finalChoosenVal----> ', JSON.parse(JSON.stringify(this.finalChoosenVal)));

            myObj = JSON.parse(JSON.stringify(this.finalChoosenVal));

            for (let keys in myObj) {
                console.log('all val---> ', myObj[keys]['label']);
                this.finalApiNamesList.push(myObj[keys]['label']); // will push all api names of selected field in this array.
            }
            this.finalApiNamesList = this.removeDuplicates(this.finalApiNamesList); //remove duplicates from array

            console.log('this.finalApiNamesList ----> ', this.finalApiNamesList);

            this.finalApiCSV = this.finalApiNamesList.toString();
            console.log('this.finalApiCSV----> ', this.finalApiCSV); //String to get CSV values from array.
        }
    }

    // function to remove duplicates from array - Aakash
    removeDuplicates(arr) {
        var unique = arr.reduce(function (acc, curr) {
            if (!acc.includes(curr))
                acc.push(curr);
            return acc;
        }, []);
        return unique;
    }

    onClickAddFilter() {
        this.template.querySelector('.newFilter').innerHTML = this.htm;
    }


    getSelectedRecord(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedRows = selectedRows;
        console.log('You selected: ', selectedRows);
    }

    calculateTotalDailyDelGP() {
        console.log('You selected: 2', this.selectedRows);
        let calculateTotalGP = true;
        let solutionIdentifier = '';
        this.message = 'Total Daily Delivery GP : ';
        if (!!this.selectedRows[0].Solution_identifier__c === true) {
            solutionIdentifier = this.selectedRows[0].Solution_identifier__c;
        }
        console.log('solutionIdentifier-->', solutionIdentifier);
        try {
        if (this.selectedRows.length > 1) {
            this.totalDailyDeliveryGP = 0;
            for (let i = 0; i < this.selectedRows.length; i++) {
                if (this.selectedRows[i].Solution_identifier__c !== solutionIdentifier) {
                    calculateTotalGP = false;
                }
            }
            if (calculateTotalGP) {
                for (let i = 0; i < this.selectedRows.length; i++) {
                    if (!!this.selectedRows[i].Daily_Delivery_GP__c === true) {
                        this.totalDailyDeliveryGP = parseFloat(this.totalDailyDeliveryGP) + parseFloat(this.selectedRows[i].Daily_Delivery_GP__c);
                    }
                }
                console.log('this.totalDailyDeliveryGP : '+this.totalDailyDeliveryGP);
                this.message = this.message + this.totalDailyDeliveryGP;
                console.log('this.message : '+this.message);

                updateTotalGroupValue({ listOfDemands: JSON.stringify(this.selectedRows), totalGPValue: this.totalDailyDeliveryGP })
                    .then(result => {
                        console.log('result-->', result);
                        this.isGPModalOpen = true;
                    })
                    .catch(error => {
                        console.log('error --->', error);
                        this.isGPModalOpen = true;
                        this.error = error;
                        this.message = this.error;
                    });
            } else {
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: 'Solution identifier mismatch',
                    variant: 'error'
                });
                this.dispatchEvent(event);
            }
        }
        console.log('total--->', this.totalDailyDeliveryGP);
        }
        catch (Error){
            console.log('Error --->', Error);
        }
    }

    onClickFilter() {
        this.isFilterOpen = true;
        this.solIdentifierModalVar = this.solIdentifier;
        this.ibmDeliveryLeadModalVar = this.ibmDeliveryLead;
    }

    checkLeadAndSolIdValue(){
        if(this.solIdentifier !== ""){
            this.solIdentifierUI = this.solIdentifier;
            console.log('Inside if solIdentifier present----> ',this.solIdentifier);
            console.log('Inside if solIdentifier present----> ',typeof this.solIdentifier);
        }else{
            this.solIdentifierUI = 'None';
            console.log('Inside if solIdentifier not present----> ',this.solIdentifierUI);
        } 
        if(this.ibmDeliveryLead !== ""){
            this.ibmDeliveryLeadUI = this.ibmDeliveryLead;
            console.log('Inside if delivery Lead present----> ',this.ibmDeliveryLeadUI);
        }else{
            this.ibmDeliveryLeadUI = 'None';
            console.log('Inside if delivery Lead not present----> ',this.ibmDeliveryLeadUI);
        } 
    }

    onClickOpenColumnFilter() {
        this.isColumnFilterOpen = true;
        console.log('this.isColumnFilterOpen : ', this.isColumnFilterOpen);
    }


    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
        this.isGPModalOpen = false;
        this.isFilterOpen = false;
        this.solIdentifierModalVar = this.solIdentifier;
        this.ibmDeliveryLeadModalVar = this.ibmDeliveryLead;

        this.isColumnFilterOpen = false;

    }
    submitDetails() {
        console.log('You selected', this.selectedRows);
        let textarea = this.template.querySelector("lightning-textarea[data-id]").value;
        this.isModalOpen = false;
        var listOfDemand = [];

        for (let i = 0; i < this.selectedRows.length; i++) {
            listOfDemand.push(this.selectedRows[i].Id);
        }
        console.log('listOfDemand---->' + listOfDemand);

        submitForApproval({ comments: textarea, listOfDemand: listOfDemand })
        .then(result => {
            console.log('Apex submit result:' + JSON.stringify(result));
            if (result === "Success") {
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Successfully submitted for Approval',
                        variant: 'success'
                    })
                );

            }
            else {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error in submitting for approval',
                        message: JSON.stringify(result),
                        variant: 'error'
                    })
                );
            }
        })
        .catch(error => {
            console.log('Error is' + JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error in submitting for approval',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
        })
        

    }


    async handleSave(event) {
        const updatedFields = event.detail.draftValues;

        await updateDemands({ data: updatedFields })
            .then(result => {

                console.log(JSON.stringify('Apex update result:' + result));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Demand updated',
                        variant: 'success'
                    })
                );

                refreshApex(this.wiredRecords).then(() => {
                    this.draftValues = [];
                });
            }).catch(error => {

                console.log('Error is' + JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating or refreshing records',
                        message: error.body.message,
                        variant: 'error'
                    })
                );

            });

    }
    searchKey;
    handleKeywordChange(event) {
        this.searchKey = event.target.value;
        console.log(this.searchKey);
    }

    handleSearch(event) {
        this.isLoading = true;
        console.log('this.isLoading  - at the start of handleSearch : '+this.isLoading);
        console.log(this.searchKey);
        this.searchKey = event.target.value;
        if (this.searchKey !== '' && this.searchKey !== undefined) {
            console.log('inside search');
            if (!this.searchKey) {
                this.errorMsg = 'Please enter Case Number to search.';
                this.searchData = undefined;
                return;
            }
            retriveCases({ strcasenumber: this.searchKey })
                .then(result => {
                    console.log('result handle search ', result);
                    this.records = this.returnRows(result);
                    this.recSize = this.records.length;
                })
                .catch(error => {
                    this.records = undefined;
                    window.console.log('error =====> ' + JSON.stringify(error));
                    if (error) {
                        this.errorMsg = error.body.message;
                    }
                })
        }
        else {
            console.log('inside else');

            this.onClickSearch();

        }
        this.isLoading = false;
        console.log('this.isLoading  - at the end of handleSearch : '+this.isLoading);
    }

    // to view, edit and clone the selected record in lightning data table
    handleRowAction(event) {
        console.log('view record 1 ', event.detail.action.name);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.recordId = row.id;
        console.log('row----> ', row.id, ' record id---> ', this.recordId);
        switch (actionName) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        actionName: 'view'
                    }
                });
                break;
            case 'clone':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        objectApiName: 'Account',
                        actionName: 'clone'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.id,
                        objectApiName: 'Account',
                        actionName: 'edit'
                    }
                });
                break;
        }
    }

    //Added on 15 march 2023
    handleInputSolId(event) {
        this.solIdentifierModalVar = event.target.value;
    }
    //Added on 15 march 2023
    handleInputIBMDelLead(event) {
        this.ibmDeliveryLeadModalVar = event.target.value
    }
    //Added on 21 March 2023 for solt filter cancel button.
    onBeforeClickSearch(event) {
        this.ibmDeliveryLead = this.ibmDeliveryLeadModalVar;
        this.solIdentifier = this.solIdentifierModalVar;
        this.onClickSearch();
        this.checkLeadAndSolIdValue();
    }
    //Added on 29 March 2023 - to clear all the filters 
    onClearFilterClick(event) {
        this.ibmDeliveryLeadModalVar = '';
        this.solIdentifierModalVar = '';
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.records));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.records = parseData;
    }
}


	CSS 

.wrapped-header-datatable .slds-table .slds-th__action .slds-truncate{
    max-width: 100%;
    overflow: hidden;
    text-overflow: unset;
    white-space: pre-line;
    
}

.wrapped-header-datatable .slds-table .slds-th__action {
    height: 5rem;
}

.wrapped-header-datatable .slds-table .slds-line-height_reset{
    height: 3rem;
}

.filterClass{
    display: flex;
    margin-left: 18rem;
    margin-right: 12px;
}
.sol-Identifier{
    position: relative;
    left: -4rem;
    width: 169%;
    margin-left: -10rem;
}
.delivery-Lead{
    position: relative;
    left: -7rem;
    width: 169%;
    margin-right: -5rem;
}
.search-btn{
    position: relative;
    left: -17px;
    width: 37%;
}

.search-case{
    position: relative;
    left: 0rem;
    width: 200%;
}

.filter-criteria{
    margin-right: 10px;
    border: 3px solid #2574A9;
    border-width: 1px;
    border-radius: .25rem;
    object-position: 50% 50%;
    padding-top: 4px;
    padding-right: 4px;
    padding-left: 4px;
}

.test-filter-button {
    padding-right: 1px;
    padding-left: 1px;
}

/* modal popup CSS * /
.filterClass1{
    display: flex;
}
.sol-Identifier1{
    position: relative;
    left: 6rem;
    width: 90%;
    margin-left: -13rem;
}
.delivery-Lead1{
    position: relative;
    left: 2.5rem;
    width: 90%;
    margin-left: -3rem;
}
.search-btn1{
    position: relative;
    left: 58px;
    width: 40%;
}
 


/* vertical allignment CSS * /
.sol-Identifier2{
    position: relative;
    left: 1rem;
    width: 100%;
    padding-right: 10rem;
}
.delivery-Lead2{
    position: relative;
    left: 1rem;
    width: 100%;
    padding-right: 10rem;
}
.search-btn2{
    position: relative;
    left: 1rem;
    width: 40%;
}
.filter-modal {
    width: 50%;
    max-width: 30rem;
    min-width: 20rem;
}
.addFilter{
    color:var(--lwc-colorTextLink,#2574A9);
    line-height: 3.5rem;
    margin-left: 1.5rem;
}

.dynamic-filter-modal{
    max-width: 45rem;
    min-width: 30rem;
}



CHILD 

<template>
  <div class="slds-box slds-col slds-scrollable" style="height: 18rem; padding: initial; background-color: white;">
    <ul role="menu" style="min-width: 65%; width: fit-content;">

      <lightning-dual-listbox name="columns"
                            label="Select Columns"
                            source-label="Available"
                            selected-label="Selected"
                            field-level-help="This is a dual listbox"
                            options={options}
                            value={values}
                            onchange={handleChange}>
        </lightning-dual-listbox>

    </ul>
  </div>
  <div><br/>
    <lightning-button label="Save" class="slds-m-left_x-small"
			title="Save" onclick={onSave} variant="brand-outline">
		</lightning-button>
  </div>
</template>


	CHILD JS 

import { LightningElement, api, track } from 'lwc';

export default class MultiPickListGenericComponent extends LightningElement {

    @api receivedPickListValues; //Picklist values sent by parent component
    @api selectedValues; //Values that has been selected
    @api fieldApiName; //API Name which makes component to be generic
    //@track pickListValues = [];

    selectedPickListValues = [];

    options = [];
    values = [];


    connectedCallback() {

        console.log('receivedPickListValues : ' + this.receivedPickListValues);
        console.log('selectedValues : ' + this.selectedValues);

        var localValues = [];

        var split_string = new Set(this.selectedValues.split(","));

        console.log('this.values 1 : ' + JSON.stringify(this.values));

        if (this.receivedPickListValues !== undefined) {
            this.receivedPickListValues.forEach(eachPicklistValue => {

                const items = [];
                items.push({
                    label: eachPicklistValue.label,
                    value: eachPicklistValue.value,
                });

                this.options.push(...items);

                if (split_string.has(eachPicklistValue.label)) {
                    localValues.push(eachPicklistValue.value);
                    console.log(localValues);
                }
            })
            this.values.push(...localValues);

            console.log('this.options : ' + JSON.stringify(this.options));
            console.log('this.values 2 : ' + JSON.stringify(this.values));
        }
    }

    onSave(event) {
        console.log('on click of save from child')
        const saveEvent = new CustomEvent("saveevent", {
            detail: { value: 'yes', selectedvalues: this.selectedPickListValues }
        });
        this.dispatchEvent(saveEvent);
    }

    handleChange(event) {
        // Get the list of the "value" attribute on all the selected options
        const newSelectedValues = event.detail.value;
        try {
            console.log('Options selected: ' + newSelectedValues);
            this.selectedPickListValues = event.detail.value;
            console.log('selectedPickListValues : ' + JSON.stringify(this.selectedPickListValues));
        }
        catch (err) {
            console.log(' Error : ' + err);
        }
    }

    renderedCallback() {
        console.log('I am in child rendered callback this.selectedValues : ' + this.selectedValues.length);
    }

}

	CHILD CSS

.dummy{
	color : black;
}









*/
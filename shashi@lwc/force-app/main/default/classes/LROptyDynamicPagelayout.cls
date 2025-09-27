public with sharing class LROptyDynamicPagelayout
{
    public List<LayoutSections> lstSections {get; set;} 
    public SObject sObjectRecord {get; set;}    
    public String strLayoutFields {get; set;} 
    public  Id strRecordId {get; set;}
    public String strSObject {get; set;} 
    public String strSObjectLabel {get; set;}  
    public Id recordTypeId {get; set;} 
    public Boolean showEditView{get; set;}
    private final Opportunity opty;
    public  string strRecordType{get;set;}
    public Static Boolean productCheck ;
    public Boolean checkRtSelected{get;set;} 
    public String selectedRecordType{get;set;} 
    public  List<LayoutFields> requiredField{get;set;} 
    public String copyStageName='';
    
    public LROptyDynamicPagelayout(ApexPages.StandardController controller){
        strSObject = 'Opportunity';
        system.debug('strSObject : '+strSObject);
        checkRtSelected=true;
        if(ApexPages.currentPage().getParameters().get('Id') != null && ApexPages.currentPage().getParameters().get('Id') !=''){
            showEditView= true;
            strRecordId = ApexPages.currentPage().getParameters().get('Id');
            system.debug('strRecordId : '+strRecordId);
            String strQuery = '';
            strQuery += 'SELECT Id, RecordTypeId,HasOpportunityLineItem FROM ' + strSObject + ' WHERE Id =: strRecordId'; 
            sObjectRecord = database.query(strQuery); 
            
            /*
            if(ApexPages.currentPage().getParameters().get('rt')!=null && ApexPages.currentPage().getParameters().get('rt') !=''){
                recordTypeId =  ApexPages.currentPage().getParameters().get('rt').escapeHtml4();            
            }else{
                recordTypeId = String.valueOf(sObjectRecord.get('RecordTypeId'));
            }
            selectedRecordType=[select Name from recordType where id=:recordTypeId].Name;            
            this.strRecordType=recordTypeId;                                    
            */
        }
        
        this.opty = (Opportunity)controller.getRecord();
    }
    
    public Pagereference cancelSave(){        
        return new Pagereference('/'+ApexPages.currentPage().getParameters().get('Id'));
    }
    /*
    @AuraEnabled
    public static String getApiCallUrl(String recordId){
        
        sObject sObjectRec = Database.query('SELECT Id, RecordTypeId,HasOpportunityLineItem,StageName FROM  opportunity WHERE Id = :recordId');        
        String returnVar='';
        Map<String,String> mapCnf=getTheConfigrationSetting();
        
        if (sObjectRec.get('HasOpportunityLineItem') == false) {                            
            returnVar = 'failure';      
        }
        else if(mapCnf!=null && sObjectRec.get('StageName')==mapCnf.get('StageName')){
            String profile=mapCnf.get('profile');
            String stageName=mapCnf.get('StageName');
            String defaultRT=mapCnf.get('defaultRT');
            
            returnVar='redirectToRt|'+profile+'|'+stageName+'|'+defaultRT;
        }else{
            returnVar= '/apex/LROpportunityCloneWithProduct?id='+recordId;
        }	
        
        return returnVar; 
        
    }
    
    
    @AuraEnabled
    public static list<Map<String,String>> getRecordTypesv2()
    {
        
        list<Map<String,String>> options = new list<Map<String,String>>();
        
        Schema.DescribeSObjectResult sdso = Opportunity.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> rtInfo = sdso.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rInfo : rtInfo){            
            if(rInfo.isAvailable() && !rInfo.isMaster()){
                Map<String,String> rtMap=new Map<String,String>();
                rtMap.put('label',rInfo.getName());
                rtMap.put('value',rInfo.getRecordTypeId()); 
                options.add(rtMap);
            }
            
        }                       
        return options;
    }
    
    public list<SelectOption> getRecordTypes()
    {
        
        list<SelectOption> options = new list<SelectOption>();        
        Schema.DescribeSObjectResult sdso = Opportunity.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> rtInfo = sdso.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rInfo : rtInfo)
        {            
            if(rInfo.isAvailable() && !rInfo.isMaster())
            {
                options.add(new SelectOption(rInfo.getRecordTypeId(), rInfo.getName()));
            }
            
        }                
        return options;
        
    }
    
    public PageReference updateRecordType()
    {
        opty.RecordTypeId = strRecordType;
        PageReference page = new PageReference('/apex/LROpportunityCloneWithProduct?id='+strRecordId+'&rt='+ strRecordType);
        page.setRedirect(true);
        return page;
    }
    
    
   
    
    
    
    
    
    public  String cloneProductOfClonedOpty (String cid,String oid){                
        Opportunity lineItem= [select HasOpportunityLineItem from opportunity where id=:oid];
        if (lineItem.HasOpportunityLineItem == true) {               
            String queryObj1 = getCreatableFieldsSOQL('OpportunityLineITem', 'OpportunityId =\'' + oid + '\'');
            String replaceQueryObj1= queryObj1.replace('TotalPrice,',''); //TotalPrice from String
            List<OpportunityLineItem> products = Database.query(replaceQueryObj1);
            
            List<OpportunityLineItem> newProdList = new List<OpportunityLineItem>();
            for (OpportunityLineItem prod:products) {
                OpportunityLineItem newProd = prod.clone(false, false, false, false);
                newProd.OpportunityId = cid;
                newProdList.add(newProd);
            }                       
            insert(newProdList);
            System.debug('copyStageName '+copyStageName);
            if(copyStageName!=''){
                Opportunity opty=new Opportunity(id=cid);
                opty.stageName=copyStageName;
                update opty;
            }
            
            return 'true';
        } else {
            return 'failure';
        }
        
    }
    
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){ selects = selects.substring(0,selects.lastIndexOf(',')); }
            
        }
        system.debug('-----'+selects);
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;        
    }
    
    public static Map<String,String> getTheConfigrationSetting(){
        String userProfileName = [select Name from profile where id =: userinfo.getProfileId()].Name;
        Map<String,String> cnfMap;
        Clone_With_Product__c cwp = Clone_With_Product__c.getValues(userProfileName);
        
        if(cwp != null){
            cnfMap=new Map<String,String>();
            cnfMap.put('profile', userProfileName);
            cnfMap.put('StageName',cwp.Stage_Name__c);
            cnfMap.put('defaultRT',cwp.Default_Record_Type__c);
            
        }                
        return cnfMap;
    }
    */
    
    public void showSelectedRecord() {        
        lstSections = (List<LayoutSections>)JSON.deserialize(strLayoutFields, List<LayoutSections>.class); 
        Schema.SObjectType token;
        if(strRecordId != null){
            token = strRecordId.getSObjectType();
        }
        
        
        Schema.DescribeSObjectResult dr = token.getDescribe(); 
        strSObject = dr.getName(); 
        strSObjectLabel = dr.getLabel(); 
        
        SObjectType sObjectType = Schema.getGlobalDescribe().get(strSObject); 
        
        String strQuery = 'SELECT '; 
        //system.debug('=======lstSections'+ lstSections);
        requiredField=new List<LayoutFields>();
        for(LayoutSections objL : lstSections) { 
            List<LayoutFields> lstFieldsTemp = new List<LayoutFields>(); 
            
            for(LayoutFields oField : objL.Fields) { 
                
                if(oField.Field != null && sObjectType.getDescribe().fields.getMap().containsKey(oField.Field)){ 
                    LayoutFields oLayoutFields = new LayoutFields(); 
                    oLayoutFields.Field = oField.Field; 
                    oLayoutFields.isUpdatable = 'true'; 
                    oLayoutFields.isRequired = oField.isRequired;
                    oLayoutFields.isrender = true; 
                    strQuery += oField.Field + ', ';                   
                    lstFieldsTemp.add(oLayoutFields);
                    if(oField.isRequired=='true'){
                        this.requiredField.add(oLayoutFields);
                    }                                        
                } 
            } 
            objL.Fields = lstFieldsTemp;             
        } 
        if(strRecordId != null){
            strQuery += 'Id FROM ' + strSObject + ' WHERE Id =: strRecordId';
            sObjectRecord = database.query(strQuery); 
            this.sObjectRecord.put('RecordTypeId',recordTypeId);
            
            system.debug('Query --> ' + strQuery);
            
        }
    }
    public PageReference createOpty(){
        String exp='';        
        try{                       
            System.debug('+++' + recordTypeId);            
            Opportunity optyNew = new Opportunity();
            optyNew = ((Opportunity)this.sObjectRecord).clone(false,false,false,false); 
            
			/*
            Map<String,String> mapCnf=getTheConfigrationSetting();            
            //String userProfileName = [select Name from profile where id =: userinfo.getProfileId()].Name;
            //if(userProfileName=='TC P2G Team' && optyNew.StageName =='Closed Won'){
            if(mapCnf!=null && optyNew.StageName==mapCnf.get('StageName')){
                copyStageName=optyNew.StageName;
                optyNew.StageName='Prospecting';
            }  
            insert optyNew;
            String oid= String.valueOf(this.sObjectRecord.get('Id'));
            //cloneProductOfClonedOpty(optyNew.Id,oid);
            */
           
            return new PageReference('/'+optyNew.Id);
        }catch(Exception e){
            exp=e.getMessage();
        }
        
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, exp));
        
        return null;
    }
    
    
    public class LayoutSections {
        public String header {get; set;} 
        public String columns {get; set;} 
        public List<LayoutFields> fields {get; set;} 
    } 
    
    public class LayoutFields {
        public String field {get; set;} 
        public String isUpdatable {get; set;} 
        public String isRequired {get; set;} 
        public boolean isRender {get; set;} 
    } 
}
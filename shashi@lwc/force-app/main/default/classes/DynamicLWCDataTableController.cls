public class DynamicLWCDataTableController {
    
    //@AuraEnabled(cacheable=true)
    public static DataTableResponse GetWrapperOfSObjectFieldColumnActionValues(Map<String,Map<String,String>> columnsMap,List<Case> cases )
    {
        List<DataTableColumns> lstDataColumns            = new List<DataTableColumns>();
        List<SObject> lstDataTableData                   = new List<SObject>();
        List<string> columnList                          = new List<string>();
        List<string> fieldAPINameList                    = new List<string>();
        Boolean editable 								 = true;
        
        for (String fieldName: columnsMap.keySet()) {
            
            columnList.add(fieldName);
            
            Map<String,String> innerMap = columnsMap.get(fieldName);
            system.debug('innerMap : '+innerMap);
            
            fieldAPINameList.add(innerMap.get('fieldName'));
            if(innerMap.get('fieldType') == 'REFERENCE'){
                editable = false;
                String s1 = innerMap.get('fieldName');
                system.debug('s1--------------> '+s1);
                String s2 = s1.substringBefore('__');
                String finalAPIName = s2+'__r.Name';
                system.debug('finalAPIName--- in dynamic lwc table---> '+finalAPIName);
                innerMap.put('fieldName',finalAPIName);
                DataTableColumns datacolumns = new DataTableColumns( fieldName.trim(), innerMap.get('fieldName').trim()
                                                                    , innerMap.get('fieldType'), editable, true);
                lstDataColumns.add(datacolumns);
            }
            if(innerMap.get('fieldType') != 'REFERENCE'){
                editable=true;
                DataTableColumns datacolumns = new DataTableColumns( fieldName.trim(), innerMap.get('fieldName').trim()
                                                                    , innerMap.get('fieldType'),editable, true); 
                lstDataColumns.add(datacolumns);
            }
            
            system.debug('lstDataColumns----> '+lstDataColumns);
        }
        
        for(Case c : cases)
        {
            lstDataTableData.add(c);
        }
        
        
        DataTableResponse finalWrapper   = new DataTableResponse();
        finalWrapper.TableTitle          = 'Dynamic Table - Demand Master';
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData    = lstDataTableData;
        return finalWrapper;
    }
    
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public boolean editable{get;set;}
        @AuraEnabled
        public boolean sortable{get;set;}
        
        public DataTableColumns(String label, String fieldName, String type, Boolean editable, Boolean isSortable)
        {
            this.label     = label;
            this.fieldName = fieldName;
            this.type      = type; 
            this.editable = editable;
            this.sortable = isSortable;
        }
    }
    
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<Case> lstDataTableData {get;set;}
        @AuraEnabled
        public String TableTitle {get;set;}       
        
    }
}

/*

public class DynamicLWCDataTableController {
    
    //@AuraEnabled(cacheable=true)
    public static DataTableResponse GetWrapperOfSObjectFieldColumnActionValues(Map<String,Map<String,String>> columnsMap,List<Case> cases )
    {
        List<DataTableColumns> lstDataColumns            = new List<DataTableColumns>();
        List<SObject> lstDataTableData                   = new List<SObject>();
        List<string> columnList                          = new List<string>();
        List<string> fieldAPINameList                    = new List<string>();
        Boolean editable 								 = true;
        
        for (String fieldName: columnsMap.keySet()) {
        
            columnList.add(fieldName);
            
            Map<String,String> innerMap = columnsMap.get(fieldName);
            system.debug('innerMap : '+innerMap);
            
            fieldAPINameList.add(innerMap.get('fieldName'));
            if(innerMap.get('fieldType') == 'REFERENCE'){
                editable = false;
                String s1 = innerMap.get('fieldName');
                if(s1.contains('__c')){
                    system.debug('s1--------------> '+s1);
                    String s2 = s1.substringBefore('__');
                    String finalAPIName = s2+'__r.Name';
                    system.debug('finalAPIName--- in dynamic lwc table---> '+finalAPIName);
                    innerMap.put('fieldName',finalAPIName); 
                    DataTableColumns datacolumns = new DataTableColumns( fieldName.trim(), innerMap.get('fieldName').trim()
                                                                        , innerMap.get('fieldType'), editable, true);
                    lstDataColumns.add(datacolumns);
                }else{
                    DataTableColumns datacolumns = new DataTableColumns( fieldName.trim(), innerMap.get('fieldName').trim()
                                                                        , innerMap.get('fieldType'),editable, true); 
                    lstDataColumns.add(datacolumns);
                }  
            }
            if(innerMap.get('fieldType') != 'REFERENCE'){
                editable=true;
                DataTableColumns datacolumns = new DataTableColumns( fieldName.trim(), innerMap.get('fieldName').trim()
                                                                    , innerMap.get('fieldType'),editable, true); 
                lstDataColumns.add(datacolumns);
            }
            
            system.debug('lstDataColumns----> '+lstDataColumns);
        }
                
        
        for(Case c : cases)
        {
            lstDataTableData.add(c);
        }
      
        
        DataTableResponse finalWrapper   = new DataTableResponse();
        finalWrapper.TableTitle          = 'Dynamic Table - Demand Master';
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData    = lstDataTableData;
        return finalWrapper;
    }
      
    public class DataTableColumns {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public boolean editable{get;set;}
        @AuraEnabled
        public boolean sortable{get;set;}
        
        public DataTableColumns(String label, String fieldName, String type, Boolean editable, Boolean isSortable)
        {
            this.label     = label;
            this.fieldName = fieldName;
            this.type      = type; 
            this.editable = editable;
            this.sortable = isSortable;
        }
    }
    
    public class DataTableResponse {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        //@AuraEnabled
        //public List<sObject> lstDataTableData {get;set;}
        @AuraEnabled
        public List<Case> lstDataTableData {get;set;}
        @AuraEnabled
        public String TableTitle {get;set;}       
		   
}
}


*/
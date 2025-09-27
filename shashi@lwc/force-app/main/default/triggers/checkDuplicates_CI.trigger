trigger checkDuplicates_CI on Financial_Information__c (before insert, before update) {
    
    Map<String, String> existing_data = new Map<String, String>();
    //Set<String> setAccName = new Set<String>();
    
    for ( Financial_Information__c ci : [select Company_Code__c, Team__C, Month__c FROM Financial_Information__c])
    {
        String uniq_str = ci.Company_Code__c + '_' + ci.Team__c + '_' + ci.Month__c;
        existing_data.put(uniq_str,ci.ID);
    }
    
    Integer size = existing_data.size();
    System.debug('Size : ' + size);
    
    for(Financial_Information__c ci_new : trigger.new) {
        
        String str = ci_new.Company_Code__c + '_' + ci_new.Team__c + '_' + ci_new.Month__c;
        if (existing_data.containsKey(str)) 
        {
            ci_new.addError(
                'There are already another records with the same data.' + 
                'Refer:< ' +  existing_data.get(str) + '>',
                FALSE );
        }
    }
}
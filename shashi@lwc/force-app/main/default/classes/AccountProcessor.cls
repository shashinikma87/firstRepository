global class AccountProcessor {

    @future 
    public static void countContacts (List<ID> act_ids){
        
        System.debug('Account ids : '+ act_ids);
        
		List<AggregateResult> acc = [select AccountId, count(ID) from Contact where AccountId IN: act_ids group by AccountId];
        
        System.debug('AggregateResult : '+ acc);
        
        List<Account> Act_List = new List<Account>();
        
        for (AggregateResult ar : acc) {
            
            //System.debug(ar.get('AccountId')+ ' => ' + ar.get('expr0'));
            Account a = new Account();
            a.id= String.valueOf(ar.get('AccountId'));
            a.Number_of_Contacts__c = Integer.valueOf(ar.get('expr0'));
            Act_List.add(a);
        }
        update Act_List;
    }
}
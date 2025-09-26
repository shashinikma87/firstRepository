global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {

    global Integer leads_updated = 0;
    global Database.QueryLocator start (Database.BatchableContext bc) {
        
        return Database.getQueryLocator( 'select id, LeadSource from Lead' );
    }
    
    global void execute (Database.BatchableContext bc, List<Lead> lead_list){
        
        for (Lead lead : lead_list){
            lead.LeadSource = 'Dreamforce';
            leads_updated++;
        }
        update lead_list;
    }
    
    global void finish(Database.BatchableContext bc){
		System.debug('Leads Updated : '+ leads_updated);
    }
}
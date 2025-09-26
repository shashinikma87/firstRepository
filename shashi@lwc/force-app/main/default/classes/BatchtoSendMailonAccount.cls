global class BatchtoSendMailonAccount implements Database.Batchable<sObject>, Database.allowsCallouts, Database.Stateful
{
	global Database.QueryLocator start (Database.BatchableContext bc){
        system.debug('I am in start ..');
        String query = 'SELECT ID, Name FRom Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        system.debug('I am in execute .. Account Name : '+scope[0].Name);
    }

    global void finish(Database.BatchableContext bc){
        
        system.debug('I am in Finish ..');
    }
}
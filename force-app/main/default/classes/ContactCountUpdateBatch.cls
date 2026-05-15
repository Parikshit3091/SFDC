global class ContactCountUpdateBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext ctx){
        String query = 'SELECT Id,Name FROM Account WHERE Contacts_Count__c = null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Account> accList){
        System.debug('accList size() ### ' + accList.size());
        Set<Id> accIds = new Set<Id>();
        for(Account acc : accList){
            accIds.add(acc.Id);
        }
        List<Account> accs = [SELECT Name,Contacts_Count__c,(select Id from contacts) FROM Account WHERE Id in :accIds];
        for(Account ac : accs){
            System.debug('ac.contacts ### ' + ac.contacts);
            ac.Contacts_Count__c = 0;
            if(ac.contacts != null && ac.contacts.size() > 0){
            	ac.Contacts_Count__c = ac.contacts.size();    
            }
            System.debug('ac.Contacts_Count__c ### ' + ac.Contacts_Count__c);
        }
        System.debug('aggregate query ### ' + Limits.getAggregateQueries());
        System.debug('aggregate query limits ### ' + Limits.getLimitAggregateQueries());
        update accs;
    }
    
    global void finish(Database.BatchableContext ctx){
        
    }
}
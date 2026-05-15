global class TimesheetBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext ctx){
        String query = 'select Id from Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Account> accLst){
        //Get all the contacts from account and then check all timesheets from contacts
        Set<Id> accId = new Set<Id>();
        for(Account ac : accLst){
            accId.add(ac.Id);
        }
        System.debug('accId ### ' + accId);
        List<Contact> ctLst = [select c.Id,c.Name,AccountId,(select Id from Timesheets__r) from Contact c where accountId in :accId];
        System.debug('ctLst ### ' + ctLst);
        for(Contact c : ctLst){
            System.debug('c ### ' + c);
            if(c.Timesheets__r != null && c.Timesheets__r.size() > 0){
                System.debug('Contact is ### ' + c.Name + ' Account is ### ' + c.AccountId);
            }
        }
    }
    
    global void finish(Database.BatchableContext ctx){
        
    }
}
global class AddMeetingBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext ctx){
        String accId = '0013k00002cBrmf';
      	String query = 'select Id from Account where Qualify_for_Business_Extension__c = false and id = \''+accId+'\'';
        return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ctx, List<Account> accLst){
        User usr = [Select Id,Name From User where Name like '%Parikshit%' ];
        Set<Id> accIds = new Set<Id>();
        for(Account acc : accLst){
            accIds.add(acc.Id);
        }
        
        List<Contact> contactsLst = [select Id,(select Id,createdDate from Events order by createdDate desc limit 1) from contact where accountID in :accIds];
        System.debug('contactsLst ### ' + contactsLst);
        for(Contact ct : contactsLst){
            System.debug('contact individual ### ' + ct);
            if(ct.Events != null && ct.Events.size() > 0){
                Event evt = ct.Events[0];
                if(evt.createdDate != System.today().toStartOfMonth()){
                    //Create event for all contacts and set eligible for Meeting true for account
                    Task tsk = new Task();
                    tsk.Subject = 'Follow up with Lead';
                    tsk.WhatId = [select Id from Opportunity where Account.Name = 'sForce' Limit 1].Id;
                    //This is the default...
                    tsk.OwnerId = UserInfo.getUserId();
                    tsk.Status = 'New';
                    tsk.Type = 'Call';
                    insert tsk;
                }
            }else{
                //Create event for all contacts and set eligible for Meeting true for account
                System.debug('inside new event creation');
                Task tsk = new Task();
                tsk.Subject = 'Follow up with Lead';
                tsk.WhatId = [select Id from Opportunity where Account.Name = 'sForce' Limit 1].Id;
                //This is the default...
                tsk.OwnerId = UserInfo.getUserId();
                tsk.Status = 'New';
                tsk.Type = 'Call';
                insert tsk;
            }
        }
    }
    
    global void finish(Database.BatchableContext ctx){
        
    }
}
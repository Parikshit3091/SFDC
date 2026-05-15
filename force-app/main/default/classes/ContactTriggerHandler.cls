public class ContactTriggerHandler {

    public static Map<Id,Account> accMap1 = new Map<Id,Account>();
    
    public static void updateCount(Map<Id, Account> accMap, List<Contact> listNew){
        Contact c = listNew[0];
        Boolean isTrue = false;
        if(true){
            //c.Qualify_for_Business_Extension__c = true;
        }
        Account acc = [select Id,Qualify_for_Business_Extension__c from Account where id = '0013k00002uZtyn'];
        acc.Qualify_for_Business_Extension__c = true;
        if(accMap1.containsKey(acc.Id)){
            accMap1.get(acc.Id).Qualify_for_Business_Extension__c = true;
        }else{
        	accMap1.put(acc.Id, acc);    
        }
        updateAccountName();
    }
    
    public static void updateAccountName(){
        Account acc = [select Id,Phone from Account where id = '0013k00002uZtyn'];
        acc.Phone = '12345';
        if(accMap1.containsKey(acc.Id)){
            accMap1.get(acc.Id).Phone = acc.Phone;
        }else{
        	accMap1.put(acc.Id, acc);    
        }
        
        updateAccount();
    }
    
    public static void updateAccount(){
        Database.update(accMap1.values(), false);
    }
}
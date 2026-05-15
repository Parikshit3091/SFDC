public with sharing class AuraSampleController{
     
    @AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> accList = new List<Account>();
        accList = [SELECT Id, Name, AccountNumber, Industry From Account LIMIT 10];
        return accList;
    }
}
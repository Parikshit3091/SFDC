public class AccountContactsList {

    @AuraEnabled
    public static List<Account> fetchAllAccounts(){ 
        String accQuery = 'SELECT Id';
        for(Schema.FieldSetMember fields : SObjectType.Account.FieldSets.Account_Details.getFields()){
            accQuery += ',' + fields.getFieldPath();
        }
        accQuery += ' FROM Account order by createdDate desc limit 100';
        System.debug('accQuery ### ' + accQuery);
        return Database.query(accQuery);
    }
    
    @AuraEnabled
    public static List<Contact> getContactList(String accountId){
        System.debug('accountId ### ' + accountId);
        List<Contact> contacts = [SELECT Id,Name,Email from Contact where account.id = :accountId];
        return contacts;
    }
}
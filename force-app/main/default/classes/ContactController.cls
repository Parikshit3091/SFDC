public with sharing class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactDetails(){
        return [select Id,Name,Email,AccountId,Account.Name from Contact order by createddate desc Limit 10];
    }
}
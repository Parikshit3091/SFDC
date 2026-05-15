@isTest
public class ContactCountUpdateBatchTest {

    @testSetup
    public static void init(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.AccountNumber = '12345';
        insert acc;
        
        Contact c1 = new Contact();
        c1.LastName = 'Test contact1';
        c1.AccountId = acc.Id;
        insert c1;
        
        Contact c2 = new Contact();
        c2.LastName = 'Test contact2';
        c2.AccountId = acc.Id;
        insert c2;
    }
    
    @isTest
    public static void testContactCount(){
        
        Test.startTest();
        Database.executeBatch(new ContactCountUpdateBatch());
        Test.stopTest();
        
        Account acc = [select Id,Contacts_Count__c from Account where name = 'Test Account'];
        System.debug('acc ### ' + acc);
        System.assertEquals(2, acc.Contacts_Count__c);
    }
}
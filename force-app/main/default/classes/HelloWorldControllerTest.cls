@isTest
public class HelloWorldControllerTest {

    @isTest
    public static void testMethod1(){
        Test.startTest();
		Account acc = new Account();
        acc.Name = 'Test';
        acc.Country__c = 'India';
        insert acc;
        
        String str = HelloWorldController.initAction();
        System.assertNotEquals(str, null);
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod2(){
        Test.startTest();
		Account acc = new Account();
        acc.Name = 'Test';
        acc.Country__c = 'US';
        insert acc;
        
        String str = HelloWorldController.initAction();
        System.assertEquals(str, null);
        Test.stopTest();
    }
}
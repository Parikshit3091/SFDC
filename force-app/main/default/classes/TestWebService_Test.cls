@isTest
public class TestWebService_Test {
	
    @isTest
    static void testGet(){
        
        Test.setMock(HttpCalloutMock.class, new MockCalloutTest());
        Test.startTest();
        TestWebService.fetchUserDetails();
        Test.stopTest();
    }
}
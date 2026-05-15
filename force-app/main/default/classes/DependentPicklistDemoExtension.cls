public class DependentPicklistDemoExtension {

    public Presentation__c acc{get;set;}
    
    public DependentPicklistDemoExtension() {
        acc = [select Id,Status__c,Type__c from Presentation__c where id = 'a013k00000cuFt2'];
    }
}
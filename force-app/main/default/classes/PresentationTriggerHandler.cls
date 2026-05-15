public class PresentationTriggerHandler {

    public static void handleBeforeUpdate(List<Presentation__c> oldList,List<Presentation__c> newList, Map<Id,Presentation__c> oldMap, Map<Id,Presentation__c> newMap){
        System.debug('newMap ### ' + newMap);
        if(Trigger.oldMap != null){
            String pId = newList[0].Id;
            System.debug('Trigger.oldMap ### ' + (oldMap.get(pId).Status__c));
            System.debug('Trigger.newMap ### ' + (newMap.get(pId).Status__c));
            Attendies__c p1 = [select Id,Child_Count__c from Attendies__c where Presentation_Name__c = :pId];
            System.debug('p1.Child_Count__c ### ' + p1.Child_Count__c);
            p1.Child_Count__c = 1;
            System.debug('p1.Child_Count__c2 ### ' + p1.Child_Count__c);
            update p1;
        }
    }
}
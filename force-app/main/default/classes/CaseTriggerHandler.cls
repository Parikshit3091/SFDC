public class CaseTriggerHandler {

    public static void testMesthod1(List<SObject> newList, List<SObject> oldList, 
                                   	Map<Id, SObject> newMap, Map<Id, SObject> oldMap)
    {
        System.debug('testMesthod1 Trigger.newList #### ' + ((List<Case>)newList));
        System.debug('testMesthod1 Trigger.oldList #### ' + ((List<Case>)oldList));
        System.debug('testMesthod1 Trigger.newMap #### ' + ((Map<Id, Case>)newMap));
        System.debug('testMesthod1 Trigger.oldMap #### ' + ((Map<Id, Case>)oldMap));
    }
    
    public static void testMesthod2(List<SObject> newList, List<SObject> oldList, 
                                   	Map<Id, SObject> newMap, Map<Id, SObject> oldMap)
    {
        System.debug('testMesthod2 Trigger.newList #### ' + ((List<Case>)newList));
        System.debug('testMesthod2 Trigger.oldList #### ' + ((List<Case>)oldList));
        System.debug('testMesthod2 Trigger.newMap #### ' + ((Map<Id, Case>)newMap));
        System.debug('testMesthod2 Trigger.oldMap #### ' + ((Map<Id, Case>)oldMap));
        
        //List<CaseMilestone> cseMilestone = new List<CaseMilestone>();
        //Case cse = (Case)newList.get(0);
        
    }
}
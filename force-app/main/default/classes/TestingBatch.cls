public class TestingBatch implements Database.Batchable<sOBject>{

    public Database.QueryLocator start(Database.BatchableContext ctx){
        String query = 'select Id from Account where name = \'\' ';
        System.debug('inside start');
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext ctx, List<sObject> scope){
        System.debug('inside execute');
    }
    
    public void finish(Database.BatchableContext ctx){
 		System.debug('inside finish');       
    }
}
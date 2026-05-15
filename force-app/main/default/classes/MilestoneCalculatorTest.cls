@isTest
public class MilestoneCalculatorTest {

    @isTest
    public static void testMilestone(){
        Account acc = new Account();
        acc.Name = 'ABC Acc';
        insert acc;
        
        //Get entitlement process
        SlaProcess entProcess = [select Id from SlaProcess where Name = 'Prime Users' limit 1];
        System.debug('entProcess ### ' + entProcess);
        
        //Get milestones
        String mlId = null;
        MilestoneType mlstone = new MilestoneType();
        List<MilestoneType> mls = [select Id,Name from MilestoneType];
        for(MilestoneType ml : mls){
            mlId = ml.Id;
            mlstone = ml;
        }
        System.debug('mlId ### ' + mlId);
        System.debug('mlstone ### ' + mlstone);
        
        //Create entitlement record
        Entitlement ent = new Entitlement();
        ent.SlaProcessId = entProcess.Id;
        ent.Name = 'New Entitlement';
        ent.AccountId = acc.Id;
        ent.Type = 'Phone';
        ent.StartDate = System.today();
        insert ent;
        
        //Insert case
        Case c1 = new Case();
        c1.EntitlementId = ent.Id;
        c1.Status = 'Open';
        insert c1;
    }
}
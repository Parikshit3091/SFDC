public class AccountScheduler implements Schedulable {

    public void execute(SchedulableContext ctx){
        System.debug('scheduled..!!');
    }
}
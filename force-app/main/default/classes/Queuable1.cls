public class Queuable1 implements Queueable{

    public void execute(QueueableContext ctx){
        System.debug('line 4');
        System.enqueueJob(new Queuable2());
        //System.enqueueJob(new Queuable3());
    }
}
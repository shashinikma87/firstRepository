public class q171641 implements Database.Batchable<Integer> {
    Id jobId;

    public String[] log { get; set; }

    public q171641() {
        log = new String[0];
    }

    public void startJob() {
        jobId = Database.executeBatch(this, 1);
    }

    public Integer[] start(Database.BatchableContext context) {
        fiftySeconds();
        return new Integer[] { 1 };
    }

    public void execute(Database.BatchableContext context, Integer[] scope) {
        fiftySeconds();
    }

    public void finish(Database.BatchableContext context) {
        fiftySeconds();
    }
    void fiftySeconds() {
        DateTime start = DateTime.now();
        while(DateTime.now().getTime()-start.getTime()<50000);
    }

    public void checkJobStatus() {
        AsyncApexJob job = [SELECT TotalJobItems, JobItemsProcessed, CompletedDate, Status FROM AsyncApexJob WHERE Id = :jobId];
        log.add(job.JobItemsProcessed+'/'+job.TotalJobItems+'/'+job.Status+'/'+job.CompletedDate);
    }
}
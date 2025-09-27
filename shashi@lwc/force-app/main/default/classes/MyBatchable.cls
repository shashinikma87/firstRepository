public class MyBatchable implements Database.Batchable<Execution> {

    private class Execution {
        // Various data fields go here
    }

    public Execution[] start(Database.BatchableContext bc) {
        Execution[] execs = new Execution[] {};
        // Logic that creates and adds to the list
        // Subject to normal governor limits
        return execs;
    }

    public void execute(Database.BatchableContext bc, Execution[] execs) {
        for (Execution exec : execs) {
            // Do something
        }
    }

    public void finish(Database.BatchableContext bc) {
    }
}
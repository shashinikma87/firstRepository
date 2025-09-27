@isTest public class DailyLeadProcessorTest {

    public static String CRON_EXP = '0 0 0 23 5 ? 2017';
    
    @isTest static void testResult () {
        
        List<Lead> lst = new List<Lead>();
        
        List<ID> ids = new List<ID>();
        
        integer i = 0 ;
        for (i=0;i<200;i++) {
            Lead l = new Lead(LastName = 'last Name', Company ='c1');
            lst.add(l);
        }
        insert lst;
        for (Lead l : lst) {
            ids.add(l.id);
        }
        
        Test.startTest();
        
        String jobId = System.schedule('DailyLeadProcessorTest', CRON_EXP, new DailyLeadProcessor());
        
        Test.stopTest();        
        
        List<Lead> l1 = [select id, LeadSource from Lead where LeadSource = 'DreamForce' and id in : ids];
        
        System.assertEquals (l1.size(), lst.size(), 'Leads are updated with DreamForce.');
    }
}
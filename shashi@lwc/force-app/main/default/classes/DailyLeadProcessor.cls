global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
    
        List<Lead> lead_list = [ select id, LeadSource from Lead where LeadSource = '' ];
        for (Lead l : lead_list){
            l.leadSource = 'Dreamforce';
        }
        update lead_list;
    }
}
global class schedulerForContactCreation implements System.Schedulable {

    global void execute(System.SchedulableContext sc){
        
        insert new Contact(LastName='Test Contact');
    }
}
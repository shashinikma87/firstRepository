public with sharing class MultiController {

    public SelectOption[] selectedContacts { get; set; }
    public SelectOption[] allContacts { get; set; }
    
    public String message { get; set; }
    
    public MultiController() {
        selectedContacts = new List<SelectOption>();
        
        List<Account> contacts = [SELECT Name, Id FROM Account];    
        allContacts = new List<SelectOption>();
        for ( Account c : contacts ) {
            allContacts.add(new SelectOption(c.Id, c.Name));
        }
    }

    public PageReference save() {
        message = 'Selected Contacts: ';
        Boolean first = true;
        for ( SelectOption so : selectedContacts ) {
            if (!first) {
                message += ', ';
            }
            message += so.getLabel() + ' (' + so.getValue() + ')';
            first = false;
        }
        
        return null;       
    }
}
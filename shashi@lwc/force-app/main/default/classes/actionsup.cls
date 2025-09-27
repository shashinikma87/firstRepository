public class actionsup
{
    public string selected {get;set;}
    public List<selectOption> options {get; set;}
    
    public actionsup()
    {
        setOptionsList();
    }
    
    public void setOptionsList()
    {
        options = new List<selectOption>();
        options.add(new SelectOption('-None-', '-None-'));
        options.add(new SelectOption('nl', 'nl'));
        options.add(new SelectOption('de', 'de'));
        
    }
    
    public void selectlist()
    {
        system.debug('language : '+selected);
    }
    
    /*
    public pagereference selectlist()
    {
        system.debug('language'+selected);
        
        
        pagereference pg = page.dropDown;
        if(selected != '')
        {
            pg.getParameters().put('lang', selected);
        }
        pg.setRedirect(true);
        
        return pg;
		
    }
*/
        /*
	system.debug('getStatuses   :' + 'IN THE GET STATUS METHOD');  

        Statuses = new List<SelectOption>();
        Schema.DescribeFieldResult fr = Solution.Status.getDescribe();        
        List<Schema.PicklistEntry> ple = fr.getPicklistValues();
        
        Statuses.add(new SelectOption('Default', 'Default'));
        Statuses.add(new SelectOption('All', 'All'));
        
        system.debug('ple   :' + ple); 
        
        for(Schema.PicklistEntry f : ple)            
        {
            Statuses.add(new SelectOption(f.getLabel(), f.getValue()));
        }         
     
        system.debug('options   :' + Statuses);  
*/

}
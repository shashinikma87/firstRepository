public class DataTableHelper{
 
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    Public Integer start{get;set;}
    string queryString;
    public ApexPages.StandardSetController setCon {get;set;}
 
    public DataTableHelper(){
       
    }
 
 
    public string dataTableJson {get;set;}
     
    public void processData()
    {
        queryString = 'select FirstName,LastName,Birthdate from Contact';
        
        system.debug('get Params : '+ApexPages.currentPage().getParameters().size());
        for( String s : ApexPages.currentPage().getParameters().keyset())
        {
            system.debug(s +' => '+ApexPages.currentPage().getParameters().get(s));
        }
        
        string searchKey = ApexPages.currentPage().getParameters().get('search[value]');
        
        if(searchKey != null && searchKey != '' && searchKey.trim().length() > 0)
        {
            queryString += ' Where FirstName like \'%'+searchKey+'%\' or LastName like \'%'+searchKey+'%\''; 
        }
        
        integer i = 0;
        String str = 'order[0][column]';
        //set order by clause , this code is assume that the sorting is on only one field but this can modified accordingly
        //also set direction from order[0][dir] parameter. note: we are taking 0th element as we have assume only one sorting
        queryString += ' order by ' + ApexPages.currentPage().getParameters().get('columns['+ApexPages.currentPage().getParameters().get(str) + '][data]') + ' ' + 
                                ApexPages.currentPage().getParameters().get('order[0][dir]') + ' Limit 11';
        system.debug('+++query'+queryString );
        //get starting record number for current view, this parametter will be send by datatable js
        start= Integer.valueOf(ApexPages.currentPage().getParameters().get('start'));
        //current number of records per page, it is also in avilable in get request
        size = Integer.valueOf(ApexPages.currentPage().getParameters().get('length'));
        //intialize standard controller with query
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        setCon.setPageSize(size);
        noOfRecords= setCon.getResultSize();
        //set pagenumber
        setCon.setPageNumber((start/size)+1);
        List<sobject> contactList = setCon.getRecords();
        //create wrapper
        DataTableWrapper datawrap = new DataTableWrapper(0,noOfRecords,noOfRecords,contactList );
        dataTableJson = JSON.serialize(datawrap);
         
    }
    
    public class DataTableWrapper
    {
        public Integer draw;
        public Integer recordsTotal;
        public Integer recordsFiltered;
        public List<sobject> data;
        public DataTableWrapper(Integer draw,Integer recordsTotal,Integer recordsFiltered,list<contact> data)
        {
            this.draw = draw;
            this.recordsTotal = recordsTotal;
            this.recordsFiltered = recordsFiltered ;
            this.data = data;
        }
         
    }
    
}
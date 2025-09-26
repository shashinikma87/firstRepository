public class paginationCntlr {

    public List<accContactWrapper> wrapList {get; set;}
    public List<accContactWrapper> wrapList1;
    
    public List<List<accContactWrapper>> listOfwrapList {get; set;}
    public Integer paginationSize {get; set;}
    public Integer listNumber{get; set;}
    public Integer totalPages{get; set;}
    public boolean showSchMessage {get; set;}
    
    public paginationCntlr()
    {
        wrapList = new List<accContactWrapper>();
        wrapList1 = new List<accContactWrapper>();
        listOfwrapList = new List<List<accContactWrapper>>();
        
        showSchMessage = false;
        
        paginationSize = 100;
        listNumber = 0;
        
        refreshList();
    }
    
    public void retrieveData()
    {
        List<Account> lstAcc = new List<Account>();
        List<Contact> lstCon = new List<Contact>();
        
        lstAcc = [SELECT ID, NAME FROM Account];
        Set<String> accIds = new Set<String>();
        for (Account a : lstAcc)
        {
			accIds.add(a.id);
        }
        lstCon = [SELECT ID, NAME, Account.Name FROM Contact WHERE AccountId IN: accIds limit 25];
        system.debug('lstCon size : '+lstCon.size());
        Integer i =1;
        for (Contact c : lstCon)
        {
            accContactWrapper wrap = new accContactWrapper();
            wrap.srNo = i;
            wrap.conId = c.id; 
            wrap.conName = c.Name;
            wrap.AccName = c.Account.Name;
			i++;
            
            wrapList1.add(wrap);
        }
        
        system.debug('wrapList1 : '+wrapList1.size());
        if (!wrapList1.isEmpty())
        {
            showSchMessage = true;
            system.debug('showSchMessage : '+showSchMessage);
        }
        refreshList ();
    }
        
    public void refreshList ()
    {
        listOfwrapList = new List<List<accContactWrapper>>();
        Integer j = 0;
        
		for (accContactWrapper wrap1 : wrapList1)        
        {
            
            paginationSize = 20;
            //system.debug('math.mod(j, paginationSize)'+math.mod(j, paginationSize));
            if(math.mod(j, paginationSize) == 0)
            {
                List<accContactWrapper> tempAccountList = new List<accContactWrapper>();
                tempAccountList.add(wrap1);
                listOfwrapList.add(tempAccountList);
            }
            else
            {
                listOfwrapList.get(listOfwrapList.Size() - 1).add(wrap1);
            }
            j++;
        }
        if(!listOfwrapList.isEmpty())
        {
        	wrapList = listOfwrapList.get(listNumber);
        }
        totalPages = listOfwrapList.size();

        system.debug('showSchMessage : '+showSchMessage);
        system.debug('totalPages : '+totalPages);
    }
    
    public void next()
    {
        system.debug('m in next method..');
        if(listOfwrapList.Size()-1 > listNumber){
            ++listNumber;
            refreshList();
        }
    }
    
    public void previous()
    {
        system.debug('m in previous method..');
        if(0 < listNumber){
            --listNumber;
            refreshList();      
        }
    }
    
    public boolean gethasPrevious()
    {
        system.debug('in gethasPrevious : '+listNumber);
        if(listNumber > 0)
        {
            return true;    
        }
        return false;
    }
    
    public boolean gethasNext()
    {
        system.debug('in getHasNext : '+listNumber);
        system.debug('listOfwrapList.Size() : '+listOfwrapList.Size());
        
        if(listNumber < listOfwrapList.Size() -1)
        {
            system.debug('in if..');
            showSchMessage = true;
            return true;    
        }
        else {
            system.debug('in else..');
            showSchMessage = false;
        	return false;
        }
    }
    
    public class accContactWrapper
    {
        public Integer srNo {get; set;}
        public String conId {get; set;}
        public String conName {get; set;}
        public String AccName {get; set;}
        
    }
}
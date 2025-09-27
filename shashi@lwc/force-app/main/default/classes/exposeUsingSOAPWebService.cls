global with sharing class exposeUsingSOAPWebService 
{

    webservice static Case returnCaseRecord ()
    {
        Case c = new Case();
        
        return c;
    }
    
}
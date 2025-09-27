/****************************************************************************************
Name            : AH_Content_packs_Zip_file
Author          : Bhagwat Garkal
Created Date    : 12/23/2020
Modified Date   : 12/23/2020
Last Mod By     : Bhagwat Garkal
NICC Reference  : 
Description     : This Class is used to Create Zip file into the Content Packs.
                :
******************************************************************************************/

public class AH_ContentPacks_ZipFile_Ctlr 
{
    public list<ContentVersionWarp> listOfFiles {get;set;}
    public String searchKey {get;set;}
    public String selectedLibrary {get;set;}
    public String selectLibForPublish {get;set;}
    public String contentPackName {get;set;}
    public String tags{get;set;}
    public String comments {get;set;}
    public Boolean displayFileNotFound{get;set;}
    public List<SelectOption> librarylistInPopup {get;set;}
    
    public AH_ContentPacks_ZipFile_Ctlr()
    {
        displayFileNotFound = false;
        listOfFiles = new list<ContentVersionWarp>();
    }
    
    public class ContentVersionWarp {
        public String name { get; set; }
        public boolean selectedFile { get; set; }
        public String cvId {get; set; }
        public String contentDocumentId{get; set; }
        public String fileType{get; set; }
        public ContentVersionWarp(ContentVersion cv) 
        {
            if(cv != null)
            {
                name = cv.title;
                cvId = cv.id;
                contentDocumentId = cv.ContentDocumentId;
                selectedFile = false;
            }
        }
    }
    
    //Search files method
    public void search()
    {
        displayFileNotFound = false;
        listOfFiles = new list<ContentVersionWarp>();
        
        String  searchquery ='select Id,Title,ContentDocumentId,FileType, FirstPublishLocationId from ContentVersion where Title like \'%'+searchKey+'%\'';
            
        if(selectedLibrary != null && selectedLibrary != '')
        {
            searchquery += ' AND ContentDocument.ParentId =\''+selectedLibrary+'\'';    
        }
        
        searchquery += ' AND IsLatest = true Limit 500';
        
        System.debug('searchquery='+searchquery);
        if(searchquery != null && searchquery != '')
        {
            for(ContentVersion cvRecord: Database.query(searchquery))
            {
                if(cvRecord.FileType != 'ZIP' && cvRecord.FileType != 'PACK')
                {
                	listOfFiles.add(new ContentVersionWarp(cvRecord));    
                }
            }
            
            if(listOfFiles == null || listOfFiles.Size() == 0)
            {
                displayFileNotFound = true;
            }
        }
        
        System.debug('listOfFiles==>'+listOfFiles);
    }
    
    public void clear()
    {
        listOfFiles.clear();
    }
    
    //Get library list to display on page
    public List<SelectOption> getlibrarylist() 
    {
        List<SelectOption> options = new List<SelectOption>();
        librarylistInPopup = new List<SelectOption>();
        options.add(new SelectOption('','All Libraries'));
        librarylistInPopup.add(new SelectOption('','--None--'));
        for(ContentWorkspace cws : [select Id,DeveloperName,Name from ContentWorkspace])
        {
            options.add(new SelectOption(cws.id,cws.Name));
            librarylistInPopup.add(new SelectOption(cws.id,cws.Name));
        }
        
        return options;
    }
  
    
    //This method is used to create zip file
    public PageReference createZipFile()
    {
        try
        {
            if(contentPackName != null && contentPackName != '')
            {   
                if((selectLibForPublish == null || selectLibForPublish == '') &&  librarylistInPopup != null && librarylistInPopup.size() > 0)
                {
                    Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please select library.'));
                    return null;
                }
                
                if(listOfFiles != null && listOfFiles.size() > 0)
                {
                    set<Id> selectedFilesIds = new set<Id>();
                    List<ContentVersion> lstContentVersion = new List<ContentVersion>();
                    Set<ID> setContentVersionInsertedIds = new Set<ID>();
                    Set<ID> contentDocumentIdSet = new Set<ID>();
                    list<ContentDocumentLink> lstOfcdl = new list<ContentDocumentLink>();
                    Content_Pack__c contentPack = new Content_Pack__c();
                    
                    for(ContentVersionWarp cvWarap : listOfFiles)
                    {
                        if(cvWarap.selectedFile == true)
                        {
                            selectedFilesIds.add(cvWarap.cvId);
                            contentDocumentIdSet.add(cvWarap.contentDocumentId);
                        }
                    }
                    
                    if(selectedFilesIds != null && selectedFilesIds.Size() > 0)
                    {
                        Zippex zippedFilesFolder = new Zippex();
                        List<Content_Pack__c> insertContentPack = new List<Content_Pack__c>();
                        list<id> contentpackIds = new list<id>();
                        
                        contentPack.name= contentPackName;
                        if(contentPack != null)
                        {
                            insertContentPack.add(contentPack);
                            
                            if(insertContentPack != null && insertContentPack.size() >0)
                            {
                                Database.SaveResult[] srList = Database.insert(insertContentPack, false);
                                for(Database.SaveResult sr : srList)
                                {
                                    contentpackIds.add(sr.getId());
                                }
                            }
                        }
                        
                        Set<ID> setOfcontentDocumentIds = new Set<ID>();
                        for(ContentDocumentLink cdl : [SELECT ContentDocumentId, LINKEDENTITYID FROM ContentDocumentLink WHERE ContentDocumentId IN:contentDocumentIdSet])
                        {
                            setOfcontentDocumentIds.add(cdl.ContentDocumentId);
                        }
        
                        for(ContentVersion cv : [select Id,VersionNumber,Title,ContentDocumentId,PathOnClient,VersionData from ContentVersion where Id IN : selectedFilesIds])
                        {
                            zippedFilesFolder.addFile(cv.Title+'_'+cv.VersionNumber, cv.VersionData, null);
                            if(contentpackIds != null && contentpackIds.size() > 0)
                            {
                                ContentDocumentLink cDe = new ContentDocumentLink();
                                cDe.ContentDocumentId = cv.ContentDocumentId;
                                cDe.LinkedEntityId = contentpackIds[0];
                                cDe.ShareType = 'V';
                                cDe.Visibility = 'AllUsers';
                                lstOfcdl.add(cDe);    
                            }
                        }
                        
                        System.debug('contentPackName==>'+contentPackName);
                        
                        //preparing the zip file to insert into the database.
                        if(zippedFilesFolder != null)
                        {
                            ContentVersion conVer = new ContentVersion();
                            conVer.ContentLocation = 'S';
                            conVer.PathOnClient = contentPackName + '.zip';
                            conVer.Title = contentPackName + '.zip';
                            String afterblob = EncodingUtil.base64Encode(ZippedFilesFolder.getZipArchive());
                            conVer.VersionData = EncodingUtil.base64Decode(afterblob);
                            conVer.Description = comments;
                            conVer.TagCsv = tags;
                            
                            if(contentPack.Id != null)
                            {
                                conVer.Content_Pack__c=contentPack.Id;
                            }
                            lstContentVersion.add(conVer);    
                        }
                        
                        if(lstContentVersion.size() > 0)
                        {
                            Database.SaveResult[] srList = Database.insert(lstContentVersion, false);
                            for(Database.SaveResult sr : srList)
                            {
                                setContentVersionInsertedIds.add(sr.getId());
                            }
                            
                            System.debug('setContentVersionInsertedIds==>'+setContentVersionInsertedIds);
                            System.debug('selectLibForPublish==>'+selectLibForPublish);
                            
                            if(setContentVersionInsertedIds.size() > 0)
                            {
                                for(ContentVersion cvRecord : [SELECT Id,Title,filetype, ContentDocumentId FROM ContentVersion WHERE IsLatest = true and filetype = 'ZIP' and Id IN : setContentVersionInsertedIds])
                                {
                                    ContentDocumentLink cDe = new ContentDocumentLink();
                                    cDe.ContentDocumentId = cvRecord.ContentDocumentId;
                                    cDe.LinkedEntityId = selectLibForPublish;
                                    cDe.ShareType = 'I';
                                    cDe.Visibility = 'AllUsers';
                                    lstOfcdl.add(cDe);
                                }
                                
                                System.debug('lstOfcdl==>'+lstOfcdl);
                                
                                if(lstOfcdl.size() > 0)
                                {
                                    insert lstOfcdl; 
                                }    
                            }
                        }
                    }
                    else
                    {
                        Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please select at least one file.'));
                        return null;
                    }
                }
            }
            else
            {
            	Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.INFO,'Please enter content pack name.'));
                return null;
            }
            
            PageReference returnPage = Page.CreateContentPackTab;
            returnPage.getParameters().put('success','true');
            returnPage.setRedirect(true);
            return returnPage;
        }
        Catch(Exception  e)
        {
            System.debug('Exception==>'+e.getMessage()+'-Line Number'+e.getLineNumber());
        }    
        return null;
    }
    
    public Boolean hasError { 
        get { 
            return ApexPages.hasMessages(); 
        }       
    }
}
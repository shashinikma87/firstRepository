/****************************************************************************************
Name            : AH_ContentPacks_TriggerHandler
Author          : Bhagwat Garkal
Created Date    : 01/06/2021
Modified Date   : 01/06/2021
Last Mod By     : Bhagwat Garkal
NICC Reference  : 
Description     : This Class is used into the "AH_ContentPacks_Trigger" Trigger.
                :
******************************************************************************************/

public class AH_ContentPacks_TriggerHandler {
    
    Public Map<Id, Content_Pack__c> mapOfContentPack = new Map<Id, Content_Pack__c>();
    Map<String, List<Id>> mapOfCdl = new Map<String, List<Id>>();
    set<Id> allDocusIdFromPack = new set<Id>();
    Map<Id,ContentVersion> mapOfContentVersion = new Map<Id,ContentVersion>();
    Public set<Id> packsId = new set<Id>();
    Set<Id> contentDocusIdes = new Set<Id>();
    Map<Id,List<ContentVersion>> previousZipFiles = new Map<Id,List<ContentVersion>>();
    set<Id> previousZipFilesDocusId = new set<Id>();
    Map<Id,Id> contentWorkspaceMap = new Map<Id,Id>();
    Map<String,Id> libraryForCreatedZipFile = new Map<String,Id>();
    List<ContentDocumentLink> lstOfcdl = new List<ContentDocumentLink>();
    public static Boolean runOnce = true;
    
    public static Boolean isPage(){
        return ApexPages.currentPage() != null;
    }
    
    /*Create Zip file Version when Content Packs files updated.*/
    public void createZipFileVersion(List<ContentVersion> lstofContentVersion)
    {
        try
        {
            if(lstofContentVersion != null && lstofContentVersion.Size() > 0)
            {
                for(ContentVersion cv : lstofContentVersion)
                {
                    contentDocusIdes.add(cv.ContentDocumentId);  
                }
                
                System.debug('lstofContentVersion==?'+lstofContentVersion);
                
                if(contentDocusIdes != null && contentDocusIdes.Size() > 0)
                {
                    for(Content_Pack__c cp : [Select Id, Name from Content_Pack__c])
                    {
                        mapOfContentPack.put(cp.Id,cp);
                    }
                    
                    //Get all the Content pack record Ids which is associated with updated files. 
                    if(mapOfContentPack != null && mapOfContentPack.size() > 0)
                    {
                        for(ContentDocumentLink cdl : [select id, ShareType, LinkedEntityId, ContentDocumentId from ContentDocumentLink 
                                                    where LinkedEntityId IN : mapOfContentPack.keySet() and ContentDocumentId IN : contentDocusIdes])
                        {
                            packsId.add(cdl.LinkedEntityId);
                        }    
                    }    
                } 
                
                System.debug('packsId==>'+packsId);
                
                if(packsId != null && packsId.Size() > 0)
                {
                    for(ContentDocumentLink cdl : [select id, ShareType, LinkedEntityId, ContentDocumentId from ContentDocumentLink 
                                                    where LinkedEntityId IN : packsId])
                    {
                        if(mapOfCdl != null && mapOfCdl.containsKey(cdl.LinkedEntityId))
                        {
                            mapOfCdl.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
                        }
                        else
                        {
                            mapOfCdl.put(cdl.LinkedEntityId, new  List <Id> { cdl.ContentDocumentId });
                        }
                        
                       allDocusIdFromPack.add(cdl.ContentDocumentId); 
                    }
                    
                    //Get all the files which is associated with particular content packs.
                    for(ContentVersion cv : [select Id,VersionNumber,Title,IsLatest,FileType,Content_Pack__c,VersionData,ContentDocumentId,PathOnClient from ContentVersion where IsLatest = true AND ContentDocumentId IN : allDocusIdFromPack])
                    {
                        mapOfContentVersion.put(cv.ContentDocumentId,cv);
                    }
                    
                    //Get all the previous Zip Files which is associated with particular content packs.
                    for(ContentVersion cv : [select Id,VersionNumber,Title,IsLatest,FileType,Content_Pack__c, ContentDocumentId,PathOnClient from ContentVersion where IsLatest = true AND FileType = 'ZIP' and Content_Pack__c IN : packsId])
                    {
                        if(previousZipFiles != null && previousZipFiles.containsKey(cv.Content_Pack__c))
                        {
                            previousZipFiles.get(cv.Content_Pack__c).add(cv);
                        }
                        else
                        {
                            previousZipFiles.put(cv.Content_Pack__c, new  List <ContentVersion> { cv});
                        }
                        previousZipFilesDocusId.add(cv.ContentDocumentId);
                    }
                    
                    if(previousZipFilesDocusId !=  null && previousZipFilesDocusId.size() > 0)
                    {    
                        for(ContentDocumentLink previouscdl : [select id, ShareType, LinkedEntityId, ContentDocumentId from ContentDocumentLink where ContentDocumentId IN : previousZipFilesDocusId])
                        {
                            contentWorkspaceMap.put(previouscdl.ContentDocumentId,previouscdl.LinkedEntityId);
                        }    
                    }
                                                               
                    System.debug('mapOfCdl==>'+mapOfCdl);
                    System.debug('mapOfContentVersion==>'+mapOfContentVersion);
                    
                    List<ContentVersion> lstContentVersion = new List<ContentVersion>();
                    for(Id pacId : packsId)
                    {
                        Zippex zippedFilesFolder = new Zippex();
                        
                        //Adding files into the Zip folder.
                        for(Id docId : mapOfCdl.get(pacId))
                        {
                            if(mapOfContentVersion != null && mapOfContentVersion.containskey(docId))
                            {
                                zippedFilesFolder.addFile(mapOfContentVersion.get(docId).Title, mapOfContentVersion.get(docId).VersionData, null);
                                //zippedFilesFolder.addFile(mapOfContentVersion.get(docId).Title+'_'+'Version_'+mapOfContentVersion.get(docId).VersionNumber, mapOfContentVersion.get(docId).VersionData, null);
                            }
                        }
                        
                        //Create compressed Zip file folder.
                        if(zippedFilesFolder != null)
                        {
                            if(previousZipFiles != null && previousZipFiles.size() > 0 && previousZipFiles.containskey(pacId))
                            {
                                ContentVersion conVer = new ContentVersion();
                                conVer.ContentLocation = 'S';
                                conVer.PathOnClient = previousZipFiles.get(pacId)[0].Title.SubStringBefore('-Version-')+'-Version-'+previousZipFiles.get(pacId).size()+'.zip';
                                conVer.Title = previousZipFiles.get(pacId)[0].Title.remove('.zip');
                                //conVer.Title = previousZipFiles.get(pacId)[0].Title.SubStringBefore('-Version-')+'-Version-'+previousZipFiles.get(pacId).size()+'.zip';
                                String afterblob = EncodingUtil.base64Encode(ZippedFilesFolder.getZipArchive());
                                conVer.VersionData = EncodingUtil.base64Decode(afterblob);
                                conVer.Content_Pack__c= previousZipFiles.get(pacId)[0].Content_Pack__c;
                                conVer.ContentDocumentId = previousZipFiles.get(pacId)[0].ContentDocumentId;
                                
                                if(contentWorkspaceMap != null && contentWorkspaceMap.containsKey(previousZipFiles.get(pacId)[0].ContentDocumentId))
                                {
                                    libraryForCreatedZipFile.put(conVer.Content_Pack__c,contentWorkspaceMap.get(previousZipFiles.get(pacId)[0].ContentDocumentId));
                                }
                                
                                if(conVer.Content_Pack__c != null)
                                {
                                    lstContentVersion.add(conVer);    
                                }
                            }
                        }
                    }
                    
                    //Insert Zip file(ContentVersion) into the Database.
                    if(lstContentVersion.size() > 0)
                    {
                        Set<Id> setContentVersionInsertedIds = new Set<Id>();
                        Database.SaveResult[] srList = Database.insert(lstContentVersion, false);
                        for(Database.SaveResult sr : srList)
                        {
                            setContentVersionInsertedIds.add(sr.getId());
                        }
                        
                        System.debug('setContentVersionInsertedIds==>'+setContentVersionInsertedIds);
                        
                        //Adding created zip file in associated Library, for that need to create ContentDocumentLink.
                        /*if(setContentVersionInsertedIds.size() > 0 && libraryForCreatedZipFile != null && libraryForCreatedZipFile.size() > 0)
                        {
                            for(ContentVersion cvRecord : [SELECT Id,Title,ContentDocumentId,Content_Pack__c FROM ContentVersion WHERE Id IN : setContentVersionInsertedIds])
                            {
                                if(cvRecord.Content_Pack__c != null && libraryForCreatedZipFile.containsKey(cvRecord.Content_Pack__c))
                                {    
                                    ContentDocumentLink cDe = new ContentDocumentLink();
                                    cDe.ContentDocumentId = cvRecord.ContentDocumentId;
                                    cDe.LinkedEntityId = libraryForCreatedZipFile.get(cvRecord.Content_Pack__c);
                                    cDe.ShareType = 'I';
                                    cDe.Visibility = 'AllUsers';
                                    lstOfcdl.add(cDe);
                                }    
                            }
                            
                            System.debug('lstOfcdl==>'+lstOfcdl);
                            
                            if(lstOfcdl.size() > 0)
                            {
                                insert lstOfcdl; 
                            }    
                        }*/
                    }
                }
            }
        }    
        Catch(Exception  e)
        {
            System.debug('Exception==>'+e.getMessage()+'-Line Number'+e.getLineNumber());
        }
    }
    
    /*Create Zip file Version when Content Packs files updated.*/
    public void updateZipFileVersionOnFileDelete(List<ContentDocumentLink> lstofContentDocumentLink)
    {
        set<Id> cpIds = new set<Id>();
        set<Id> docIds = new set<Id>();
        try
        {
            if(lstofContentDocumentLink != null && lstofContentDocumentLink.Size() > 0)
            {
                for(ContentDocumentLink cdl : lstofContentDocumentLink)
                {
                    cpIds.add(cdl.LinkedEntityId);
                    docIds.add(cdl.ContentDocumentId);
                }
                
                if(cpIds != null && cpIds.size() > 0)
                {    
                    for(ContentDocumentLink contentDocLink : [select id, ShareType, LinkedEntityId, ContentDocumentId from ContentDocumentLink 
                                                        where LinkedEntityId IN : cpIds And LinkedEntityId NOT IN :docIds])
                    {
                        if(mapOfCdl != null && mapOfCdl.containsKey(contentDocLink.LinkedEntityId))
                        {
                            mapOfCdl.get(contentDocLink.LinkedEntityId).add(contentDocLink.ContentDocumentId);
                        }
                        else
                        {
                            mapOfCdl.put(contentDocLink.LinkedEntityId, new  List <Id> { contentDocLink.ContentDocumentId });
                        }
                        
                        allDocusIdFromPack.add(contentDocLink.ContentDocumentId); 
                    }
                    
                    for(ContentVersion cv : [select Id,VersionNumber,Title,IsLatest,FileType,Content_Pack__c,VersionData,ContentDocumentId,PathOnClient from ContentVersion where IsLatest = true AND ContentDocumentId IN : allDocusIdFromPack])
                    {
                        mapOfContentVersion.put(cv.ContentDocumentId,cv);
                    }
                    
                    //Get all the previous Zip Files which is associated with particular content packs.
                    for(ContentVersion cv : [select Id,VersionNumber,Title,IsLatest,FileType,Content_Pack__c, ContentDocumentId,PathOnClient from ContentVersion where IsLatest = true AND FileType = 'ZIP' and Content_Pack__c IN : packsId])
                    {
                        if(previousZipFiles != null && previousZipFiles.containsKey(cv.Content_Pack__c))
                        {
                            previousZipFiles.get(cv.Content_Pack__c).add(cv);
                        }
                        else
                        {
                            previousZipFiles.put(cv.Content_Pack__c, new  List <ContentVersion> { cv});
                        }
                        previousZipFilesDocusId.add(cv.ContentDocumentId);
                    }
                    
                    if(previousZipFilesDocusId !=  null && previousZipFilesDocusId.size() > 0)
                    {    
                        for(ContentDocumentLink previouscdl : [select id, ShareType, LinkedEntityId, ContentDocumentId from ContentDocumentLink where ContentDocumentId IN : previousZipFilesDocusId])
                        {
                            contentWorkspaceMap.put(previouscdl.ContentDocumentId,previouscdl.LinkedEntityId);
                        }    
                    }
                    
                    System.debug('mapOfCdl==>'+mapOfCdl);
                    System.debug('mapOfContentVersion==>'+mapOfContentVersion);
                    
                    List<ContentVersion> lstContentVersion = new List<ContentVersion>();
                    
                    if(mapOfCdl != null && mapOfCdl.size() > 0)
                    {    
                        for(Id pacId : cpIds)
                        {
                            Zippex zippedFilesFolder = new Zippex();
                            
                            //Adding files into the Zip folder.
                            for(Id docId : mapOfCdl.get(pacId))
                            {
                                if(mapOfContentVersion != null && mapOfContentVersion.containskey(docId))
                                {
                                    zippedFilesFolder.addFile(mapOfContentVersion.get(docId).Title, mapOfContentVersion.get(docId).VersionData, null);
                                    //zippedFilesFolder.addFile(mapOfContentVersion.get(docId).Title+'_'+'Version_'+mapOfContentVersion.get(docId).VersionNumber, mapOfContentVersion.get(docId).VersionData, null);
                                }
                            }
                            
                            //Create compressed Zip file folder.
                            if(zippedFilesFolder != null)
                            {
                                if(previousZipFiles != null && previousZipFiles.size() > 0 && previousZipFiles.containskey(pacId))
                                {
                                    ContentVersion conVer = new ContentVersion();
                                    conVer.ContentLocation = 'S';
                                    conVer.PathOnClient = previousZipFiles.get(pacId)[0].Title.SubStringBefore('-Version-')+'-Version-'+previousZipFiles.get(pacId).size()+'.zip';
                                    conVer.Title = previousZipFiles.get(pacId)[0].Title.remove('.zip');
                                    //conVer.Title = previousZipFiles.get(pacId)[0].Title.SubStringBefore('-Version-')+'-Version-'+previousZipFiles.get(pacId).size()+'.zip';
                                    String afterblob = EncodingUtil.base64Encode(ZippedFilesFolder.getZipArchive());
                                    conVer.VersionData = EncodingUtil.base64Decode(afterblob);
                                    conVer.Content_Pack__c= previousZipFiles.get(pacId)[0].Content_Pack__c;
                                    conVer.ContentDocumentId = previousZipFiles.get(pacId)[0].ContentDocumentId;
                                    
                                    if(contentWorkspaceMap != null && contentWorkspaceMap.containsKey(previousZipFiles.get(pacId)[0].ContentDocumentId))
                                    {
                                        libraryForCreatedZipFile.put(conVer.Content_Pack__c,contentWorkspaceMap.get(previousZipFiles.get(pacId)[0].ContentDocumentId));
                                    }
                                    
                                    if(conVer.Content_Pack__c != null)
                                    {
                                        lstContentVersion.add(conVer);    
                                    }
                                }
                            }
                        }
                    }    
                  
                    //Insert Zip file(ContentVersion) into the Database.
                    if(lstContentVersion.size() > 0)
                    {
                        Set<Id> setContentVersionInsertedIds = new Set<Id>();
                        Database.SaveResult[] srList = Database.insert(lstContentVersion, false);
                        for(Database.SaveResult sr : srList)
                        {
                            setContentVersionInsertedIds.add(sr.getId());
                        }
                        
                        System.debug('setContentVersionInsertedIds==>'+setContentVersionInsertedIds);
                    }
                }    
            }
        }
    
        Catch(Exception  e)
        {
            System.debug('Exception==>'+e.getMessage()+'-Line Number'+e.getLineNumber());
        }
    }
}
@isTest
public class MetadataServiceTest{
    
    private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			if(request instanceof MetadataService.readMetadata_element)
				response.put('response_x', new MetadataService.readInstalledPackageResponse_element());
			
			return;
		}
	}
    @IsTest
	private static void coverGeneratedCodeCRUDOperations()
	{	
    	// Null Web Service mock implementation
       // System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations     
        Test.startTest();    
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        Test.stopTest();
	}
    
    @IsTest
    private static void coverGeneratedCodeFileBasedOperations1()
    {    	
    	// Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations    
        Test.startTest();     
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        metaDataPort.readMetadata(null, null);
        Test.stopTest();
    }
    
    @IsTest
    private static void coverGeneratedCodeTypes()
    {    	       
        // Reference types
        Test.startTest();
        new MetadataService();
        new MetadataService.SessionHeader_element();
        new MetadataService.DebuggingInfo_element();
        new MetadataService.readMetadata_element();
        new MetadataService.PackageTypeMembers();
        new MetadataService.ProfileObjectPermissions();
        new MetadataService.Package_x();
        new MetadataService.ReadInstalledPackageResult();
        new MetadataService.readInstalledPackageResponse_element();
        new MetadataService.ReadInstalledPackageResult().getRecords();
        new MetadataService.readInstalledPackageResponse_element().getResult();
        new MetadataService.InstalledPackage();
        Test.stopTest();
    }
}
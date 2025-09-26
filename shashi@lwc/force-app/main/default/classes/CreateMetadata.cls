public class CreateMetadata{
    
    public void retrieveMetadata () {
        // List fullnames of components we want to retrieve
        List<String> componentNameList = 
            new List<String>{'Test__mdt.Default'};
                
		System.debug('componentNameList : '+componentNameList);
        
		// Retrieve components that are records of custom metadata types based on name
		List<Metadata.Metadata> components = Metadata.Operations.retrieve(
                    Metadata.MetadataType.CustomMetadata, componentNameList);
        
        Metadata.CustomMetadata customMetadataRecord = (Metadata.CustomMetadata) components.get(0);
        
        // Check fields of retrieved component
        List<Metadata.CustomMetadataValue> values = customMetadataRecord.values;
        for (integer i = 0; i < values.size(); i++) 
        {
            if (values.get(i).field == 'Record_Type__c') 
            {
                 System.debug('Value : '+values.get(i).value);   
			}
        }
    }
    
    public void updateAndDeployMetadata() {
        
        // Set up custom metadata to be created in the subscriber org.
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = 'Test__mdt.Default';
        customMetadata.label = 'Default';
        
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
        customField.field = 'Record_Type__c';
        customField.value = 'AAAAAA';
        
        customMetadata.values.add(customField);
        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        
        // Setup deploy callback, MyDeployCallback implements
        // the Metadata.DeployCallback interface (code for
        // this class not shown in this example)
        CustomMetadataCallback callback = new CustomMetadataCallback();
        
        // Enqueue custom metadata deployment
        // jobId is the deployment ID
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
        
    }
}
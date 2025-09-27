public class MetadataService extends Metadata {
    
    public static String SERVER_URL = '';
    
    public virtual class Metadata {
    	public String fullName;
	}
    
	public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};    
		private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }

    public class SaveResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] success_type_info = new String[]{'success','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
    }
    
    public class MetadataPort {
        
        public String endpoint_x = SERVER_URL + '/services/Soap/m/37.0';
        
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public MetadataService.SessionHeader_element SessionHeader;
        public MetadataService.DebuggingInfo_element DebuggingInfo;
		
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'MetadataService'};
       
        public MetadataService.IReadResult readMetadata(String type_x,String[] fullNames) {
            MetadataService.readMetadata_element request_x = new MetadataService.readMetadata_element();
            request_x.type_x = type_x;
            request_x.fullNames = fullNames;
            MetadataService.IReadResponseElement response_x;
            Map<String, MetadataService.IReadResponseElement> response_map_x = new Map<String, MetadataService.IReadResponseElement>();
            response_map_x.put('response_x', response_x);
            //System.debug('request_x  : '+request_x );
            //System.debug('endpoint_x :'+endpoint_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'readMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'readMetadataResponse',
              'MetadataService.read' + type_x + 'Response_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getResult();
        }
        
        public MetadataService.SaveResult[] createMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.createMetadata_element request_x = new MetadataService.createMetadata_element();
            request_x.metadata = metadata;
            MetadataService.createMetadataResponse_element response_x;
            Map<String, MetadataService.createMetadataResponse_element> response_map_x = new Map<String, MetadataService.createMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'createMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'createMetadataResponse',
              'MetadataService.createMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        public MetadataService.FileProperties[] listMetadata(MetadataService.ListMetadataQuery[] queries,Double asOfVersion) {

            system.debug('SERVER_URL : '+SERVER_URL);
            
            MetadataService.listMetadata_element request_x = new MetadataService.listMetadata_element();
            request_x.queries = queries;
            request_x.asOfVersion = asOfVersion;
            MetadataService.listMetadataResponse_element response_x;
            Map<String, MetadataService.listMetadataResponse_element> response_map_x = new Map<String, MetadataService.listMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/2006/04/metadata',
              'listMetadata',
              'http://soap.sforce.com/2006/04/metadata',
              'listMetadataResponse',
              'MetadataService.listMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
    
    public class createMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'metadata'};
    }
    
    public class createMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class Error {
        public MetadataService.ExtendedErrorDetails[] extendedErrorDetails;
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] extendedErrorDetails_type_info = new String[]{'extendedErrorDetails','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] fields_type_info = new String[]{'fields','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] message_type_info = new String[]{'message','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] statusCode_type_info = new String[]{'statusCode','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorDetails','fields','message','statusCode'};
    }
    
    public class ExtendedErrorDetails {
        public String extendedErrorCode;
        private String[] extendedErrorCode_type_info = new String[]{'extendedErrorCode','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'extendedErrorCode'};
    }
    
    public interface IReadResult {
        MetadataService.Metadata[] getRecords();
    }
    public interface IReadResponseElement {
        IReadResult getResult();
    }
    
    
    public class readMetadata_element {
        public String type_x;
        public String[] fullNames;
        private String[] type_x_type_info = new String[]{'type','https://ap2.salesforce.com/services/Soap/m/37.0/00D28000001jCaJ',null,'1','1','false'};
        private String[] fullNames_type_info = new String[]{'fullNames','https://ap2.salesforce.com/services/Soap/m/37.0/00D28000001jCaJ',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'https://ap2.salesforce.com/services/Soap/m/37.0/00D28000001jCaJ','true','false'};
        private String[] field_order_type_info = new String[]{'type_x','fullNames'};
    }
    
    public class PackageTypeMembers {
        public String[] members;
        public String name;
        private String[] members_type_info = new String[]{'members','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] name_type_info = new String[]{'name','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'members','name'};
    }
    public class ProfileObjectPermissions {
        public Boolean allowCreate;
        public Boolean allowDelete;
        public Boolean allowEdit;
        public Boolean allowRead;
        public Boolean modifyAllRecords;
        public String object_x;
        public Boolean viewAllRecords;
        private String[] allowCreate_type_info = new String[]{'allowCreate','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowDelete_type_info = new String[]{'allowDelete','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowEdit_type_info = new String[]{'allowEdit','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] allowRead_type_info = new String[]{'allowRead','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] modifyAllRecords_type_info = new String[]{'modifyAllRecords','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] object_x_type_info = new String[]{'object','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] viewAllRecords_type_info = new String[]{'viewAllRecords','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'allowCreate','allowDelete','allowEdit','allowRead','modifyAllRecords','object_x','viewAllRecords'};
    }
    public class Package_x extends Metadata {
        public String type = 'Package_x';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String apiAccessLevel;
        public String description;
        public String namespacePrefix;
        public MetadataService.ProfileObjectPermissions[] objectPermissions;
        public String packageType;
        public String postInstallClass;
        public String setupWeblink;
        public MetadataService.PackageTypeMembers[] types;
        public String uninstallClass;
        public String version;
        private String[] apiAccessLevel_type_info = new String[]{'apiAccessLevel','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] objectPermissions_type_info = new String[]{'objectPermissions','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] packageType_type_info = new String[]{'packageType','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] postInstallClass_type_info = new String[]{'postInstallClass','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] setupWeblink_type_info = new String[]{'setupWeblink','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] types_type_info = new String[]{'types','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] uninstallClass_type_info = new String[]{'uninstallClass','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] version_type_info = new String[]{'version','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'apiAccessLevel','description','namespacePrefix','objectPermissions','packageType','postInstallClass','setupWeblink','types','uninstallClass','version'};
    }

/*  
NICC-028266 (START)
    public class InstalledPackage extends Metadata {
        public String type = 'InstalledPackage';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String password;
        public String versionNumber;
        public String status;
        private String[] status_type_info = new String[]{'status','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] versionNumber_type_info = new String[]{'versionNumber','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'password','versionNumber','status'};
    }
NICC-028266 (END)
*/ 
    // NICC-028266 (START) - Fix by Cybage as a result of Summer '18 upgrade
    public class InstalledPackage extends Metadata 
    {
        public String type = 'InstalledPackage';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String password;
        public String versionNumber;
        public String activateRSS;
        private String[] activateRSS_type_info = new String[]{'activateRSS','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] password_type_info = new String[]{'password','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] versionNumber_type_info = new String[]{'versionNumber','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'password','versionNumber','activateRSS'};
	}
    // NICC-028266 (END) 
    
    public class ReadInstalledPackageResult implements IReadResult {
        public MetadataService.InstalledPackage[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public class readInstalledPackageResponse_element implements IReadResponseElement {
        public MetadataService.ReadInstalledPackageResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class ReadRemoteSiteSettingResult implements IReadResult {
        public MetadataService.RemoteSiteSetting[] records;
        public MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'records'};
    }
    public class readRemoteSiteSettingResponse_element implements IReadResponseElement {
        public MetadataService.ReadRemoteSiteSettingResult result;
        public IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class RemoteSiteSetting extends Metadata {
        public String type = 'RemoteSiteSetting';
        public String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        public String description;
        public Boolean disableProtocolSecurity;
        public Boolean isActive;
        public String url;
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] disableProtocolSecurity_type_info = new String[]{'disableProtocolSecurity','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] isActive_type_info = new String[]{'isActive','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] url_type_info = new String[]{'url','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] field_order_type_info = new String[]{'fullName', 'description','disableProtocolSecurity','isActive','url'};
    }
    
    
    public class ListMetadataQuery {
        public String folder;
        public String type_x;
        private String[] folder_type_info = new String[]{'folder','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'folder','type_x'};
    }
    public class listMetadata_element {
        public MetadataService.ListMetadataQuery[] queries;
        public Double asOfVersion;
        private String[] queries_type_info = new String[]{'queries','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] asOfVersion_type_info = new String[]{'asOfVersion','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'queries','asOfVersion'};
    }
    public class FileProperties {
        public String createdById;
        public String createdByName;
        public DateTime createdDate;
        public String fileName;
        public String fullName;
        public String id;
        public String lastModifiedById;
        public String lastModifiedByName;
        public DateTime lastModifiedDate;
        public String manageableState;
        public String namespacePrefix;
        public String type_x;
        private String[] createdById_type_info = new String[]{'createdById','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdByName_type_info = new String[]{'createdByName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] createdDate_type_info = new String[]{'createdDate','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fileName_type_info = new String[]{'fileName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] id_type_info = new String[]{'id','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedById_type_info = new String[]{'lastModifiedById','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedByName_type_info = new String[]{'lastModifiedByName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] lastModifiedDate_type_info = new String[]{'lastModifiedDate','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] manageableState_type_info = new String[]{'manageableState','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] namespacePrefix_type_info = new String[]{'namespacePrefix','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'createdById','createdByName','createdDate','fileName','fullName','id','lastModifiedById','lastModifiedByName','lastModifiedDate','manageableState','namespacePrefix','type_x'};
    }
    public class listMetadataResponse_element {
        public MetadataService.FileProperties[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
}
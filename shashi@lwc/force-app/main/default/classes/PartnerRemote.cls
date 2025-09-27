public class PartnerRemote 
{
	
    public class getUserInfo_element 
    {
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
    }
    
    public class LoginResult 
    {
        public String metadataServerUrl;
        public Boolean passwordExpired;
        public Boolean sandbox;
        public String serverUrl;
        public String sessionId;
        public String userId;
        public PartnerRemote.GetUserInfoResult userInfo;
        private String[] metadataServerUrl_type_info = new String[]{'metadataServerUrl','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] passwordExpired_type_info = new String[]{'passwordExpired','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] sandbox_type_info = new String[]{'sandbox','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] serverUrl_type_info = new String[]{'serverUrl','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] userInfo_type_info = new String[]{'userInfo','urn:partner.soap.sforce.com','GetUserInfoResult','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'metadataServerUrl','passwordExpired','sandbox','serverUrl','sessionId','userId','userInfo'};
    }
    
    public class loginResponse_element 
    {
        public PartnerRemote.LoginResult result;
        private String[] result_type_info = new String[]{'result','urn:partner.soap.sforce.com','LoginResult','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    
    public class GetUserInfoResult 
    {
        public Boolean accessibilityMode;
        public String currencySymbol;
        public Integer orgAttachmentFileSizeLimit;
        public String orgDefaultCurrencyIsoCode;
        public Boolean orgDisallowHtmlAttachments;
        public Boolean orgHasPersonAccounts;
        public String organizationId;
        public Boolean organizationMultiCurrency;
        public String organizationName;
        public String profileId;
        public String roleId;
        public Integer sessionSecondsValid;
        public String userDefaultCurrencyIsoCode;
        public String userEmail;
        public String userFullName;
        public String userId;
        public String userLanguage;
        public String userLocale;
        public String userName;
        public String userTimeZone;
        public String userType;
        public String userUiSkin;
        private String[] accessibilityMode_type_info = new String[]{'accessibilityMode','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] currencySymbol_type_info = new String[]{'currencySymbol','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] orgAttachmentFileSizeLimit_type_info = new String[]{'orgAttachmentFileSizeLimit','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] orgDefaultCurrencyIsoCode_type_info = new String[]{'orgDefaultCurrencyIsoCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] orgDisallowHtmlAttachments_type_info = new String[]{'orgDisallowHtmlAttachments','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] orgHasPersonAccounts_type_info = new String[]{'orgHasPersonAccounts','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] organizationId_type_info = new String[]{'organizationId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] organizationMultiCurrency_type_info = new String[]{'organizationMultiCurrency','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] organizationName_type_info = new String[]{'organizationName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] profileId_type_info = new String[]{'profileId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] roleId_type_info = new String[]{'roleId','urn:partner.soap.sforce.com','ID','1','1','true'};
        private String[] sessionSecondsValid_type_info = new String[]{'sessionSecondsValid','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] userDefaultCurrencyIsoCode_type_info = new String[]{'userDefaultCurrencyIsoCode','http://www.w3.org/2001/XMLSchema','string','1','1','true'};
        private String[] userEmail_type_info = new String[]{'userEmail','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userFullName_type_info = new String[]{'userFullName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userId_type_info = new String[]{'userId','urn:partner.soap.sforce.com','ID','1','1','false'};
        private String[] userLanguage_type_info = new String[]{'userLanguage','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userLocale_type_info = new String[]{'userLocale','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userName_type_info = new String[]{'userName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userTimeZone_type_info = new String[]{'userTimeZone','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userType_type_info = new String[]{'userType','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] userUiSkin_type_info = new String[]{'userUiSkin','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'accessibilityMode','currencySymbol','orgAttachmentFileSizeLimit','orgDefaultCurrencyIsoCode','orgDisallowHtmlAttachments','orgHasPersonAccounts','organizationId','organizationMultiCurrency','organizationName','profileId','roleId','sessionSecondsValid','userDefaultCurrencyIsoCode','userEmail','userFullName','userId','userLanguage','userLocale','userName','userTimeZone','userType','userUiSkin'};
    }
    
    public class Soap 
    {
        public String endpoint_x = 'https://login.salesforce.com/services/Soap/u/26.0';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'urn:sobject.partner.soap.sforce.com', 'SObjectRemote', 'urn:fault.partner.soap.sforce.com', 'FaultRemote', 'urn:partner.soap.sforce.com', 'PartnerRemote'};

        //public PartnerRemote.LoginResult login(String username, String password) <-- ORIGINAL
        public PartnerRemote.LoginResult login(String username, String password, String strEndPoint)
        {
        	
        	// ADDED 7/16/2013  SET ENDPOINT URL TO ONE PASSED IN =======================================================
        	endpoint_x = strEndPoint;
        	
            PartnerRemote.login_element request_x = new PartnerRemote.login_element();
            PartnerRemote.loginResponse_element response_x;
            request_x.username = username;
            request_x.password = password;
            Map<String, PartnerRemote.loginResponse_element> response_map_x = new Map<String, PartnerRemote.loginResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'urn:partner.soap.sforce.com',
              'login',
              'urn:partner.soap.sforce.com',
              'loginResponse',
              'PartnerRemote.loginResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
  
    public class login_element 
    {
        public String username;
        public String password;
        private String[] username_type_info = new String[]{'username','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] password_type_info = new String[]{'password','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'urn:partner.soap.sforce.com','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }           
    
    /*
    public static testmethod void testFake() 
    {
        new getUserInfo_element();
        new LoginResult();
        new loginResponse_element();
        new GetUserInfoResult();
        new Soap();
        new login_element();
    }
    */
}
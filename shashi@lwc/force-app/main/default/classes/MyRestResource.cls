@RestResource(urlMapping='/Rally/*')
global with sharing class MyRestResource {

    @HttpGet
	global static string doGet()
    {
        Http http1 = new Http();
        HttpRequest request1 = new HttpRequest();
		request1.setMethod('GET');
        request1.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Blob headerValue1 = Blob.valueOf('shashikantn@cybage.com' + ':' + 'Rally@123');
        String authorizationHeader1 = 'Basic  ' + EncodingUtil.base64Encode(headerValue1);      
        request1.setHeader('Authorization', authorizationHeader1);
        String apiKey1 = '_84arjdETS9erMHwoAhg2AvToImyjg0mNrXOMCLiaweA';
        request1.setHeader('ZSESSIONID', apiKey1);

            
		String iteration_name1 = 'XXXXXXXXXX';
        iteration_name1 = iteration_name1.replace(' ', '%20');
        iteration_name1 = iteration_name1.replace(':', '%3A');
        request1.setEndpoint('https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?fetch=Iteration,FormattedId,owner,Description,Name,Blocked,PlanEstimate,TaskEstimateTotal,TaskActualTotal,TaskRemainingTotal,ScheduleState&query=(Name%20%3D%20%22XXXXXXXXXX%22)&start=1&pagesize=200');
        
        HttpResponse response1 = new HttpResponse();
        response1 = http1.send(request1);
        System.debug('response : '+response1.getBody());
        
        return response1.getBody();
    }
}
@isTest 
global class AnimalLocatorMock implements HttpCalloutMock {

    global HttpResponse respond(HTTPRequest request) {
        
        system.debug('request : '+request);
        
		HttpResponse response = new HttpResponse();

		response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animals":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        response.setStatusCode(200);
        return response;         
    }
}
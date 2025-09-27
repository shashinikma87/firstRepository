@isTest 
public class UserStoryCallOutTest {

    @isTest static  void testGetCallout() {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('getUserStory');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        //HttpResponse reponse = UserStoryCallOut.getUserStory('122790960980');
        
        //System.assertNotEquals(null,reponse, 'The callout returned a null response.');
    }
    
    @isTest static void testPostCallout(){
        
        //Test.setMock(HttpCalloutMock.class, new UserStoryMockCallout());
        
        HttpResponse response = UserStoryCallout.updateUserStory('122790960980');
    }
}
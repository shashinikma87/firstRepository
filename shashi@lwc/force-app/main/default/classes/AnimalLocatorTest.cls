@isTest
public class AnimalLocatorTest {

    @isTest static void testPostCallout() {
        
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
        
        String actualValue = AnimalLocator.getAnimalNameById(1);
		String expectedValue = 'chicken';
        System.assertEquals(actualValue, expectedValue);

    }
}
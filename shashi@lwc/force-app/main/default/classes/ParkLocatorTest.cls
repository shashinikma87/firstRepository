@isTest 
public class ParkLocatorTest {

    @isTest static void testCallout() {
        
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        List<String> lst = new List<String>();
        lst.add('Anamudi Shola National Park');
        lst.add('Anshi National Park');
        lst.add('Bandipur National Park');

        //pr = new ParkLocator();
        List<String> ls1 = ParkLocator.country('India');
        
        System.assertEquals(ls1, lst);
    }
}
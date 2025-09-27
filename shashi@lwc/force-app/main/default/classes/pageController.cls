public class pageController {
    public ComponentData theData {get; set;}

    public pageController() {
        theData = new ComponentData();
        //system.debug('///'+ theData);
    }
    
    public void getData()
    {
        system.debug('theData : '+theData);
    }
}
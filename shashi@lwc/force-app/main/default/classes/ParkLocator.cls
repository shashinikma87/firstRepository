public class ParkLocator {

    public static List<String> country (String cnt_name) {
    
        ParkService.ParksImplPort park = new ParkService.ParksImplPort();
    
        List<String> parks_list = park.byCountry (cnt_name);
        
        return parks_list;
    }
}
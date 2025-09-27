public class DTTBTry2 {

    public static String name {get; set;}
    public DTTBTry2()
    {
        name = 'XYZ';
    }
    
    @RemoteAction
    public static String getName(String ipVal)
    {
        system.debug('passParam : '+ipVal);
        name = 'ABC';
        return name;
    }
}
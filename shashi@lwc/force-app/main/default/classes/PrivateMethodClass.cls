public class PrivateMethodClass {

    private String personalName = 'ABC';
    protected String nickName = 'DEF';
    public string publicString = 'public string';
    
    public PrivateMethodClass(){
        
        system.debug('in constructor : '+personalName);
        system.debug('in constructor nickName : '+nickName);
        retrievePersonalName();
    }
    
    private void retrievePersonalName(){
        
        system.debug('in retrievePersonalName : '+personalName);
        
        innerClass1 i = new innerClass1();
    }
    
    /*protected void retrieveNickName(){
        
        system.debug('in retrieveNickName nickName : '+nickName);
    }*/
    
    
    public class innerClass1 {
        
        public innerClass1(){
        	//system.debug('in inner class publicString : '+publicString);
        }
    }
}
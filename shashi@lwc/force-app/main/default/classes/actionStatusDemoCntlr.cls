public class actionStatusDemoCntlr {

    Integer count = 0;
                        
    public PageReference incrementCounter() {
            count++;
            return null;
    }
                    
    public Integer getCount() {
        return count;
    }
}

//sfcertdaysptnfsl1116
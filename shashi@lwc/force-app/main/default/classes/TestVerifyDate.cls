@isTest
private class TestVerifyDate {

    @isTest static void testCheckDates_1(){
        
        Date Date1 = Date.newInstance(2017, 1, 1);
        Date Date2 = Date.newInstance(2017, 1, 15);
        System.Debug(Date2);
        Date result_date = VerifyDate.CheckDates(Date1,Date2);
        System.assertEquals(Date2, result_date);
    }
    
    @isTest static void testCheckDates_2(){
        
        Date Date1 = Date.newInstance(2017, 1, 1);
        Date Date2 = Date.newInstance(2017, 2, 15);
        
        Date Date3 = Date.newInstance(2017, 1, 31);
        
        Date result_date = VerifyDate.CheckDates(Date1,Date2);
        System.assertEquals(Date3, result_date);
    }
}
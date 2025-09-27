@isTest 
private class TaskUtilTest {

    @isTest static void testTaskPriorityInvalid () {
        String str = TaskUtil.getTaskPriority('TT');
        System.assertEquals('Normal',str);
    }
    
    @isTest static void testHighPriority() {
        String str = TaskUtil.getTaskPriority('CA');
        System.assertEquals('High',str);        
    }
    
	@isTest static void testNormalPriority() {
        String str = TaskUtil.getTaskPriority('NA');
        System.assertEquals('Normal',str);
    }
    
    @isTest static void testNullPriority() {
        String str = TaskUtil.getTaskPriority('');
        System.assertEquals(NULL,str, 'No parameters passed.');
    }
    
    
}
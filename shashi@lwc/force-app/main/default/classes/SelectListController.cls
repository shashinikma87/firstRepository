public with sharing class SelectListController {
      public SelectListController(){
            TestValue=2011;
      }
      public PaginatedSelectList TestList{
        get{
            if(TestList==null){
                  TestList=new PaginatedSelectList();
                  for(Integer i=1;i<=20000;i++){
                        TestList.add(new SelectOption(i+'',i+''));
                  }
            }
            return TestList;
        }
        set;
    }
    public Integer TestValue{
      get;
      set;
    }
}
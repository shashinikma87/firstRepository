public class listController{    
    public String selMenu{get;set;}
    public boolean isMenuSel1{get;set;}
    public boolean isMenuSel2{get;set;}
    public boolean isMenuSel3{get;set;}
    public boolean isMenuSel4{get;set;}

    public listController(){
        isMenuSel1=false;
    }
    public List<SelectOption> getMenus(){    

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Menu1','Menu 1'));
        options.add(new SelectOption('Menu2','Menu 2'));
        options.add(new SelectOption('Menu3','Menu 3'));
        options.add(new SelectOption('Menu4','Menu 4'));
        return options;
    }

    public void checkSelMenu(){
        if(selMenu == 'Menu1')
          isMenuSel1= true;
        else if(selMenu == 'Menu2')
          isMenuSel2= true;
        else if(selMenu == 'Menu3')
          isMenuSel3= true;
        else if(selMenu == 'Menu4')
          isMenuSel4= true;
    }
}
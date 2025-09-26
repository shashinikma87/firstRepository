public class CompController {
    public ComponentData cData {get;set;}

    public string searchText {get;set;}

    public void updateData(){
         cData.theInput = searchText + '-' + 'a1';
        cData.theOutput = searchText + '-' + 'b1';
    }
}
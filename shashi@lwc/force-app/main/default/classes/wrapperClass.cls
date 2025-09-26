public class wrapperClass {
    public String accinp { get; set; }
    public list<account>accs = new list<account>();
    public list<accountwrapper>accwrap{get; set;}
    public list<account>selectedaccount{get; set;}
    public account anacc{get; set;}
    public void Changetype(){
        for(account ac:selectedaccount){
            ac.type=anacc.type;
        }
        if(anacc.Price__c<400){
            update selectedaccount;
        }else{
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,'This is only applicable for Price less than 400…..'));
        }
    }
    public wrapperClass(){
        accwrap=new list<accountwrapper>();
        anacc= new account();
        accs= [select name, Ownerid, Website, Type,Price__c from account where website != null order by createddate desc limit 100];
        accountWrapperObject();
    }
    public void accountWrapperObject(){
        for(account a:accs){
            accountwrapper aw = new accountwrapper(a);
            accwrap.add(aw);
        }
    }
    public void getselected(){
        selectedaccount = new list<account>();
        selectedaccount.clear();
        for(accountwrapper awrap:accwrap)
            if(awrap.selected==true){
                selectedaccount.add(awrap.acc);
            }
    }
    public class accountwrapper{
        public account acc{get; set;}
        public boolean selected{get; set;}
        public accountWrapper(account a){
            acc=a;
            selected= false;
        }
    }
}
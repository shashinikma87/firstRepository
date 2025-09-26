public class pageTableDemoCntlr {

    public List<Account> actList {get; set;}
    public boolean reRenderedPB2 {get; set;}
    
    public pageTableDemoCntlr ()
    {
        reRenderedPB2 = false;
        actList = new List<Account>();
        
        actList = [select Id, name from Account];
    }
    
    public void clickMe()
    {
        reRenderedPB2 = true;
    }
        
}

/*
<apex:page controller="pageTableDemoCntlr">

    <apex:stylesheet value="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css"/>
    <apex:includescript value="https://code.jquery.com/jquery-3.3.1.js"/>
    <apex:includescript value="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"/>
    
    <script type="text/javascript">
        function format ( d ) {
            // d is the original data object for the row
            return '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">'+
                '<tr>'+
                    '<td>Full name:</td>'+
                    '<td>'+d.name+'</td>'+
                '</tr>'+
                '<tr>'+
                    '<td>Extension number:</td>'+
                    '<td>'+d.extn+'</td>'+
                '</tr>'+
                '<tr>'+
                    '<td>Extra info:</td>'+
                    '<td>And any further details here (images etc)...</td>'+
                '</tr>'+
            '</table>';
        }
 
        $(document).ready(function() {
            var table = $('#example').DataTable( {
                // "ajax": "../ajax/data/objects.txt",
                "bPaginate"	:	true,
                
                "order": [[1, 'asc']]
            } );
             
            // Add event listener for opening and closing details
            $('#example tbody').on('click', 'td.details-control', function () {
                var tr = $(this).closest('tr');
                var row = table.row( tr );
         
                if ( row.child.isShown() ) {
                    // This row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                }
                else {
                    // Open this row
                    row.child( format(row.data()) ).show();
                    tr.addClass('shown');
                }
            } );
        } );
    
    </script>
    
    
    
    <apex:form >
        
        <apex:pageBlock >
            <apex:pageBlockSection title="Retrieved Billing Contract Line Items" id="dataSection" columns="1" >
                
                <table id="example" class="display" style="width:100%">
                    <thead>
                        <tr>
                            <th>Account ID</th>
                            <th>Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <apex:repeat value="{!actList}"  var="wrapper">
                            <tr>
                                <td>{!wrapper.id}</td>
                                <td>{!wrapper.name}</td>
                            </tr>
                        </apex:repeat>
                    </tbody>
                </table>
                
            </apex:pageBlockSection>
        </apex:pageBlock>

    </apex:form>
</apex:page>
*/
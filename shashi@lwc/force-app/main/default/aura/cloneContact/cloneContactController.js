({
	
    handleCreateContact: function(component, event, helper){
        
        alert('firstName : '+component.get("v.simpleNewContact.FirstName") + ' lastName : '+component.get("v.simpleNewContact.LastName") +' email : '+component.get("v.simpleNewContact.Email"));
        
        
        var action = component.get("c.createContact");
        action.setParams({
            "cnt":component.get("v.simpleNewContact")
        });
        
       
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('State : '+state);
            if(state==='SUCCESS')
            {
                var newContactID = a.getReturnValue();
                alert('Return value : '+newContactID);
                //component.set("v.simpleNewContact",returnedCnt)
                
                // toast with error message - dismissible
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "type" : "Success",
                    "message": "New contact has been created successfully."
                });
                toastEvent.fire();
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/"+newContactID
                });
                urlEvent.fire();
                
            }
            else
            {
                // toast with error message - dismissible
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "Error",
                    "message": "Error..........",
                    "mode": "dismissible"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
        
    }
    
    ,
    
      handleSubmit: function (cmp, event, helper) {
        event.preventDefault(); // stop form submission
  var eventFields = event.getParam("fields");
          console.log(eventFields["Department"]);
 // eventFields["FirstName"] = "Test Value";
 
 // cmp.find('myform').submit(eventFields);
         
  		var action = cmp.get("c.createContact");
        action.setParams({
            "cnt":eventFields
        });
        
       
        action.setCallback(this, function(a) {
            var state = a.getState();
           
            if(state==='SUCCESS')
            {
               
                
            }
            
        });
        $A.enqueueAction(action);
          
          
    },

    handleError: function (cmp, event, helper) {
        cmp.find('notifLib').showToast({
            "title": "Something has gone wrong!",
            "message": event.getParam("message"),
            "variant": "error"
        });
    }

})
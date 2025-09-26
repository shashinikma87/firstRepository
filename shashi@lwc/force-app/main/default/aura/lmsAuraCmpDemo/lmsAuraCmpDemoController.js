({
    publishMC: function(cmp, event, helper) {
        var message = {
            recordId: "some string",
            recordData: { value: "some value" }
        };
        cmp.find("myMessageChannel").publish(message);
    },

    handleMessage: function(cmp, message, helper) { 
        // Read the message argument to get the values in the message payload
        if (message != null && message.getParam("recordData") != null) {
            cmp.set("v.recordValue", message.getParam("recordData").value);
        }
    }

})
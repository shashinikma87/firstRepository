({
	doInit : function(component, event, helper) {
		var url='/apex/cloneOpp?id='+component.get("v.recordId")+'&flagOfRt=false&rt=';
        alert(url);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url,
            "isredirect": "true"
        });
        urlEvent.fire();
	}
})
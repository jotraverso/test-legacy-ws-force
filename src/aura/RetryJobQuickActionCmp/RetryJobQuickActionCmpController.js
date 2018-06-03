({
    doInit: function(component, event, helper) {
    	debugger;
        var action = component.get("c.retryJob");
        action.setParams({ "qmId": component.get("v.recordId") });
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                document.getElementById('resultArea').innerHTML = '<h2>' + response.getReturnValue() + '</h2>';
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})
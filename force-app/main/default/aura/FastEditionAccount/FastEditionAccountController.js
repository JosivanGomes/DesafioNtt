({
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Sucesso!",
            "message": "O registro atual foi atualizado."
        });
        toastEvent.fire();

        $A.get('e.force:refreshView').fire();
    }
})
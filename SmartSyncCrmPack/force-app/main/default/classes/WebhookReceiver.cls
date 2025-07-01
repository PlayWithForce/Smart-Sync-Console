global class WebhookReceiver {
    global class Input {
        @InvocableVariable(required=true)
        public String jsonPayload;

        @InvocableVariable
        public Id insightId;

        @InvocableVariable
        public String insightName;
    }

    @InvocableMethod(label='Receive JSON from Flow')
    global static void handle(List<Input> inputs) {
        try {
            List<Smart_Sync_Stage__c> lstCiStage = new List<Smart_Sync_Stage__c>();
            for (Input input : inputs) {
                System.debug('JSON Received from Flow: ' + input.jsonPayload);
                System.debug('Insight Id: ' + input.insightId);
                System.debug('Insight Name: ' + input.insightName);

                Smart_Sync_Stage__c ciStage = new Smart_Sync_Stage__c();
                ciStage.Increment_Data__c = input.jsonPayload;
                ciStage.Insight_Id__c = input.insightId;
                ciStage.Insight_Name__c = input.insightName;

                lstCiStage.add(ciStage);
            }
            insert lstCiStage;
        } catch (Exception ex) {
            System.debug('Error in WebhookReceiver: ' + ex.getMessage());
        }
    }
}
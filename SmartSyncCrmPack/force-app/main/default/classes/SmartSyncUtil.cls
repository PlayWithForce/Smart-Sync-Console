public with sharing class SmartSyncUtil {
/*
    @InvocableMethod(label='Stage Insights to SmartSync')
    public static void stageInsights(List<Insights> inputList) {
        system.debug('SmartSyncUtil'+inputList);
        if (inputList == null || inputList.isEmpty()) return;

        List<Smart_Sync_Stage__c> stageRecords = new List<Smart_Sync_Stage__c>();

        for (Insights input : inputList) {
            if (input == null || input.entireResource == null) continue;

            
            stageRecords.add(new Smart_Sync_Stage__c(
                
                Insight_Name__c   = input.Name,
                Increment_Data__c = serialized
            ));
        }

        if (!stageRecords.isEmpty()) {
            insert stageRecords;
        }
    }*/
}
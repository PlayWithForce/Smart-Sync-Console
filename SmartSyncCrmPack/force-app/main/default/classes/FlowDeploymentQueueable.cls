public class FlowDeploymentQueueable implements Queueable {
    String objectApiName;    
    List<String> fieldApiNames;
	String apexActionClassName= 'WebhookReceiver';
    String cleanObject ='';
    String flowApiName = '';
    public FlowDeploymentQueueable(
        String objectApiName,
        List<String> fieldApiNames
    ) {
        this.objectApiName = objectApiName;
        this.fieldApiNames = fieldApiNames;
    }

    public void execute(QueueableContext context) {
        try {
            cleanObject = objectApiName.replace('__cio', '');
            flowApiName = 'SmartSync_' + cleanObject;
            // 1. Generate Flow XML
            String xml = DataCloudFlowGenerator.generateFlowXml(
                objectApiName,
                fieldApiNames,
                flowApiName,
                apexActionClassName
            );

            // 2. Build zip
            Blob zipBlob = FlowZipDeploy.buildFlowMetadataZip(flowApiName, xml);

            // 3. Deploy the zip via Metadata API callout
            FlowDeployer.deployZipToMetadataApi(zipBlob);
        } catch (Exception e) {
            System.debug('❌ Queueable Deployment Failed: ' + e.getMessage());
        }
    }
}
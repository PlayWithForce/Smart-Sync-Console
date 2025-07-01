public class FlowAutoDeployer {
    @InvocableMethod(label='Generate and Deploy Flow')
    public static List<String> run(List<Request> requests) {
        List<String> results = new List<String>();
		String apexActionClassName= 'WebhookReceiver';
        String cleanObject ='';
        String flowApiName = '';
        for (Request req : requests) {
            try {
                cleanObject = req.objectApiName.replace('__cio', '');
        		flowApiName = 'SmartSync_' + cleanObject;
                // 1. Generate XML
                String xml = DataCloudFlowGenerator.generateFlowXml(
                    req.objectApiName,
                    req.fieldApiNames,
                    flowApiName,
                    apexActionClassName
                );

                // 2. Package ZIP
                Blob zipBlob = FlowZipDeploy.buildFlowMetadataZip(flowApiName, xml);

                // 3. Save to Files (optional)
                //FlowZipDeploy.saveZipToFiles(req.flowApiName, zipBlob);

                // 4. Deploy
                FlowDeployer.deployZipToMetadataApi(zipBlob);

                results.add('Deployed: ' + flowApiName);
            } catch (Exception ex) {
                results.add('Failed: ' + flowApiName + ' - ' + ex.getMessage());
            }
        }

        return results;
    }

    public class Request {
        @InvocableVariable(label='Object API Name' required=true)
        public String objectApiName;

        @InvocableVariable(label='Field API Names (comma-separated)' required=true)
        public List<String> fieldApiNames;
    }
}
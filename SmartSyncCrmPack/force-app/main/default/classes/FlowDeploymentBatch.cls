/*
List<FlowDeploymentBatch.Input> inputs = new List<FlowDeploymentBatch.Input>();

FlowDeploymentBatch.Input input1 = new FlowDeploymentBatch.Input();
input1.objectApiName = 'Warranty_Parts_Per_Claims__cio';
input1.fieldApiNames = new List<String>{ 'number_of_inst_part__c', 'claim_numnber__c' };
inputs.add(input1);

FlowDeploymentBatch.Input input2 = new FlowDeploymentBatch.Input();
input2.objectApiName = 'Some_Other_Insight__cio';
input2.fieldApiNames = new List<String>{ 'score__c', 'segment__c' };
inputs.add(input2);

// Execute the batch with scope size 1 (or adjust as needed)
Database.executeBatch(new FlowDeploymentBatch(inputs), 1);


 */
public class FlowDeploymentBatch implements Database.Batchable<FlowDeploymentBatch.Input>, Database.Stateful,Database.AllowsCallouts {

    public class Input {
        public String objectApiName;
        public List<String> fieldApiNames;
    }

    private List<Input> inputs;

    public FlowDeploymentBatch(List<Input> inputs) {
        this.inputs = inputs;
    }

    public Iterable<Input> start(Database.BatchableContext context) {
        return inputs;
    }

    public void execute(Database.BatchableContext context, List<Input> scope) {
        for (Input req : scope) {
            try {
                String cleanObject = req.objectApiName.replace('__cio', '');
                String flowApiName = 'SmartSync_' + cleanObject;

                String flowXml = DataCloudFlowGenerator.generateFlowXml(
                    req.objectApiName,
                    req.fieldApiNames,
                    flowApiName,
                    'WebhookReceiver'
                );

                Blob zipBlob = FlowZipDeploy.buildFlowMetadataZip(flowApiName, flowXml);
                //FlowZipDeploy.saveZipToFiles(flowApiName, zipBlob);

                FlowDeployer.deployZipToMetadataApi(zipBlob);
            } catch (Exception e) {
                System.debug('Error deploying flow for object: ' + req.objectApiName + ' => ' + e.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Flow deployments completed.');
    }
}
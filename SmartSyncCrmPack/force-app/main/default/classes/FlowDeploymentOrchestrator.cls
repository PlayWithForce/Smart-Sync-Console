public class FlowDeploymentOrchestrator {
    public static String NAMED_CREDENTIAL = 'MetadataApi';

    public static void deployFlow(String flowApiName, String flowXml) {
        // Step 1: Build ZIP
        Blob zipBlob = FlowZipBuilder.buildFlowZip(flowApiName, flowXml);

        // Step 2: Base64 encode
        String base64Zip = EncodingUtil.base64Encode(zipBlob);

        // Step 3: Build SOAP envelope
        String soapEnvelope = buildSoapDeployEnvelope(base64Zip);

        // Step 4: Send Metadata API call
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NAMED_CREDENTIAL);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setBody(soapEnvelope);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new CalloutException('Deployment failed: ' + res.getBody());
        }

        System.debug('Deployment Success:\n' + res.getBody());
    }

    private static String buildSoapDeployEnvelope(String base64Zip) {
        return '<?xml version="1.0" encoding="UTF-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
            'xmlns:met="http://soap.sforce.com/2006/04/metadata">' +
            '<soapenv:Header>' +
            '<met:CallOptions><met:client>FlowDeploy</met:client></met:CallOptions>' +
            '</soapenv:Header>' +
            '<soapenv:Body>' +
            '<met:deploy>' +
            '<met:ZipFile>' + base64Zip + '</met:ZipFile>' +
            '<met:DeployOptions>' +
            '<met:performRetrieve>false</met:performRetrieve>' +
            '<met:rollbackOnError>true</met:rollbackOnError>' +
            '<met:singlePackage>true</met:singlePackage>' +
            '</met:DeployOptions>' +
            '</met:deploy>' +
            '</soapenv:Body>' +
            '</soapenv:Envelope>';
    }
}
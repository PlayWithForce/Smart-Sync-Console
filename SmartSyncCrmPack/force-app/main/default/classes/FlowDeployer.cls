public class FlowDeployer {
    public static void deployZipToMetadataApi(Blob zipBlob) {
        String envelope = buildSoapEnvelope(zipBlob);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:MetadataApiNamedCredential/services/Soap/m/60.0');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', '""'); // Required header
        req.setBody(envelope);

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Deployment Response: ' + res.getBody());
    }

    private static String buildSoapEnvelope(Blob zipBlob) {
        String base64Zip = EncodingUtil.base64Encode(zipBlob);
        return
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
            'xmlns:met="http://soap.sforce.com/2006/04/metadata">' +
            '<soapenv:Header>' +
            '<met:SessionHeader>' +
            '<met:sessionId>' + UserInfo.getSessionId() + '</met:sessionId>' +
            '</met:SessionHeader>' +
            '</soapenv:Header>' +
            '<soapenv:Body>' +
            '<met:deploy>' +
            '<met:ZipFile>' + base64Zip + '</met:ZipFile>' +
            '<met:DeployOptions>' +
            '<met:performRetrieve>false</met:performRetrieve>' +
            '<met:rollbackOnError>true</met:rollbackOnError>' +
            '<met:checkOnly>false</met:checkOnly>' +
            '<met:singlePackage>true</met:singlePackage>' +
            '</met:DeployOptions>' +
            '</met:deploy>' +
            '</soapenv:Body>' +
            '</soapenv:Envelope>';
    }
}
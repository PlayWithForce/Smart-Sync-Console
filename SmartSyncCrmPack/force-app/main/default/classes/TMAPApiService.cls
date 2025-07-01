public class TMAPApiService {
    public class AttachmentAPIResponse {
        public List<Blob> files;
    }
	@future(callout=true)
    public static void callExternalApi() {
        // Define the endpoint URL of the external API
        //String endpoint = 'https://tmap-webapp-warranty-copilot-dev.azurewebsites.net/claim_attachments';
		String endpoint ='https://tmap-webapp-warranty-copilot-dev.azurewebsites.net/claim_summary';
        // Create a new HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
		req.settimeout(120);
        // Create the JSON body for the request
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('claim_no', 'A3515401');
        requestBody.put('index', 'claims-data-syn-index');
        requestBody.put('history', new List<Map<String, String>>{ new Map<String, String>{ 'user' => 'A3515401' } });
        requestBody.put('deployment', 'GPT4');

        // Convert the body to JSON string
        String jsonBody = JSON.serialize(requestBody);

        // Set the body of the request
        req.setBody(jsonBody);

        // Create a new HTTP client
        Http http = new Http();

        try {
            // Send the request and get the response
            HttpResponse res = http.send(req);

            // Process the response
            if (res.getStatusCode() == 200) {
                //System.debug('Response: ' + res.getBody());
                system.assertequals('resp=>',res.getBody());
                // Parse the JSON response
                List<Object> responseList = (List<Object>) JSON.deserializeUntyped(res.getBody());
                /*AttachmentAPIResponse apiResponse = (AttachmentAPIResponse)JSON.deserialize(res.getBody(), AttachmentAPIResponse.class);
                List<Blob> blobList = apiResponse.files;
                
                // Do something with the list of Blob
                for (Blob fileBlob : blobList) {
                    System.debug('Blob: ' + fileBlob);
                }*/
            } else {
                System.debug('Error: ' + res.getStatus());
                // Handle the error response
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            // Handle any exceptions
        }
    }
}
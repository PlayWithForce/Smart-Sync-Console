public class FlowZipDeploy {
    public static Blob buildFlowMetadataZip(String flowApiName, String flowXml) {
        Compression.ZipWriter zip = new Compression.ZipWriter();

        // Add flow metadata XML
        zip.addEntry('flows/' + flowApiName + '.flow-meta.xml', Blob.valueOf(flowXml));

        // Add package.xml
        String packageXml =
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' +
            '  <types>' +
            '    <members>' + flowApiName + '</members>' +
            '    <name>Flow</name>' +
            '  </types>' +
            '  <version>60.0</version>' +
            '</Package>';

        zip.addEntry('package.xml', Blob.valueOf(packageXml));

        return zip.getArchive();
    }

    public static Id saveZipToFiles(String name, Blob zipBlob) {
        ContentVersion cv = new ContentVersion();
        cv.Title = name + '_Deploy';
        cv.PathOnClient = name + '.zip';
        cv.VersionData = zipBlob;
        cv.IsMajorVersion = true;
        insert cv;
        return cv.Id;
    }

    @InvocableMethod(label='Build and Save Flow ZIP')
    public static List<Id> run(List<Request> requests) {
        List<Id> result = new List<Id>();
        for (Request r : requests) {
            Blob zipBlob = buildFlowMetadataZip(r.flowApiName, r.flowXml);
            result.add(saveZipToFiles(r.flowApiName, zipBlob));
        }
        return result;
    }

    public class Request {
        @InvocableVariable(required=true)
        public String flowApiName;
        @InvocableVariable(required=true)
        public String flowXml;
    }
}
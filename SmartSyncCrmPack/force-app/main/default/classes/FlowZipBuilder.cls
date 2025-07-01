public class FlowZipBuilder {
    public static Blob buildFlowZip(String flowApiName, String flowXmlString) {
        try {
            String fileName = 'flows/' + flowApiName + '.flow-meta.xml';
            Blob contentBlob = Blob.valueOf(flowXmlString);
            String crc = CRC32Util.computeCRC32(contentBlob);

            Zippex zip = new Zippex();
            zip.addFile(fileName, contentBlob, crc);
            return zip.getZipArchive(); // Ensures Blob is always returned

        } catch (Exception ex) {
            System.debug('Error generating ZIP: ' + ex.getMessage());
            return Blob.valueOf(''); // Return empty Blob on failure
        }
    }
}
public class DataCloudFlowGenerator {
    public static String generateFlowXml(
        String objectApiName,
        List<String> fieldApiNames,
        String flowApiName,
        String apexActionClassName
    ) {
        // Build JSON body from record fields
        String jsonBody = '{';
        for (Integer i = 0; i < fieldApiNames.size(); i++) {
            String field = fieldApiNames[i];
            jsonBody += '"' + field + '": "{!$Record.' + field + '}"';
            if (i < fieldApiNames.size() - 1) {
                jsonBody += ', ';
            }
        }
        jsonBody += '}';

        // Build Flow XML
        String xml =
            '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<Flow xmlns="http://soap.sforce.com/2006/04/metadata">\n' +
            '  <apiVersion>60.0</apiVersion>\n' +
            '  <label>' + flowApiName + '</label>\n' +
            '  <processMetadataValues>\n' +
            '    <name>BuilderType</name>\n' +
            '    <value><stringValue>LightningFlowBuilder</stringValue></value>\n' +
            '  </processMetadataValues>\n' +
            '  <processMetadataValues>\n' +
            '    <name>CanvasMode</name>\n' +
            '    <value><stringValue>AUTO_LAYOUT_CANVAS</stringValue></value>\n' +
            '  </processMetadataValues>\n' +
            '  <processMetadataValues>\n' +
            '    <name>OriginBuilderType</name>\n' +
            '    <value><stringValue>LightningFlowBuilder</stringValue></value>\n' +
            '  </processMetadataValues>\n' +
            '  <processType>AutoLaunchedFlow</processType>\n' +

            // Text Template
            '  <textTemplates>\n' +
            '    <name>JsonPayloadTemplate</name>\n' +
            '    <text>' + jsonBody + '</text>\n' +
            '  </textTemplates>\n' +

            // Apex Action Call
            '  <actionCalls>\n' +
            '    <name>Send_Json</name>\n' +
            '    <label>Send JSON</label>\n' +
            '    <actionType>apex</actionType>\n' +
            '    <actionName>' + apexActionClassName + '</actionName>\n' +
            '    <inputParameters>\n' +
            '      <name>jsonPayload</name>\n' +
            '      <value>\n' +
            '        <elementReference>JsonPayloadTemplate</elementReference>\n' +
            '      </value>\n' +
            '    </inputParameters>\n' +
            '    <inputParameters>\n' +
            '      <name>insightId</name>\n' +
            '      <value>\n' +
            '        <elementReference>{!$User.Id}</elementReference>\n' +
            '      </value>\n' +
            '    </inputParameters>\n' +
            '    <inputParameters>\n' +
            '      <name>insightName</name>\n' +
            '      <value>\n' +
            '        <stringValue>'+objectApiName.replace('__cio','')+'</stringValue>\n' +
            '      </value>\n' +
            '    </inputParameters>\n' +
            '    <locationX>150</locationX>\n' +
            '    <locationY>150</locationY>\n' +
            '  </actionCalls>\n' +

            // Start Node
            '  <start>\n' +
            '    <object>' + objectApiName + '</object>\n' +
            '    <recordTriggerType>CreateAndUpdate</recordTriggerType>\n' +
            '    <triggerType>DataCloudDataChange</triggerType>\n' +
            '    <connector>\n' +
            '      <targetReference>Send_Json</targetReference>\n' +
            '    </connector>\n' +
            '    <locationX>0</locationX>\n' +
            '    <locationY>0</locationY>\n' +
            '  </start>\n' +
            '  <status>Active</status>\n' +
            '</Flow>';

        return xml;
    }
}
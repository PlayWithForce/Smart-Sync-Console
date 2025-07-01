public class DataCloudUtils {

    @InvocableMethod(label='Insert Claim Parts' description='Update Installment part in case claim exists, if not, then add')
    public static void insertInstParts(
        List<String> ClaimIDs) {
            string searchKey = '[ClaimID__c=' +ClaimIDs[0] +']';
        ConnectApi.CdpQueryOutput response = connectAPI.CdpQuery.queryCalculatedInsights(
                    'ClaimParts__cio', // api name of the calculated insight ending with __cio, example totalpowergenerated__cio
                    null, // Comma-separated list of up to 10 dimensions, such as EnergyProduced__c. If unspecified, this parameter includes all of the available dimensions.
                    null, // Comma-separated list of up to 5 measures, such as TotalEnergyProduced__c. If unspecified, this parameter includes all of the available measures.
                    null, // Sort order for the result set
                    searchKey, // Filter the result set to a more narrow scope or specific type
                    10, // Number of items to return. Values are from 1–4,999. If unspecified, the default value is 4999.
                    null // Number of rows to skip before returning results. If unspecified, no rows are skipped.
        );
        List<InstalledPart__c> ipList = [Select id from InstalledPart__c where ClaimID__c IN:ClaimIDs];
			List<Object> objLst=  response.data;
            //dataCloudUtils.getProfileData('ClaimParts__cio','[ClaimID__c=' +claimid +']');
			List<String> lineItems = new List<String>();
            for (object o : objLst) {
                string jsonStr = JSON.serialize(o);
                Map<String,Object> ciRec = (Map<String,Object>)JSON.deserializeUntyped(jsonStr);
                if(string.isNotEmpty((String)ciRec.get('pdesc__c'))){
                    lineItems.add((String)ciRec.get('pdesc__c'));
                }   
            }
            
            if(lineItems.size()>0){
            	string instParts = String.join(lineItems, ',');
                InstalledPart__c ip = new InstalledPart__c();
                ip.ClaimID__c = ClaimIDs[0];
                ip.INS_Parts__c = instParts;
                if(ipList.size()>0){
                    ipList[0].INS_Parts__c = instParts;
                	update ipList;    
                }else{
                    insert ip;
                }
                
            }
            

    }

}
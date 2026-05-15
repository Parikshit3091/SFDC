@RestResource(urlMapping='/GetInfo/*')
global class AccountContactInfoRest {

    @HttpGet
    global static void getAccountContactInfo(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
    	String jsonResponse = '';
        
        String accName = req.params.get('name');
        System.debug('accName ### ' + accName);
        try{
        	Account acc = [select a.Id,a.Name,a.AccountNumber,a.Phone,a.Site,(select Id,FirstName,LastName,Department from Contacts) from account a where name like :accName and Active__c != 'No' limit 1];    
            //System.debug(acc.BillingCity);
            if(acc != null){
                res.statusCode = 200;
                AccContactResponse.AccountWrapper resp = AccContactResponse.prepareResponse(new List<Account>{acc});
                jsonResponse = '{"response" : {"status" : "Success", "data" : '+ JSON.serialize(resp) +'}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }else{
                res.statusCode = 400;
                jsonResponse = '{"response": {"status": "Failure", "message": "No account matching account_name was found"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
        }catch(Exception ex){
            res.statusCode = 400;
            jsonResponse = '{"response" : {"status" : "Failure", "message" : '+ JSON.serialize(ex.getMessage()) +'}}';
            res.responseBody = Blob.valueOf(jsonResponse);
            return;
        }
    }
}
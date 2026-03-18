@isTest
private class GetAccountByIdAPITest {

    @isTest
     public static void TestgetAccountSuccess() {
         
         Account acc =new Account(
         Name='accAPI',
         Industry='Banking'
         );
         insert acc;
         
          // Create REST Request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/getAccount/' + acc.Id;
        req.httpMethod = 'GET';

        // Set Rest Context
        RestContext.request = req;
        RestContext.response = res;
         
         Test.startTest();
        GetAccountByIdAPI.getAccount();
        Test.stopTest();
}
     
     @isTest
     public static void TestgetAccountfail() {
         
          // Create REST Request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/v1/account/001000000000000AAA';
        req.httpMethod = 'GET';

        // Set Rest Context
        RestContext.request = req;
        RestContext.response = res;
         
         Test.startTest();
        GetAccountByIdAPI.getAccount();
        Test.stopTest();
}
     

}
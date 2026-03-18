@RestResource(urlMapping='/v1/account/*')
global with sharing class GetAccountByIdAPI {

    @HttpGet
    global static String getAccount() {

        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        try {
            String uri = RestContext.request.requestURI;
            system.debug('this is postman url :'+uri);
            String accountId = uri.substringAfterLast('/');

            Account acc = [
                SELECT Id, Name, Industry
                FROM Account
                WHERE Id = :accountId
                LIMIT 1
            ];

            return JSON.serialize(new Map<String, Object>{
                'status' => 'SUCCESS',
                'record' => new Map<String, Object>{
                    'Id' => acc.Id,
                    'Name' => acc.Name,
                    'Industry' => acc.Industry
                }
            });

        } catch (Exception e) {
            res.statusCode = 404;
            return JSON.serialize(new Map<String, String>{
                'status' => 'ERROR',
                'message' => 'Account not found'
            });
        }
    }
}
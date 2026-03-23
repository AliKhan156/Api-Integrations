@RestResource(urlMapping='/v1/account-with-contacts')
global with sharing class AccountWithContactsInsertAPI {

    /* ========= REQUEST WRAPPER ========= */
    global class ContactRequest {
        public String firstName;
        public String lastName;
        public String email;
    }

    global class AccountRequest {
        public String accountName;
        public List<ContactRequest> contacts;
    }

    /* ========= RESPONSE WRAPPER ========= */
    global class ApiResponse {
        public String status;
        public String message;
        public Id accountId;
        public List<Id> contactIds;
    }

    /* ========= POST METHOD ========= */
    @HttpPost
    global static ApiResponse createAccountWithContacts() {

        ApiResponse response = new ApiResponse();

        try {

            // STEP 1: Deserialize request
            AccountRequest req = (AccountRequest)
                JSON.deserialize(
                    RestContext.request.requestBody.toString(),
                    AccountRequest.class
                );

            if (String.isBlank(req.accountName)) {
                response.status = 'FAILED';
                response.message = 'Account Name is required';
                return response;
            }

            // STEP 2: Create Account
            Account acc = new Account(Name = req.accountName);
            insert acc;

            // STEP 3: Create Contacts
            List<Contact> contactList = new List<Contact>();
            List<Id> contactIds = new List<Id>();

            if (req.contacts != null) {
                for (ContactRequest cReq : req.contacts) {

                    Contact c = new Contact(
                        FirstName = cReq.firstName,
                        LastName = cReq.lastName,
                        Email = cReq.email,
                        AccountId = acc.Id
                    );

                    contactList.add(c);
                }

                insert contactList;

                for (Contact c : contactList) {
                    contactIds.add(c.Id);
                }
            }

            // STEP 4: Response
            response.status = 'SUCCESS';
            response.message = 'Account and Contacts Created';
            response.accountId = acc.Id;
            response.contactIds = contactIds;

        } catch (Exception e) {

            response.status = 'ERROR';
            response.message = e.getMessage();
        }

        return response;
    }
}

# Ruyb Sinatra Api

### Multiple Endpoints Project

* No UI required
* No database implementation required (a simple service or similar that mocks out data would suffice for this exercise)
* Any kind of NoSQL implementation a bonus
* The only technology requirement is the use of Ruby without leveraging Rails. Any subset of Rails can certainly be leveraged thou if beneficial.
* Otherwise the technology stack is completely open-ended with the use of any gems necessary

#### User fields supported via the API: (feel free to add any further relevant fields to the user stored in the database)
* ID (required)
* First Name (required)
* Last Name (required)
* Email (required & unique)
* Email notifications opt in
* Cell Phone #
* SMS notifications opt in
* Password
* Password Confirmation
* Enabled

#### CRUD endpoints to support the user fields mentioned above
* Forgot Password endpoint
* Assuming we have a notification service in place this endpoint would require the user to provide the ID and a valid Email to request a new auto generated password to then leverage the Reset Password endpoint
* Notification service is out of scope and can be mocked out
* Fields:
* ID (required)
* Email (required)

#### Reset Password endpoint
* Assuming the user received a notification with a new auto generated password they can then leverage this endpoint to reset their password to a new one of their choosing
* Fields:
* ID (required)
* Email (required)
* Old Password (required)
* New Password (required)
* Password Confirmation (required)

#### Unit test coverage
* Any further feature, integration, etc. test coverage is a bonus

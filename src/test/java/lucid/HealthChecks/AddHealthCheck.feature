Feature:As a therapist i want to automate the health checks for Daily checkins against the newly signup patient

  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token
  @smoke @envnot=prod
  Scenario: Create a patient and add Health check Daily checkins and then delete it
    #Create a patient
    Given url `${baseUrl}${endpoints.signup_user_endpoint}`
    * def first_name = faker.name().firstName()
    * def prefixed_first_name = name_prefix + " " + first_name
    * def last_name = faker.name().lastName()
    * def email = (name_prefix + "_" + first_name + "_" + last_name).toLowerCase() + "@lucidlane.net"
    * def generate_phoneNumber =
  """
  function generate_phone(){
  function getRandomInt(max) {
  return Math.floor(Math.random() * max);
  }

  let newNumber=""
  for(let i=0; i<=9;i++){
  newNumber += getRandomInt(9).toString()
  }
  return newNumber;
  }
  """
    * def requestBody =
  """
  {
    "username": #(email),
    "password": "Lucid@242",
    "confirm_password": "Lucid@242",
    "first_name": #(prefixed_first_name),
    "last_name": #(last_name),
  }
  """
    * requestBody.phone = generate_phoneNumber()
    * print(requestBody)
    And request requestBody
    When method POST
    Then status 201
    And def patientEmail = response.email
    * print patientEmail

    #Get Contact profile id from response
    Given url `${baseUrl}/onboarding/api/contact_profile/`
    * header Authorization = 'Bearer ' + token
    And params { email__icontains: 'qatherapist01@lucidlane.com' }
    When method GET
    Then status 200
    And def patient = response.results[0].id
    * print patient

    #Get EMA-Act healthCategory id from response
    Given url `${baseUrl}/onboarding/api/health_category/`
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And def healthCategory_id = ""
    And eval for(var i=0;i<response.results.length;i++) if(response.results[i].standard_name.endsWith("EMA-Act")){healthCategory_id=response.results[i].id};
    And print healthCategory_id

    #Create EMA-Act health score for the patient
    Given url baseUrl+'/onboarding/api/health_score/'
    * header Authorization = 'Bearer ' + token
    And def requestBody =
  """
{
  "value": "1.00",
  "contact_profile": #(patient),
  "health_category": #(healthCategory_id),
  "answers": {
  "EMA-Act": "1"
},
  "created_on": "2023-12-31T20:28:23.928Z"
}
"""
    And request requestBody
    When method POST
    Then status 201
    And def health_scoreId = response.id
    And print health_scoreId


    #Delete EMA-Act Health check from the patient
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 204

    #Get the same EMA-Act health score to make sure it should not exist
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method Get
    Then status 404
    And match response == { "detail": "Not found." }

    #Get EMA-A healthCategory id from response
    Given url `${baseUrl}/onboarding/api/health_category/`
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And def healthCategory_id = ""
    And eval for(var i=0;i<response.results.length;i++) if(response.results[i].standard_name.endsWith("EMA-A")){healthCategory_id=response.results[i].id};
    And print healthCategory_id


    #Create EMA-A health score for the patient
    Given url baseUrl+'/onboarding/api/health_score/'
    * header Authorization = 'Bearer ' + token
    And def requestBody =
  """
{
  "value": "1.00",
  "contact_profile": #(patient),
  "health_category": #(healthCategory_id),
  "answers": {
  "EMA-A": "1"
},
  "created_on": "2023-12-31T20:28:23.928Z"
}
"""
    And request requestBody
    When method POST
    Then status 201
    And def health_scoreId = response.id
    And print health_scoreId


    #Delete EMA-A Health check from the patient
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 204

    #Get the same EMA-A health score to make sure it should not exist
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method Get
    Then status 404
    And match response == { "detail": "Not found." }


    #Get EMA-M healthCategory id from response
    Given url `${baseUrl}/onboarding/api/health_category/`
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And def healthCategory_id = ""
    And eval for(var i=0;i<response.results.length;i++) if(response.results[i].standard_name.endsWith("EMA-M")){healthCategory_id=response.results[i].id};
    And print healthCategory_id


    #Create EMA-M health score for the patient
    Given url baseUrl+'/onboarding/api/health_score/'
    * header Authorization = 'Bearer ' + token
    And def requestBody =
  """
{
  "value": "1.00",
  "contact_profile": #(patient),
  "health_category": #(healthCategory_id),
  "answers": {
  "EMA-M": "1"
},
  "created_on": "2023-12-31T20:28:23.928Z"
}
"""
    And request requestBody
    When method POST
    Then status 201
    And def health_scoreId = response.id
    And print health_scoreId

    #Delete EMA-M Health check from the patient
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 204

    #Get the same EMA-M health score to make sure it should not exist
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method Get
    Then status 404
    And match response == { "detail": "Not found." }



    #Get EMA-P healthCategory id from response
    Given url `${baseUrl}/onboarding/api/health_category/`
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And def healthCategory_id = ""
    And eval for(var i=0;i<response.results.length;i++) if(response.results[i].standard_name.endsWith("EMA-P")){healthCategory_id=response.results[i].id};
    And print healthCategory_id


    #Create EMA-P health score for the patient
    Given url baseUrl+'/onboarding/api/health_score/'
    * header Authorization = 'Bearer ' + token
    And def requestBody =
  """
  {
    "value": "1.00",
    "contact_profile": #(patient),
    "health_category": #(healthCategory_id),
    "answers": {
    "EMA-P": "1"
  },
    "created_on": "2023-12-31T20:28:23.928Z"
  }
"""
    And request requestBody
    When method POST
    Then status 201
    And def health_scoreId = response.id
    And print health_scoreId

    #Delete EMA-P Health check from the patient
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 204

    #Get the same EMA-P health score to make sure it should not exist
    Given url baseUrl+'/onboarding/api/health_score/' + health_scoreId + '/'
    * header Authorization = 'Bearer ' + token
    When method Get
    Then status 404
    And match response == { "detail": "Not found." }


    #Now Delete Patient
    Given url baseUrl+'/onboarding/api/contact_profile/' + patient + '/'
    * header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 204

    #Get the same Patient ID to make sure it should not exist
    Given url baseUrl+'/onboarding/api/contact_profile/' + patient + '/'
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 404
    And match response == { "detail": "Not found." }
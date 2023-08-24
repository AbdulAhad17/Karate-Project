Feature:Create a patient using Signup API and then delete the same patient
  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token
  @smoke @envnot=prod
  Scenario: Create a patient
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
    #Get Contact profile id from response
    Given url `${baseUrl}/onboarding/api/contact_profile/`
    * header Authorization = 'Bearer ' + token
    And params { email__icontains: 'qatherapist01@lucidlane.com' }
    When method GET
    Then status 200
    And def patient = response.results[0].id
    * print patient

    #Get Contact profile id from response
    Given url baseUrl+'/onboarding/api/contact_profile/' + patient + '/'
    * header Authorization = 'Bearer ' + token
    When method DELETE
    Then status 204
Feature: User Specific Tests


  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token

    Given url `${baseUrl}/onboarding/api/contact_profile/`
    * header Authorization = 'Bearer ' + token
    And params { email: 'qapatient01@lucidlane.com' }
    When method GET
    Then status 200
    And def patient = response.results[0].id


  @smoke @regression
  Scenario: Check User Eligibility
    * print patient
    Given url baseUrl+'/onboarding/api/contact_profile/' + patient + '/check_user_eligibility' + '/'
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And assert response.service_type == "Pain Coaching"
    And assert response.user_type == "Non User"
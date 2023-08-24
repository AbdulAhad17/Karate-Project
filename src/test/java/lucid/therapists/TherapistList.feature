Feature: Therapist List

@smoke
Scenario: All therapist
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response

    Given url `${baseUrl}/therapist/api/therapist/`
    And header Authorization = 'Bearer ' + user.access
    When method GET
    Then status 200
    And assert response.results.length > 0

@smoke
Scenario: Filter by email
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response

    Given url `${baseUrl}/therapist/api/therapist/`
    And params { email__icontains: 'qatherapist01@lucidlane.com' }
    And header Authorization = 'Bearer ' + user.access
    When method GET
    Then status 200
    And assert response.results.length == 1
    * assert response.results[0].email == "qatherapist01@lucidlane.com"


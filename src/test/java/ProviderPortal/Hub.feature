Feature: Functions related to Hubs

  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token

  @smoke
  Scenario: create hub
    Given url `${baseUrl}/onboarding/api/hubs/`
    And def body =
      """
      {
        "name": "Automation Hub"
      }
      """
    And request body
    When method POST
    Then status 201
    And match response.name == body.name

    * def hub_id = response.id
    * print hub_id
    * header Authorization = 'Bearer ' + token
    Given url `${baseUrl}/onboarding/api/hubs/`+ hub_id + `/`
    When method DELETE
    Then status 204
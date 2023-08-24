Feature: Survey Score Tests

  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token

  @smoke
  Scenario Outline: Survey score

    Given url `${baseUrl}/onboarding/api/survey_score/?score=<input>`
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And assert response.score == <score>
    Examples:
    |score|input|
    |-10.9|55555|
    |46.3|11251|
    |27.3|14553|
    |11.8|55533|
    |17.8|55511|

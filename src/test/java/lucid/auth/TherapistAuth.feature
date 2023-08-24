Feature: Therapist Auth

  @smoke
  Scenario: Therapist can login using password
    Given url `${baseUrl}/api/auth/therapist/`
    And def form =
      """
      {
      username: #(secrets['qatherapist01-email']),
      password: #(secrets['qatherapist01-password'])
      }
      """
    And request form
    When method POST
    Then status 200
    And match response == { access: "#notnull", refresh: "#notnull" }

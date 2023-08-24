Feature: Provider Auth

  @smoke @valid-case
  Scenario: Login with valid credentials
    Given url `${baseUrl}/api/auth/provider/`
    And def form =
      """
      {
      username: #(secrets['provider-email']),
      password: #(secrets['provider-password'])
      }
      """
    And request form
    When method POST
    Then status 200
    And match response == { access: "#notnull", refresh: "#notnull" }


  @smoke
  Scenario Outline: Login with invalid credentials
    Given url `${baseUrl}/api/auth/provider/`
    And def form =
    """
    {
    username: "<username>",
    password: "<password>"
    }
    """
    And request form
    When method POST
    Then status <code>
    Examples:
    |username|password|code|
    |anyemailid@email.com|passInvalid|401|
    |shamaim.shaikh@lucidlane.com|passInvalid|401|
    |anyemailid@email.com|lucid@123|401|
    | |lucid@123|400|
    | |passInvalid|400|
    |anyemailid@email.co| |400|
    |shamaim.shaikh@lucidlane.com| |400
    | | |400|
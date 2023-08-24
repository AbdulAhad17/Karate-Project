Feature: Patient Auth

  @smoke @authentication
  Scenario: Takes a set of user credentials and returns an access and refresh JSON web token pair to prove the authentication of those credentials.
    Given url `${baseUrl}${endpoints.patient_endpoint}`
    And def form =
      """
      {
      username: #(secrets['qapatient01-email']),
      password: #(secrets['qapatient01-password'])
      }
      """
    And request form
    When method POST
    Then status 200
    And match response == { access: "#notnull", refresh: "#notnull" }

  @smoke
  Scenario: Takes a set of Invalid user credentials and returns an access and refresh JSON web token pair to prove the authentication of those credentials.
    Given url `${baseUrl}${endpoints.patient_endpoint}`
    And def form =
      """
      {
      username: "invalidemail@lucidlane.com",
      password: "Invalidpassword"
      }
      """
    And request form
    When method POST
    Then status 401
    And match response == { detail: "No active account found with the given credentials" }


  @smoke
  Scenario: Takes a refresh type JSON web token and returns an access type JSON web token if the refresh token is valid.
    Given url `${baseUrl}${endpoints.patient_endpoint}`
    And def form =
      """
      {
      username: #(secrets['qapatient01-email']),
      password: #(secrets['qapatient01-password'])
      }
      """
    And request form
    When method POST
    Then status 200
    And match response == { access: "#notnull", refresh: "#notnull" }
    And def refreshtoken = $.refresh

    Given url `${baseUrl}${endpoints.refresh_token_endpoint}`
    And def requestBody =
    """
    {
      "refresh": #(refreshtoken),
    }
    """
    And request requestBody
    When method POST
    Then status 200


  @smoke
  Scenario: Verify user-API:Takes a token and indicates if it is valid. This view provides no information about a token's fitness for a particular use.
    Given url `${baseUrl}${endpoints.patient_endpoint}`
    And def form =
      """
      {
      username: #(secrets['qapatient01-email']),
      password: #(secrets['qapatient01-password'])
      }
      """
    And request form
    When method POST
    Then status 200
    And match response == { access: "#notnull", refresh: "#notnull" }
    And def Verify_user_token = $.access

    Given url `${baseUrl}${endpoints.verify_user_endpoint}`
    And def requestBody =
    """
    {
      "token": #(Verify_user_token),
    }
    """
    And request requestBody
    When method POST
    Then status 200


  @smoke
  Scenario: Verify upgrade token API and indicates if it is valid. This view provides no information about a token's fitness for a particular use.
    Given url `${baseUrl}${endpoints.patient_endpoint}`
    And def form =
      """
      {
      username: #(secrets['qapatient01-email']),
      password: #(secrets['qapatient01-password'])
      }
      """
    And request form
    When method POST
    Then status 200
    And match response == { access: "#notnull", refresh: "#notnull" }
    And def upgrade_token = $.access

    Given url `${baseUrl}${endpoints.upgrade_token}`
    And def requestBody =
    """
    {
      "access": #(upgrade_token),
    }
    """
    And request requestBody
    When method POST
    Then status 200

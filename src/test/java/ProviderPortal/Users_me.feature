Feature: Testing provider details api

  @smoke
  Scenario: Fetch provider details
    * def result = call read('classpath:ProviderPortal/ProviderAuth.feature@valid-case')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token

    Given url `${baseUrl}/users/api/users/me/`
    When method GET
    Then status 200
    And match response contains { id: "#notnull", username: "#(secrets['provider-email'])", first_name: "Shamaim", last_name: "Shaikh" }
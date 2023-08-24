Feature: Contact Profile Events

@smoke @envnot=prod
Scenario: Create and Delete Contact Profile
    * configure retry = { count: 5, interval: 3000 }
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def first_name = faker.name().firstName()
    * def prefixed_first_name = name_prefix + " " + first_name
    * def last_name = faker.name().lastName()
    * def preferred_name = first_name + " " + last_name
    * def email = (name_prefix + "_" + first_name + "_" + last_name).toLowerCase() + "@lucidlane.net"
    * def requestBody =
    """
    {
      "first_name": #(prefixed_first_name),
      "last_name": #(last_name),
      "preferred_name": #(preferred_name),
      "email": #(email),
    }
    """

    Given url `${baseUrl}/onboarding/api/contact_profile/`
    And header Authorization = 'Bearer ' + user.access
    When request requestBody
    And method POST
    Then status 201
    * match response contains
    """
    {
      id: "#notnull",
      first_name: #(prefixed_first_name),
      last_name: #(last_name),
      preferred_name: #(preferred_name),
      email: #(email),
    }
    """
    * match response.email == email
    * def contactProfile = response.id

    Given url `${eventsBaseUrl}/events`
    And header Authorization = 'Bearer ' + user.access
    And params { contact_profile_id: #(contactProfile), object_type: "onboarding_contactprofile", action_type: "create" }
    And retry until response.items.length > 0
    When method GET
    Then status 200
    * match response.items[0] contains { object_type: "onboarding_contactprofile", object_id: #(contactProfile), action_type: "create" }
    
    Given url `${baseUrl}/onboarding/api/contact_profile/${contactProfile}/`
    And header Authorization = 'Bearer ' + user.access
    When method DELETE
    Then status 204

    Given url `${eventsBaseUrl}/events`
    And header Authorization = 'Bearer ' + user.access
    And params { contact_profile_id: #(contactProfile), object_type: "onboarding_contactprofile", action_type: "delete" }
    And retry until response.items.length > 0
    When method GET
    Then status 200
    * match response.items[0] contains { object_type: "onboarding_contactprofile", object_id: #(contactProfile), action_type: "delete" }

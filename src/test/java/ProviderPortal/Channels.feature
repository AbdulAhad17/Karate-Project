Feature: Functions related to channels

  @smoke
  Scenario: Fetch pdmp data of a patient
  * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
  * def user = result.response
  * def token = user.access
  * header Authorization = 'Bearer ' + token

  Given url `${baseUrl}/onboarding/api/channels/`
  And def form =
      """
      {
        name: "Automation",
        color: ""
      }
      """
  And request form
  When method POST
  Then status 201
  And match response.name == form.name

  * def channel_id = response.id
  * print channel_id
  * header Authorization = 'Bearer ' + token
  Given url `${baseUrl}/onboarding/api/channels/`+ channel_id + `/`
  When method DELETE
  Then status 204
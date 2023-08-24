Feature: Consent Form Graphql queries

Scenario: Fetching consent form from Graphql
  * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
  * def user = result.response

  Given url `${baseUrl}${endpoints.graphql}`
  * header Authorization = 'Bearer ' + user.access
  * def query = read('ConsentForm.gql')
  * request { query: '#(query)' }
  * header Accept = 'application/json'
  * method post
  Then status 200
  And assert response.data.forms.length > 0
  And match response.data.forms[0] contains { id: "#notnull", name: "#notnull" }

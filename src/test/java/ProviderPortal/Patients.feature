Feature: Patients data on Provider portal

  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token


    Given url `${baseUrl}/onboarding/api/contact_profile/`
    * header Authorization = 'Bearer ' + token
    And params { email: 'qapatient01@lucidlane.com' }
    When method GET
    Then status 200
    And def provider_patient = response.results[0].id
    * print provider_patient

  @smoke
  Scenario: Fetch recent patients searched
    * def result = call read('classpath:ProviderPortal/ProviderAuth.feature@valid-case')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token
    Given url `${baseUrl}/provider/api/provider_recent_patients_ids/`
    When method GET
    Then status 200

  @smoke
  Scenario: Fetch pdmp data of a patient
    * def result = call read('classpath:ProviderPortal/ProviderAuth.feature@valid-case')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token
    Given url `${baseUrl}/pdmp/api/patient_pdmp_alert/`
    And params  { contact_profile_id: #(provider_patient) }
    When method GET
    Then status 200
    And match response contains {"prescribers":{"number_of_prescribers":1,"color":"green"},"pharmacies":{"number_of_pharmacies":1,"color":"green"},"concurrent_benzos":{"concurrent_benzo_color":'red'},"opioid_consumption":{"opioid_consumption":false,"opioid_consumption_color":null}}

  @smoke
  Scenario: Fetch mhr reports of a patient
    * def result = call read('classpath:ProviderPortal/ProviderAuth.feature@valid-case')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token
    * def contact_id = provider_patient
    Given url `${baseUrl}/provider/api/patients/` + contact_id + `/mhrs/`
    When method GET
    Then status 200
    And match each response contains {id: "#notnull", name: "HEALTH REPORT"}

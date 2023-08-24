Feature: Therapist availability Tests

  Background:
    * def result = call read('classpath:lucid/auth/PatientAuth.feature@authentication')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token


    Given url `${baseUrl}/therapist/api/therapist/`
    And params { email__icontains: 'qatherapist01@lucidlane.com' }
    And header Authorization = 'Bearer ' + user.access
    When method GET
    Then status 200
    And assert response.results.length == 1
    * assert response.results[0].email == "qatherapist01@lucidlane.com"
    * def therapistId = response.results[0].id



  @smoke @envnot=prod
  Scenario: Verifying availability Logic through schedule New appointment slots
    Given url `${baseUrl}/appointments/api/therapist_availability/schedule_new_appointment_slots`
    * header Authorization = 'Bearer ' + token
   # And params { therapist_id: '6e17c2d2-e545-4f16-b178-1f96401fc397' }
    And params  { therapist_id: #(therapistId) }
    When method GET
    Then status 200
    * def date = karate.keysOf(response)
    * print date[0]
  #  * assert date.length == 22
    * def next_date =
    """
    var dateObj = new Date();
    var month = (dateObj.getMonth() + 1).toString().padStart(2, "0");
    var day = (dateObj.getUTCDate()+1).toString().padStart(2, "0");
    var day = (dateObj.getUTCDate()+1).toString().padStart(2,"0");
    var year = dateObj.getUTCFullYear();
    newdate = year + "-" + month + "-" + day;
  
    """
    * print next_date
    And match date[0] == next_date
    * def date_slot = karate.valuesOf(response)
  #  * assert date_slot.length == 22
    And match karate.keysOf(response) != '#null'
    And match karate.valuesOf(response) != '#null'


    # var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    # var sdf = new SimpleDateFormat('yyyy-mm-dd');
    # var date = new java.util.Date();
    # var timestamp = sdf.format(date);


  @smoke @envnot=prod
  Scenario: Verifying availability Logic through Date Range Filter
    Given url `${baseUrl}/appointments/api/therapist_availability/slots_by_date_range`
    * header Authorization = 'Bearer ' + token
    And params  { therapist_id: #(therapistId) }
    * def next_date =
    """
    var dateObj = new Date();
    var month = (dateObj.getMonth() + 1).toString().padStart(2, "0");
    var day = (dateObj.getUTCDate()+1).toString().padStart(2,"0");
    var year = dateObj.getUTCFullYear();
    newdate = year + "-" + month + "-" + day;

   """
    * print next_date
    * def after_next_date =
    """
    var dateObj = new Date();
    var month = (dateObj.getMonth() + 1).toString().padStart(2, "0");
    var day = (dateObj.getUTCDate()+2).toString().padStart(2,"0");
    var year = dateObj.getUTCFullYear();
    newdate = year + "-" + month + "-" + day;

   """
    * print after_next_date
    And params  { therapist_id: #(therapistId) }
    * def next_day_query = { start_date: #(next_date) }
    * def after_next_day_query = { end_date: #(after_next_date) }
    And params next_day_query
    And params after_next_day_query
    When method GET
    Then status 200

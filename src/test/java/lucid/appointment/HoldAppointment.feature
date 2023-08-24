Feature: Hold Appointment Tests

Background:
  * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
  * def user = result.response
  * def token = user.access
  * header Authorization = 'Bearer ' + token

@smoke @envnot=prod
Scenario: Create and delete hold appointment

  Given url `${baseUrl}/therapist/api/therapist/`
  * header Authorization = 'Bearer ' + token
  And params { email__icontains: 'qatherapist01@lucidlane.com' }
  When method GET
  Then status 200
  And def therapist = response.results[0].id

  Given url `${baseUrl}/onboarding/api/contact_profile/`
  * header Authorization = 'Bearer ' + token
  And params { email: 'qapatient01@lucidlane.com' }
  When method GET
  Then status 200
  And def patient = response.results[0].id

  Given url `${baseUrl}/onboarding/api/service_types/`
  * header Authorization = 'Bearer ' + token
  When method GET
  Then status 200
  And def serviceType = response.results[0].id

  Given url baseUrl+'/appointments/api/hold/'
  * header Authorization = 'Bearer ' + token
  And def requestBody = 
  """
  {
    "title": "Lucid Lane Appointment",
    "description": "",
    "patients": [#(patient)],
    "therapists": [#(therapist)],
    "appointmentType": "1x1",
    "appointment_status": "hold",
    "service_type": #(serviceType),
    "scheduled_time_range": {
      "start": "2023-11-12T01:15:00.000Z",
      "end": "2023-11-12T02:15:00.000Z"
    },
    "addVideoCall": true
  }
  """
  And request requestBody
  When method POST
  Then status 201
  #Fetch Appointment id from the response
  * def appointmentId = $.id
  * print appointmentId

  Given url baseUrl+'/appointments/api/hold/' + appointmentId + '/'
  * header Authorization = 'Bearer ' + token
  And method delete
  Then status 204

@smoke @envnot=prod
Scenario: Hold appointment,Confirm appointment and then cancel an appointment

  Given url `${baseUrl}/therapist/api/therapist/`
  * header Authorization = 'Bearer ' + token
  And params { email__icontains: 'qatherapist01@lucidlane.com' }
  When method GET
  Then status 200
  And def therapist = response.results[0].id
  * print therapist

  Given url `${baseUrl}/onboarding/api/contact_profile/`
  * header Authorization = 'Bearer ' + token
  And params { email: 'qapatient01@lucidlane.com' }
  When method GET
  Then status 200
  And def patient = response.results[0].id
  * print patient

  Given url `${baseUrl}/onboarding/api/service_types/`
  * header Authorization = 'Bearer ' + token
  When method GET
  Then status 200
  And def serviceType = response.results[0].id
  * print serviceType

  Given url baseUrl+'/appointments/api/hold/'
  * header Authorization = 'Bearer ' + token
  And def requestBody =
  """
  {
    "title": "Lucid Lane Appointment",
    "description": "",
    "patients": [#(patient)],
    "therapists": [#(therapist)],
    "appointmentType": "1x1",
    "appointment_status": "hold",
    "service_type": #(serviceType),
    "scheduled_time_range": {
      "start": "2023-12-17T03:15:00.000Z",
      "end": "2023-12-17T04:15:00.000Z"
    },
    "addVideoCall": true
  }
  """
  And request requestBody
  When method POST
  Then status 201
  #Fetch Appointment id from the response
  * def appointmentId = $.id
  * print appointmentId


  Given url baseUrl+'/appointments/api/hold/' + appointmentId + '/confirm/'
  * header Authorization = 'Bearer ' + token
  And def requestBody =
  """
  {
    "title": "Lucid Lane Appointment",
    "description": "",
    "patients": [#(patient)],
    "therapists": [#(therapist)],
    "appointmentType": "1x1",
    "service_type": #(serviceType),
    "scheduled_time_range": {
      "start": "2023-12-17T03:15:00.000Z",
      "end": "2023-12-17T04:15:00.000Z"
    },
    "add_video_conference": true,
    "timezone": "America/Chicago",
    "enable_hold": true
  }
  """
  And request requestBody
  When method POST
  Then status 200

  Given url baseUrl+'/appointments/api/appointments/' + appointmentId + '/cancel/'
  * header Authorization = 'Bearer ' + token
  And def requestBody =
  """
  {
    "late_cancelled": true,
    "notify_opt_out": true,
    repeat_appt_cancel_criterion: "this_event"
  }
  """
  And request requestBody
  When method POST
  Then status 200

@smoke @envnot=prod
Scenario: Hold series-appointment,Confirm-series appointment and then cancel an appointment

  Given url `${baseUrl}/therapist/api/therapist/`
  * header Authorization = 'Bearer ' + token
  And params { email__icontains: 'qatherapist01@lucidlane.com' }
  When method GET
  Then status 200
  And def therapist = response.results[0].id

  Given url `${baseUrl}/onboarding/api/contact_profile/`
  * header Authorization = 'Bearer ' + token
  And params { email: 'qapatient01@lucidlane.com' }
  When method GET
  Then status 200
  And def patient = response.results[0].id

  Given url `${baseUrl}/onboarding/api/service_types/`
  * header Authorization = 'Bearer ' + token
  When method GET
  Then status 200
  And def serviceType = response.results[0].id

  Given url baseUrl+'/appointments/api/hold/'
  * header Authorization = 'Bearer ' + token
  And def requestBody =
  """
  {
    "title": "Lucid Lane Appointment",
    "description": "",
    "patients": [#(patient)],
    "therapists": [#(therapist)],
    "appointmentType": "1x1",
    "appointment_status": "hold",
    "service_type": #(serviceType),
    "scheduled_time_range": {
      "start": "2023-11-30T03:15:00.000Z",
      "end": "2023-11-30T04:15:00.000Z"
    },
    "recurrence_data": {
        "frequency": 2,
        "interval": 1,
        "count": 2
    },
    "repeat_appt_cancel_criterion":"All_event",
    "addVideoCall": true
  }
  """
  And request requestBody
  When method POST
  Then status 201
  #Fetch Appointment id from the response
  * def appointmentId = $.id
  * print appointmentId


  Given url baseUrl+'/appointments/api/hold/' + appointmentId + '/confirm/'
  * header Authorization = 'Bearer ' + token
  And def requestBody =
  """
  {
    "title": "Lucid Lane Appointment",
    "description": "",
    "patients": [#(patient)],
    "therapists": [#(therapist)],
    "appointmentType": "1x1",
    "service_type": #(serviceType),
    "scheduled_time_range": {
      "start": "2023-11-30T03:15:00.000Z",
      "end": "2023-11-30T04:15:00.000Z"
    },
    "add_video_conference": true,
    "timezone": "America/Chicago",
    "recurrence_data": {
        "frequency": 2,
        "interval": 1,
        "count": 2
    },
    "repeat_appt_cancel_criterion":"All_event",
    "addVideoCall": true,
    "enable_hold": true
  }
  """
  And request requestBody
  When method POST
  Then status 200

  Given url baseUrl+'/appointments/api/appointments/' + appointmentId + '/cancel/'
  * header Authorization = 'Bearer ' + token
  And def requestBody =
  """
  {
    "late_cancelled": true,
    "notify_opt_out": true,
    repeat_appt_cancel_criterion: "All_event"
  }
  """
  And request requestBody
  When method POST
  Then status 200

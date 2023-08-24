Feature: Therapist

@load
Scenario: Therapist auth and lists
    * call read('classpath:lucid/therapists/TherapistList.feature')

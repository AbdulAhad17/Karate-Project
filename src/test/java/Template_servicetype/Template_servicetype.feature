Feature: Get Template Against service type

  Background:
    * def result = call read('classpath:lucid/auth/TherapistAuth.feature')
    * def user = result.response
    * def token = user.access
    * header Authorization = 'Bearer ' + token

  @smoke
  Scenario: Get Template with service type

    Given url `${baseUrl}/onboarding/api/service_types/`
    * header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    And def Psychological_Evaluation_Id = ""
    And eval for(var i=0;i<response.results.length;i++) if(response.results[i].display_name.endsWith("Psychological Evaluation")){Psychological_Evaluation_Id=response.results[i].id};
    And assert Psychological_Evaluation_Id != ''
    * print Psychological_Evaluation_Id

    Given url `${baseUrl}/lucid_forms/api/templates/?service_types/` + Psychological_Evaluation_Id + '/'
    * header Authorization = 'Bearer ' + token
    And method Get
    Then status 200
    And eval for(var i=0;i<response.results.length;i++) if(response.results[i].display_name.endsWith("Psychological Evaluation")){Psychological_Evaluation_Id=response.results[i].id};
    * print Psychological_Evaluation_Id
    And assert Psychological_Evaluation_Id != ''



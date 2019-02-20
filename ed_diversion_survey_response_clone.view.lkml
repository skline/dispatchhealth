view: ed_diversion_survey_response_clone {
  label: "ED Diversion Survey Response"
  derived_table: {
    sql:
    SELECT
      COALESCE(v1.visit_dim_number, v2.visit_dim_number) AS visit_dim_number,
      COALESCE(v1.care_request_id, v2.care_request_id) AS care_request_id,
      COALESCE(v1.question_dim_id, v2.question_dim_id) AS question_dim_id,
      COALESCE(v1.respondent_dim_id, v2.respondent_dim_id) AS respondent_dim_id,
      COALESCE(v1.patient_dim_id, v2.patient_dim_id) AS patient_dim_id,
      COALESCE(v1.provider_dim_id, v2.provider_dim_id) AS provider_dim_id,
      COALESCE(v1.survey_name, v2.survey_name) AS survey_name,
      CASE
        WHEN v2.answer_selection_value = 'Yes' THEN 'Emergency Room'
        ELSE COALESCE(v1.answer_selection_value, v2.answer_selection_value)
      END AS answer_selection_value
FROM (
(select max(visit_dim_number) visit_dim_number,
      care_request_id,
      max(question_dim_id) question_dim_id,
      max(respondent_dim_id) respondent_dim_id,
      max(patient_dim_id) patient_dim_id,
      max(provider_dim_id) provider_dim_id,
      max(survey_name) survey_name,
      max(answer_selection_value) answer_selection_value
from looker_scratch.survey_response_facts_clone
where survey_response_facts_clone.question_dim_id=3
group by 2) AS v1

FULL OUTER JOIN
(select max(visit_dim_number) visit_dim_number,
      care_request_id,
      max(question_dim_id) question_dim_id,
      max(respondent_dim_id) respondent_dim_id,
      max(patient_dim_id) patient_dim_id,
      max(provider_dim_id) provider_dim_id,
      max(survey_name) survey_name,
      max(answer_selection_value) answer_selection_value
from looker_scratch.survey_response_facts_clone
where survey_response_facts_clone.question_dim_id=9
group by 2) AS v2

ON v1.care_request_id = v2.care_request_id) ;;


   # OLD SQL Query - Survey changed 12/6/2018
#     select *
#       from
#       (select  max(visit_dim_number) visit_dim_number,
#       care_request_id,
#       max(question_dim_id) question_dim_id,
#       max(respondent_dim_id) respondent_dim_id,
#       max(patient_dim_id) patient_dim_id,
#       max(provider_dim_id) provider_dim_id,
#       max(survey_name) survey_name,
#       max(answer_selection_value) answer_selection_value
# from looker_scratch.survey_response_facts_clone
# where survey_response_facts_clone.question_dim_id=3
# group by 2 ) ed_diversion_survey_response ;;

    sql_trigger_value: SELECT max(visit_dim_number) ;;
    indexes: ["visit_dim_number", "care_request_id"]
  }
  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: visit_dim_number {
    label: "EHR Appointment ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: answer_selection_value {
    type: string
    sql: ${TABLE}.answer_selection_value ;;
  }

  dimension: survey_yes_to_er {
    type: yesno
    description: "Patient indicates they would have gone to ER if DH not available"
    sql: ${answer_selection_value} = 'Emergency Room' ;;
  }


}

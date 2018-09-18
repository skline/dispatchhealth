view: ed_diversion_survey_response_clone {
  label: "ED Diversion Survey Response"
  derived_table: {
    sql: select *
      from
      (select  max(visit_dim_number) visit_dim_number,
      care_request_id,
      max(question_dim_id) question_dim_id,
      max(respondent_dim_id) respondent_dim_id,
      max(patient_dim_id) patient_dim_id,
      max(provider_dim_id) provider_dim_id,
      max(survey_name) survey_name,
      max(answer_selection_value) answer_selection_value
from looker_scratch.survey_response_facts_clone
where survey_response_facts_clone.question_dim_id=3
group by 2 ) ed_diversion_survey_response
             ;;
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


}

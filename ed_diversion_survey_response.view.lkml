view: ed_diversion_survey_response {
  label: "ED Diversion Survey Response"
  derived_table: {
    sql: select *
      from
      (select  survey_response_facts.visit_dim_number, survey_response_facts.care_request_id, survey_response_facts.question_dim_id, survey_response_facts.respondent_dim_id, survey_response_facts.patient_dim_id, survey_response_facts.provider_dim_id, survey_response_facts.survey_name, survey_response_facts.answer_selection_value
from survey_response_facts
where survey_response_facts.question_dim_id=3
group by 1 ) ed_diversion_survey_response
             ;;
    sql_trigger_value: SELECT_CURDATE() ;;
    indexes: ["visit_dim_number", "care_request_id"]
  }
  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: visit_dim_number {
    label: "EHR ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: answer_selection_value {
    type: string
    sql: ${TABLE}.answer_selection_value ;;
  }


}

view: ed_diversion_survey_response {
  derived_table: {
    sql: select *
      from
      (select  survey_response_facts.care_request_id, survey_response_facts.question_dim_id, survey_response_facts.respondent_dim_id,  survey_response_facts.care_request_id, survey_response_facts.visit_dim_number, survey_response_facts.patient_dim_id, survey_response_facts.provider_dim_id, survey_response_facts.survey_name, survey_response_facts.answer_selection_value
from jasperdb_dev.survey_response_facts
where survey_response_facts.question_dim_id=3
group by 1 ) ed_diversion_survey_response
             ;;
  }
  dimension: ed_diversion_survey_response.care_request_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: ed_diversion_survey_response.visit_dim_number {
    type: number
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: ed_diversion_survey_response.answer_selection_value {
    type: string
    sql: ${TABLE}.answer_selection_value ;;
  }


}

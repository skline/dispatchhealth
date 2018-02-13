view: ed_diversion_survey_response_rate {
  label: "ED Diversion Survey Response Rate"
   # Or, you could make this view a derived table, like this:
  derived_table: {
     sql: select *
from
(SELECT   visit_facts.market_dim_id,  sum(IF(survey_response_facts.answer_selection_value = 'Emergency Room', 1, 0)) / count(DISTINCT visit_facts.care_request_id) as default_er_response_rate
FROM     survey_response_facts
JOIN     visit_facts
ON       survey_response_facts.visit_dim_number = visit_facts.visit_dim_number
WHERE    survey_response_facts.question_dim_id = 3
GROUP BY 1) ed_diversion_survey_response_rate
       ;;

sql_trigger_value: SELECT CURDATE() ;;
indexes: ["market_dim_id"]
 }
dimension: market_dim_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.market_dim_id ;;
   }
#
   dimension: er_percent {
    label: "ER percent"
     type: number
     sql: ${TABLE}.default_er_response_rate ;;
   }
}

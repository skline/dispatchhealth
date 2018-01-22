view: ed_diversion_survey_response_rate {
   # Or, you could make this view a derived table, like this:
  derived_table: {
     sql: SELECT   vf.market_dim_id,
         sum(IF(srf.answer_selection_value = 'Emergency Room', 1, 0)) / count(DISTINCT vf.care_request_id) AS er_percent
FROM     survey_response_facts srf
JOIN     visit_facts vf
ON       vf.visit_dim_number = srf.visit_dim_number
WHERE    srf.question_dim_id = 3
GROUP BY 1
       ;;
   }

dimension: market_dim_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.market_dim_id ;;
   }
#
   measure: er_percent {
     description: "Use this for counting lifetime orders across many users"
     type: number
     sql: ${er_percent} ;;
   }
}

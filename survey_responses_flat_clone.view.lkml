view: survey_responses_flat_clone {
  derived_table: {
    sql:
      SELECT DISTINCT
          srf.visit_dim_number,
          srf.care_request_id,
          srf.visit_date,
          nps.answer_range_value AS nps_response,
          alt.answer_selection_value AS alternative_dh_response,
          ovr.answer_selection_value AS overall_rating_response
          FROM (
            SELECT DISTINCT
              visit_dim_number,
              care_request_id,
              MAX(visit_date) AS visit_date
            FROM survey_response_facts_clone
            WHERE care_request_id IS NOT NULL
            GROUP BY 1,2
          ) srf
          LEFT JOIN survey_response_facts_clone nps
            ON srf.care_request_id = nps.care_request_id AND nps.question_dim_id = 4
          LEFT JOIN survey_response_facts_clone alt
            ON srf.care_request_id = alt.care_request_id AND alt.question_dim_id = 3
          LEFT JOIN survey_response_facts_clone ovr
            ON srf.care_request_id  = ovr.care_request_id AND ovr.question_dim_id = 5
          ORDER BY care_request_id DESC ;;

    sql_trigger_value: SELECT MAX(care_request_id) FROM survey_response_facts_clone ;;
    indexes: ["visit_dim_number", "care_request_id"]
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: visit_dim_number {
    type: number

    description: "Athena EHR ID"
    sql: ${TABLE}.visit_dim_number ;;
  }


  dimension: answer_range_value {
    label: "NPS Selected Range Value"
    type: number
    sql: ${TABLE}.nps_response ;;
  }

  dimension: promoter {
    label: "Promoter"
    type: yesno
    sql: ${answer_range_value} > 8 AND ${answer_range_value} IS NOT NULL;;
  }

  dimension: detractor {
    label: "Detractor"
    type: yesno
    sql: ${answer_range_value} < 7 AND ${answer_range_value} IS NOT NULL;;
  }

  dimension: nps_respondent {
    label: "NPS survey respondent"
    type: yesno
    sql: ${answer_range_value} IS NOT NULL;;
  }

#   dimension: nps_survey_id {
#     type: number
#     hidden: yes
#     sql: IF(${answer_range_value} IS NOT NULL, ${care_request_id}, NULL) ;;
#   }

  measure: count_nps_respondent {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  dimension: answer_selection_dh_alternative {
    label: "Selected Value Alternative to DH"
    type: string
    sql: ${TABLE}.alternative_dh_response ;;
  }

  dimension: answer_selection_overall {
    label: "Selected Value Overall Rating"
    type: string
    sql: ${TABLE}.overall_rating_response ;;
  }

  measure: distinct_promoters{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: promoter
      value: "yes"
    }
  }

  measure: distinct_detractors{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: detractor
      value: "yes"
    }
  }

  measure: distinct_nps_respondent{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: nps_respondent
      value: "yes"
    }
  }

# Currently doesn't work - Needs division by zero fixed
#   measure: nps_score {
#     type: number
#     value_format: "0.0"
#     sql: CASE
#           WHEN ${distinct_nps_respondent} > 0 THEN ((${distinct_promoters} -${distinct_detractors})/${distinct_nps_respondent})*100
#           ELSE 0
#         END ;;
#   }

  measure: count_respondents {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

}

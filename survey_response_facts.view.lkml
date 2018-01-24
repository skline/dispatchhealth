view: survey_response_facts {
  sql_table_name: jasperdb.survey_response_facts ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: answer_open_ended_value {
    type: string
    sql: ${TABLE}.answer_open_ended_value ;;
  }

  dimension: answer_range_value {
    type: number
    sql: ${TABLE}.answer_range_value ;;
  }

  dimension: answer_selection_value {
    type: string
    sql: ${TABLE}.answer_selection_value ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: local_visit {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_visit_date ;;
  }

  dimension: patient_dim_id {
    type: number
    sql: ${TABLE}.patient_dim_id ;;
  }

  dimension: provider_dim_id {
    type: number
    sql: ${TABLE}.provider_dim_id ;;
  }

  dimension: question_dim_id {
    type: number
    sql: ${TABLE}.question_dim_id ;;
  }

  dimension: respondent_dim_id {
    type: number
    sql: ${TABLE}.respondent_dim_id ;;
  }

  dimension_group: run {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.run_date ;;
  }

  dimension: survey_name {
    type: string
    sql: ${TABLE}.survey_name ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension_group: visit {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.visit_dataree ;;
  }

  dimension: visit_dim_number {
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  measure: count {
    type: count
    drill_fields: [id, survey_name]
  }

  measure: distinct_care_request_ids {
    type: count_distinct
    sql: ${visit_facts.care_request_id} ;;
  }

  measure: count_of_emergency_room {
    type: count
    filters: {
      field: survey_response_facts.answer_selection_value
      value: "Emergency Room"
    }
  }

  measure: er_percent {
    type: number
    sql: 1.0 * ${count_of_emergency_room} / NULLIF(${distinct_care_request_ids}, 0) ;;
    value_format_name: decimal_2
  }

#   sum(IF(survey_response_facts.answer_selection_value = 'Emergency Room', 1, 0)) /
# count(DISTINCT visit_facts.care_request_id)

}

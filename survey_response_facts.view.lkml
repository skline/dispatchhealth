view: survey_response_facts {
  sql_table_name: jasperdb.survey_response_facts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: answer_open_ended_value {
    label: "Open End Value Answer"
    type: string
    sql: ${TABLE}.answer_open_ended_value ;;
  }

  dimension: answer_range_value {
    label: "Selected Range Value"
    type: number
    sql: ${TABLE}.answer_range_value ;;
  }

  dimension: answer_selection_value {
    label: "Selected Value"
    type: string
    sql: ${TABLE}.answer_selection_value ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: created {
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}.patient_dim_id ;;
  }

  dimension: provider_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.provider_dim_id ;;
  }

  dimension: question_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.question_dim_id ;;
  }

  dimension: respondent_dim_id {
    hidden: yes
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
    hidden: yes
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

}

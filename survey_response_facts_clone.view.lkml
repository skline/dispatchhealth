view: survey_response_facts_clone {
  sql_table_name: looker_scratch.survey_response_facts_clone ;;

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

  dimension: answer_selection_value {
    label: "Selected Value"
    type: string
    sql: ${TABLE}.answer_selection_value ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: nps_survey_id {
    type: number
    hidden: yes
    sql: IF(${answer_range_value} IS NOT NULL, ${care_request_id}, NULL) ;;
  }

  measure: count_nps_respondent {
    type: count_distinct
    sql: ${nps_survey_id} ;;
  }

  measure: count_distinct_survey_respondents {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: promoter_count {
    type: count_distinct
    sql: ${nps_survey_id} ;;
    filters: {
      field: promoter
      value: "yes"
    }
  }

  measure: detractor_count {
    type: count_distinct
    sql: ${nps_survey_id} ;;
    filters: {
      field: detractor
      value: "yes"
    }
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
    convert_tz: no
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
    label: "EHR Appointment ID"
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  measure: nps_total_count {
    type: count
    description: "Don't use this.  Use 'Count NPS Respondent' instead"
    filters: {
      field: nps_respondent
      value: "yes"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, survey_name]
  }

}

view: bounce_back_risk_3day_predictions {
  sql_table_name: bounce_back_risk.predictions ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: concat_care_request_id_model_version {
    type: string
    sql: ${__model_version} || '-' || ${care_request_id} ;;
  }

  dimension_group: __data {
    type: time
    hidden: yes
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."__data_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: __model_version {
    type: number
    hidden: no
    sql: ${TABLE}."__model_version" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: decile {
    type: number
    sql: ${TABLE}."decile" ;;
  }

  dimension: probability_false {
    type: number
    value_format: "0.00"
    sql: ${TABLE}."probability_false" ;;
  }

  dimension: probability_true {
    type: number
    value_format: "0.00"
    sql: ${TABLE}."probability_true" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

  measure: true_average_probability {
    type: average_distinct
    sql: ${probability_true} ;;
    sql_distinct_key: ${concat_care_request_id_model_version} ;;
    value_format: "0.0000"
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: predictions {
  sql_table_name: risk_model_predictions.predictions ;;
  drill_fields: [id]
  view_label: "On Scene Risk Predictions"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: __data {
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
    sql: ${TABLE}."__data_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: __model_version {
    type: number
    sql: ${TABLE}."__model_version" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: decile {
    type: number
    sql: ${TABLE}."decile" ;;
  }

  dimension: probability_false {
    type: number
    sql: ${TABLE}."probability_false" ;;
  }

  dimension: probability_true {
    type: number
    sql: ${TABLE}."probability_true" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

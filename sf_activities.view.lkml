view: sf_activities {
  sql_table_name: looker_scratch.sf_activities ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: activity_id {
    type: string
    sql: ${TABLE}."activity_id" ;;
  }

  dimension: assigned {
    type: string
    sql: ${TABLE}."assigned" ;;
  }


  dimension_group: start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      time
    ]
    sql: ${TABLE}."start_date" ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      time
    ]
    sql: ${TABLE}."end_date" ;;
  }

  dimension: result {
    type: string
    sql: lower(${TABLE}."result") ;;
  }

  dimension: subject {
    type: string
    sql: lower(${TABLE}."subject") ;;
  }

  dimension: task_type {
    type: string
    sql: lower(${TABLE}."task_type") ;;
  }

  dimension: lead_type {
    type: string
    sql: lower(${TABLE}."lead_type") ;;
  }


  dimension: task_bool {
    type: yesno
    sql: ${TABLE}."task_bool" = true ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}

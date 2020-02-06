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


  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."date" ;;
  }


  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension: task_type {
    type: string
    sql: ${TABLE}."task_type" ;;
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

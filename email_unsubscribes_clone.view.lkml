view: email_unsubscribes_clone {
  sql_table_name: looker_scratch.email_unsubscribes_clone ;;

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

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
  }

  dimension: list_id {
    type: string
    sql: ${TABLE}."list_id" ;;
  }

  dimension: list_name {
    type: string
    sql: ${TABLE}."list_name" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  measure: count {
    type: count
    drill_fields: [list_name]
  }
}

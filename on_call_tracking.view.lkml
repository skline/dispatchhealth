view: on_call_tracking {
  sql_table_name: looker_scratch.on_call_tracking ;;

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
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: on_call_status {
    type: string
    sql: ${TABLE}."on_call_status" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

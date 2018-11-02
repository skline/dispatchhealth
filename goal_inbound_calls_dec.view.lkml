view: goal_inbound_calls_dec {
  sql_table_name: looker_scratch.goal_inbound_calls_dec ;;

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
    sql: ${TABLE}.date ;;
  }

  dimension: day_of_week {
    type: number
    sql: ${TABLE}.day_of_week ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: day_of_week_adj {
    type: number
    sql: ${TABLE}.day_of_week_adj ;;
  }

  dimension: goal_inbound_calls_dec {
    type: number
    sql: ${TABLE}.goal_inbound_calls_dec ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

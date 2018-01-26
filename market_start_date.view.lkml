view: market_start_date {
  sql_table_name: looker_scratch.market_start_date ;;

  dimension_group: first_accepted {
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
    sql: ${TABLE}.first_accepted_time ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

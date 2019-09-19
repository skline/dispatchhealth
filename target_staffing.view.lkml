view: target_staffing {
  sql_table_name: looker_scratch.target_staffing ;;

  dimension: dow {
    type: string
    sql: ${TABLE}."dow" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
  }

  dimension_group: month {
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
    sql: ${TABLE}."month" ;;
  }

  dimension: target_hours {
    type: number
    sql: ${TABLE}."target_hours" ;;
  }
  measure: sum_target_hours {
    type: sum_distinct
    sql_distinct_key: concat(${shift_teams.start_date}::varchar, ${markets.name});;
    sql: ${target_hours} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: budget_hours {
  sql_table_name: looker_scratch.budget_hours ;;

  dimension: budgeted_hours {
    type: number
    sql: ${TABLE}."budgeted_hours" ;;
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

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_budget_hours_datetime_explore {
    type: sum_distinct
    sql_distinct_key: concat(${date_placeholder.date_placeholder_month}::varchar, ${market_id});;
    sql: ${budgeted_hours} ;;
  }
}

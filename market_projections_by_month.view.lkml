view: market_projections_by_month {
  sql_table_name: looker_scratch.market_projections_by_month ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.market, ' ', ${month_raw}) ;;
  }

  dimension: complete_count {
    type: number
    sql: ${TABLE}.complete_count ;;
  }

  measure: sum_complete_goal {
    description: "Sum of completed visits goal"
    type: sum
    sql: ${complete_count} ;;
  }

  dimension: complete_day {
    type: number
    sql: ${TABLE}.complete_day ;;
  }

  dimension: complete_seasonally_adjusted {
    type: number
    sql: ${TABLE}.complete_seasonally_adjusted ;;
  }

  dimension: complete_seasonally_adjusted_day {
    type: number
    sql: ${TABLE}.complete_seasonally_adjusted_day ;;
  }

  dimension: days_in_month {
    type: number
    sql: ${TABLE}.days_in_month ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension_group: month {
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
    sql: ${TABLE}.month ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: budget_projections_by_market_clone {
  sql_table_name: looker_scratch.budget_projections_by_market_clone ;;

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
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
    sql: ${TABLE}.month ;;
  }

  dimension: projected_visits {
    type: number
    sql: ${TABLE}.projected_visits ;;
  }

  measure: sum_projected_visits {
    type: sum_distinct
    sql_distinct_key: concat(${market_dim_id}, ${month_raw})  ;;
    sql: ${projected_visits} ;;

  }

  measure: count {
    type: count
    drill_fields: []
  }
  measure: projection_visits_month_to_date {
    type: number
    sql: ${sum_projected_visits}*${care_request_flat.month_percent} ;;
  }

  measure: projection_visits_daily_volume{
    label: "Daily Volume Needed for Budget"
    type: number
    sql: round(avg(${projected_visits}/DATE_PART('days',
        DATE_TRUNC('month', current_date)
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ))) ;;
  }


}

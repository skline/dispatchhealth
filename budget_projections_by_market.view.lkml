view: budget_projections_by_market {
  sql_table_name: looker_scratch.budget_projections_by_market ;;

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension_group: month {
    type: time
    convert_tz: no
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

  measure: projected_visits_measure {
    type: number
    sql: ${TABLE}.projected_visits ;;
  }

  measure: projection_visits_month_to_date {
    type: number
    sql: round(${budget_projections_by_market.projected_visits}*day(${visit_dimensions.max_billable_visit_date})/DAY(LAST_DAY(curdate())),0) ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}

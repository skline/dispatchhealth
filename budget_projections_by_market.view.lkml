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

  measure: count {
    type: count
    drill_fields: []
  }
}

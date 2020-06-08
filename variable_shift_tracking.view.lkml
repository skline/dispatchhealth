view: variable_shift_tracking {
  sql_table_name: looker_scratch.variable_shift_tracking ;;

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

  dimension: recommendation {
    type: number
    sql: ${TABLE}."recommendation" ;;
  }

  dimension: shift_name {
    type: string
    sql: ${TABLE}."shift_name" ;;
  }

  measure: count {
    type: count
    drill_fields: [shift_name]
  }
  measure: actual_vs_recommendation_diff {
    label: "Dashboard vs Recommendation Diff"
    value_format: "0.0"
    type: number
    sql: max(${recommendation})-${shift_teams.sum_shift_hours} ;;

  }
  measure: zizzl_vs_recommendation_diff {
    type: number
    value_format: "0.0"
    sql: max(${recommendation})-${zizzl_detailed_shift_hours.sum_direct_hours} ;;

  }
}

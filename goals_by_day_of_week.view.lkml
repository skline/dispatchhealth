view: goals_by_day_of_week {
  sql_table_name: looker_scratch.goals_by_day_of_week ;;

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
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

  dimension: sat_goal {
    type: number
    sql: ${TABLE}."sat_goal" ;;
  }

  dimension: sun_goal {
    type: number
    sql: ${TABLE}."sun_goal" ;;
  }

  dimension: weekday_goal {
    type: number
    sql: ${TABLE}."weekday_goal" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

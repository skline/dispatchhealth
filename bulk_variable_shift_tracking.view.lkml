view: bulk_variable_shift_tracking {
  sql_table_name: looker_scratch.bulk_variable_shift_tracking ;;

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

  dimension: hour {
    type: number
    sql: ${TABLE}."hour" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: recommendation {
    type: number
    sql: ${TABLE}."recommendation" ;;
  }

  dimension: total_hours {
    type: number
    sql: ${TABLE}."total_hours" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: date_placeholder {
  sql_table_name: looker_scratch.date_placeholder ;;

  dimension_group: date_placeholder {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date_placeholder" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

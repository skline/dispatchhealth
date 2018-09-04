view: csc_working_rate_week_clone {
  sql_table_name: looker_scratch.csc_working_rate_week_clone ;;

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension_group: week {
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
    sql: ${TABLE}.week ;;
  }

  dimension: working_rate {
    type: number
    sql: ${TABLE}.working_rate ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_name]
  }
}

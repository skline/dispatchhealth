view: csc_working_rate_month_clone {
  sql_table_name: looker_scratch.csc_working_rate_month_clone ;;

  dimension: agent_name {
    type: string
    sql: initcap(${TABLE}.agent_name) ;;
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

  measure: working_rate {
    type: number
    value_format: "0.0%"
    sql: max(${TABLE}.working_rate::float/100.0);;
  }

  measure: count {
    type: count
    drill_fields: [agent_name]
  }
}

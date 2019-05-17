view: intraday_monitoring {
  sql_table_name: looker_scratch.intraday_monitoring ;;

  dimension: complete_est {
    type: number
    sql: ${TABLE}.complete_est ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_date ;;
  }

  dimension: created_hour {
    type: number
    sql: ${TABLE}.created_hour ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: productivity_est {
    type: number
    sql: ${TABLE}.productivity_est ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

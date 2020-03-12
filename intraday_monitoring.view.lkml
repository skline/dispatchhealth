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
      year, day_of_week
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

  measure: diff_to_actual {
    type: number
    sql: max(${complete_est}) - ${care_request_flat.complete_count} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

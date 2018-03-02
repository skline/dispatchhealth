view: shift_hours_by_day_market_clone {
  sql_table_name: looker_scratch.shift_hours_by_day_market_clone ;;

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
    sql: ${TABLE}.date ;;
  }

  dimension: distinct_cars {
    type: number
    sql: ${TABLE}.distinct_cars ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}.market_name ;;
  }

  dimension: total_hours {
    type: number
    sql: ${TABLE}.total_hours ;;
  }

  measure: sum_total_hours {
    type: sum_distinct
    sql_distinct_key: concat(${market_name}, ${date_date}) ;;
    sql: ${TABLE}.total_hours  ;;
  }

  measure: productivity_target {
    label: ".5 productivity target"
    sql: ${sum_total_hours}*.5 ;;
  }

  measure: count {
    type: count
    drill_fields: [market_name]
  }
}

view: non_sem_cac_cost_month {
  sql_table_name: looker_scratch.non_sem_cac_cost_month ;;

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}

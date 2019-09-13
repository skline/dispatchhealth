view: market_start_date_bi {
  sql_table_name: looker_scratch.market_start_date_bi ;;

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension_group: market_start {
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
    sql: ${TABLE}.market_start_date ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

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

  dimension: mbo_2020_markets {
    type: yesno
    description: "The markets that are being tracked in 2020 for MBO's"
    sql: ${market_start_date} <= '2019-06-01' ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

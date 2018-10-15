view: market_start_date {
  sql_table_name: looker_scratch.market_start_date ;;

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
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
    sql: ${TABLE}.market_start ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  dimension: market_age {
    type:  number
    sql: extract(year from age(date_trunc('month', ${care_request_flat.complete_raw}), date_trunc('month',${market_start_raw})))*12 + extract(month from age(date_trunc('month', ${care_request_flat.complete_raw}), date_trunc('month',${market_start_raw}))) ;;
  }

  dimension: market_age_quarter {
    type: number
    value_format: "0"
    sql: floor(${market_age}/3) ;;
  }
}

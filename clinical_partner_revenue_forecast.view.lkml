view: clinical_partner_revenue_forecast {
  sql_table_name: looker_scratch.clinical_partner_revenue_forecast ;;

  dimension: cpr_before_offset {
    type: number
    sql: ${TABLE}.cpr_before_offset ;;
  }

  dimension: cpr_subject_to_offset {
    type: number
    sql: ${TABLE}.cpr_subject_to_offset ;;
  }

  dimension_group: financial_month {
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
    sql: ${TABLE}.financial_month ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

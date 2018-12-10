view: clinical_partner_revenue_forecast {
  sql_table_name: looker_scratch.clinical_partner_revenue_forecast ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.market_id, ' ', ${TABLE}.financial_month) ;;
  }

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

  measure: sum_cpr_pre_offset {
    type: sum
    sql: ${cpr_before_offset} ;;
  }

  measure: sum_cpr_post_offset {
    type: sum
    sql: ${cpr_subject_to_offset} ;;
  }

  measure: count_distinct_months {
    type: count_distinct
    sql: ${financial_month_month} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

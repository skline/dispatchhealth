view: labor_expense_by_month {
  sql_table_name: looker_scratch.labor_expense_by_month ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.market_id, ' ', ${reporting_month_month}) ;;
  }

  dimension: app_cost {
    type: number
    sql: ${TABLE}.app_cost ;;
  }

  dimension: app_hours {
    type: number
    sql: ${TABLE}.app_hours ;;
  }

  dimension: dhmt_cost {
    type: number
    sql: ${TABLE}.dhmt_cost ;;
  }

  dimension: dhmt_hours {
    type: number
    sql: ${TABLE}.dhmt_hours ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension_group: reporting_month {
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
    sql: ${TABLE}.reporting_month ;;
  }

  dimension_group: shift_month {
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
    sql: ${TABLE}.shift_month ;;
  }

  measure: sum_dhmt_hours {
    type: sum
    sql: ${dhmt_hours} ;;
  }

  measure: sum_dhmt_cost {
    type: sum
    sql: ${dhmt_cost} ;;
  }

  measure: sum_app_hours {
    type: sum
    sql: ${app_hours} ;;
  }

  measure: sum_app_cost {
    type: sum
    sql: ${app_cost} ;;
  }

  measure: count_distinct_months {
    type: count_distinct
    sql: ${reporting_month_month} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

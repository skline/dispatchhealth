view: regression_data {
  sql_table_name: looker_scratch.regression_data ;;

  dimension: billable_day {
    type: number
    sql: ${TABLE}.billable_day ;;
  }

  dimension: billable_visits {
    type: number
    sql: ${TABLE}.billable_visits ;;
  }

  dimension: days_in_month {
    type: number
    sql: ${TABLE}.days_in_month ;;
  }

  dimension: market_age_months {
    type: number
    sql: ${TABLE}.market_age_months ;;
  }

  dimension: market_age_squared {
    type: number
    sql: ${TABLE}.market_age_squared ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}.market_name ;;
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

  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }

  dimension: previous_billable {
    type: number
    sql: ${TABLE}.previous_billable ;;
  }

  dimension: previous_billable_day {
    type: number
    sql: ${TABLE}.previous_billable_day ;;
  }

  dimension: spring {
    type: number
    sql: ${TABLE}.spring ;;
  }

  dimension: summer {
    type: number
    sql: ${TABLE}.summer ;;
  }

  dimension: winter {
    type: number
    sql: ${TABLE}.winter ;;
  }

  measure: count {
    type: count
    drill_fields: [market_name]
  }
}

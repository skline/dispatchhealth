view: capacity_model_processed {
  sql_table_name: looker_scratch.capacity_model_processed ;;

  dimension: billable_visits {
    type: number
    sql: ${TABLE}.billable_visits ;;
  }

  dimension: channel_age_months {
    type: number
    sql: ${TABLE}.channel_age_months ;;
  }

  dimension: channel_dim_id {
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: channel_organization {
    type: string
    sql: ${TABLE}.channel_organization ;;
  }

  dimension: market_age_months {
    type: number
    sql: ${TABLE}.market_age_months ;;
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
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.month ;;
  }

  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }

  dimension: season {
    type: string
    sql: ${TABLE}.season ;;
  }

  measure: count {
    type: count
    drill_fields: [market_name]
  }
}

view: productivity_data {
  sql_table_name: looker_scratch.productivity_data ;;

  dimension: billable_visits {
    type: number
    sql: ${TABLE}.billable_visits ;;
  }

  dimension_group: created_ts {
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
    sql: ${TABLE}.created_ts ;;
  }

  dimension_group: date {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_month,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
  }

  dimension: dynamic_month {
    type: date
    sql: CASE
          WHEN ${date_day_of_month} = 1 THEN DATE_FORMAT(DATE_SUB(${date_raw}, INTERVAL 1 MONTH), "%Y-%m")
          ELSE ${date_month}
        END ;;
  }

  dimension: hours_worked {
    type: number
    sql: ${TABLE}.hours_worked ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: smfr_visits {
    type: number
    sql: ${TABLE}.smfr_visits ;;
  }

  dimension: goal {
    type: number
    sql: ${TABLE}.goal ;;
  }

  dimension: monthly_goal {
    type: number
    sql: ${TABLE}.monthly_goal ;;
  }

  dimension_group: updated_ts {

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
    sql: ${TABLE}.updated_ts ;;
  }

  measure: sum_billable_visits {
    type: sum
    sql: ${TABLE}.billable_visits ;;
  }

  measure: sum_of_goal {
    type: sum
    sql: ${TABLE}.goal ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

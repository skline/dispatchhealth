view: productivity_data_clone {
  sql_table_name: looker_scratch.productivity_data_clone ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(CAST(${TABLE}.date AS CHAR), CAST(${TABLE}.market_dim_id AS CHAR)) ;;
  }

  dimension: billable_visits {
    type: number
    sql: ${TABLE}.billable_visits ;;
  }

  measure: sum_billable_visits {
    type: sum
    sql: ${billable_visits} ;;
  }

  dimension: cpr_goal {
    type: number
    sql: ${TABLE}.cpr_goal ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: exp_allow_goal {
    type: number
    sql: ${TABLE}.exp_allow_goal ;;
  }

  dimension: ffs_goal {
    type: number
    sql: ${TABLE}.ffs_goal ;;
  }

  dimension: goal {
    type: number
    sql: ${TABLE}.goal ;;
  }

  dimension: hours_worked {
    type: number
    sql: ${TABLE}.hours_worked ;;
  }

  measure: sum_hours_worked {
    type: sum
    sql: ${hours_worked} ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: market_id {
    type: number

  }

  dimension: post_logistics_flag {
    type: yesno
    description: "A flag indicating the logistics platform was put into production"
    sql: (${market_dim_id} IN (160, 162, 165, 166) AND ${date_date} >= '2018-06-27') OR
    (${market_dim_id} = 161 AND ${date_date} >= '2018-07-30') OR
    (${market_dim_id} = 159 AND ${date_date} >= '2018-07-31') OR
    (${date_date} >= '2018-08-07')

  dimension: monthly_goal {
    type: number
    sql: ${TABLE}.monthly_goal ;;
  }

  dimension: smfr_hours_worked {
    type: number
    sql: ${TABLE}.smfr_hours_worked ;;
  }

  dimension: smfr_visits {
    type: number
    sql: ${TABLE}.smfr_visits ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

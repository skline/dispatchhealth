view: productivity_data {
  sql_table_name: looker_scratch.productivity_data ;;

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(CAST(${TABLE}.date AS CHAR), CAST(${TABLE}.market_dim_id AS CHAR)) ;;
  }

  dimension: billable_visits {
    type: number
    sql: ${TABLE}.billable_visits ;;
  }

  dimension: smfr_visits {
    type: number
    sql: ${TABLE}.smfr_visits ;;
  }

  dimension: wmfr_visits {
    type: number
    sql: ${TABLE}.wmfr_visits ;;
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
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
  }

  dimension: pre_post {
    type: yesno
    sql:DATE(${date_raw}) >= '2018-04-02' AND DATE(${date_raw}) <= '2018-04-13' ;;
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

  measure: sum_hours_worked {
    type: sum
    sql: ${hours_worked} ;;
  }

  dimension: smfr_hours_worked {
    type: number
    sql: ${TABLE}.smfr_hours_worked ;;
  }

  dimension: wmfr_hours_worked {
    type: number
    sql: ${TABLE}.wmfr_hours_worked ;;
  }

  measure: sum_smfr_hours_worked {
    type: sum
    sql: ${smfr_hours_worked} ;;
  }

  measure: sum_wmfr_hours_worked {
    type: sum
    sql: ${wmfr_hours_worked} ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: goal {
    type: number
    sql: ${TABLE}.goal ;;
  }

  dimension: monthly_goal {
    type: number
    sql: ${TABLE}.monthly_goal ;;
  }

  measure: sum_monthly_goal {
    description: "The sum of market monthly goals"
    type: sum
    sql: ${monthly_goal} ;;
  }

  dimension: ffs_goal {
    label: "Fee for Service Revenue Goal"
    type: number
    sql: ${TABLE}.ffs_goal ;;
  }

  dimension: exp_allowable_goal {
    label: "Expected Allowable Goal"
    type: number
    sql: ${TABLE}.exp_allow_goal ;;
  }

  dimension: cpr_revenue_goal {
    label: "Clinical Partner Revenue Goal"
    type: number
    sql: ${TABLE}.cpr_goal ;;
  }

  measure: sum_ffs_revenue_goal {
    label: "Total Fee for Service Revenue Goal"
    type: sum
    sql: ${ffs_goal};;
  }

  measure: avg_exp_allowable_goal {
    label: "Avg Expected Allowable Goal"
    type: average
    sql: ${TABLE}.exp_allow_goal ;;
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

  measure: avg_billable_visits {
    type: average
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

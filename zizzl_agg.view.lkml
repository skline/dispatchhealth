# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: zizzl_agg {
  derived_table: {
    explore_source: zizzl_detailed_shift_hours {
      column: counter_week {}
      column: counter_date {}
      column: counter_month {}
      column: counter_year {}
      column: shift_name {}
      column: name { field: cars.name }
      column: name_adj { field: markets.name_adj }
      column: cpr_market { field: markets.cpr_market }

      column: count_distinct {}
      column: sum_direct_hours {}
      column: sum_shift_hours { field: shift_teams.sum_shift_hours }
      column: dashboard_vs_zizzl_diff {}
      column: employee_id {}
      filters: {
        field: zizzl_detailed_shift_hours.position
        value: "advanced practice provider"
      }
      filters: {
        field: zizzl_detailed_shift_hours.dashboard_vs_zizzl_diff
        value: "[-2, 2]"
      }
      filters: {
        field: cars.name
        value: "-NULL"
      }
      filters: {
        field: zizzl_detailed_shift_hours.counter_month
        value: "6 months"
      }
      filters: {
        field: zizzl_detailed_shift_hours.shift_name
        value: "-%ADV%,-%WMFR%,-%SMFR%,-%adv%,-%Adv%,-%wmfr%,-%Wmfr%,-%Smfr%,-%smfr%"
      }
    }
  }
  dimension: counter_week {
    description: "The Zizzl employee shift date"
    type: date_week
  }
  dimension: counter_date {
    description: "The Zizzl employee shift date"
    type: date
  }

  dimension: cpr_market {
    description: "The Zizzl employee shift date"
    type: yesno
  }
  dimension: counter_month {
    description: "The Zizzl employee shift date"
    type: date_month
  }
  dimension: counter_year {
    description: "The Zizzl employee shift date"
    type: date_year
  }
  dimension: shift_name {
    description: "The Zizzl shift name (e.g. 'NP/PA/DEN01')"
  }
  dimension: name {}
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: count_distinct {
    type: number
  }
  dimension: sum_direct_hours {
    description: "The sum of all direct hours worked"
    value_format: "#,##0.00"
    type: number
  }
  dimension: sum_shift_hours {
    value_format: "0.0"
    type: number
  }
  dimension: dashboard_vs_zizzl_diff {
    value_format: "0.0"
    type: number
  }
  dimension: employee_id {
    description: "The primary key from the public users view"
    type: number
  }

  dimension: diff_from_10 {
    type: number
    sql: ${sum_shift_hours}-10 ;;
  }
  measure: avg_dashboard_vs_zizzl_diff {
    value_format: "0.00"
    type: average_distinct
    sql: ${dashboard_vs_zizzl_diff} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name}) ;;
  }
  measure: median_dashboard_vs_zizzl_diff {
    value_format: "0.00"
    type: median_distinct
    sql: ${dashboard_vs_zizzl_diff} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name}) ;;
  }

  measure: sum_dashboard_vs_zizzl_diff {
    value_format: "0.00"
    type: sum_distinct
    sql: ${dashboard_vs_zizzl_diff} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name}) ;;
  }

  measure: total_shifts {
    value_format: "0"
    type: count_distinct
    sql: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name});;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name}) ;;
  }

  measure: total_shift_hours {
    value_format: "0"
    type: sum_distinct
    sql: ${sum_shift_hours} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name}) ;;
  }

  measure: sum_diff_from_10 {
    value_format: "0"
    type: sum_distinct
    sql: ${diff_from_10} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}, ${name}) ;;
  }

  measure: sum_diff_from_10_minus_zizzl {
    value_format: "0"
    type: number
    sql: ${sum_diff_from_10}- ${sum_dashboard_vs_zizzl_diff};;
  }
}

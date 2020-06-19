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
        field: markets.cpr_market
        value: "No"
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
        value: "3 months"
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
  measure: avg_dashboard_vs_zizzl_diff {
    value_format: "0.0"
    type: average_distinct
    sql: ${dashboard_vs_zizzl_diff} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}) ;;
  }
  measure: median_dashboard_vs_zizzl_diff {
    value_format: "0.0"
    type: median_distinct
    sql: ${dashboard_vs_zizzl_diff} ;;
    sql_distinct_key: concat(${counter_date}, ${shift_name}, ${employee_id}) ;;
  }
}

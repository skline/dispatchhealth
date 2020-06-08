# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: variable_shift_agg {
  derived_table: {
    explore_source: variable_shift_tracking {
      column: date_date {}
      column: date_week {}
      column: date_month {}
      column: date_quarter {}
      column: date_year {}
      column: shift_name {}
      column: recommendation {}
      column: name_adj { field: markets.name_adj }
      column: sum_shift_hours { field: shift_teams.sum_shift_hours }
      column: actual_vs_recommendation_diff {}
      column: sum_direct_hours { field: zizzl_detailed_shift_hours.sum_direct_hours }
      column: zizzl_vs_recommendation_diff {}
      filters: {
        field: variable_shift_tracking.date_date
        value: "NOT NULL"
      }
    }
  }
  dimension: date_date {
    type: date
  }
  dimension: date_week {
    type: date_week
  }
  dimension: date_month {
    type: date_month
  }
  dimension: date_quarter {
    type: date_quarter
  }
  dimension: date_year {
    type: date_year
  }
  dimension: shift_name {}
  dimension: recommendation {
    type: number
  }
  dimension: name_adj {
    label: "Market"
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: sum_shift_hours {
    label: "Dashboard Hours"
    value_format: "0.0"
    type: number
  }
  dimension: actual_vs_recommendation_diff {
    label: "Variable Shift Tracking Dashboard vs Recommendation Diff"
    value_format: "0.0"
    type: number
  }
  dimension: sum_direct_hours {
    label: "Zizzl Hours"
    description: "The sum of all direct hours worked"
    value_format: "#,##0.00"
    type: number
  }
  dimension: zizzl_vs_recommendation_diff {
    value_format: "0.0"
    type: number
  }
  dimension: actual_vs_recommendation_diff_category {
    type: string
    label: "Dashboard vs Recommendation Diff Category"
    sql: case when ${actual_vs_recommendation_diff} < -2.5 then 'Likely Bad Data'
                when ${actual_vs_recommendation_diff} > 2.5 then 'Short Shift'
                when ${actual_vs_recommendation_diff} between -.5 and .5 then 'Followed'
                when ${actual_vs_recommendation_diff} <= -.5 then 'Shift Left Long'
                when ${actual_vs_recommendation_diff} >= .5 then 'Shift Left Short'
                else null end;;
  }

  dimension: zizzl_vs_recommendation_diff_category {
    type: string
    label: "Zizzl vs Recommendation Diff Category"
    sql: case when ${zizzl_vs_recommendation_diff} < -2.5 then 'Likely Bad Data'
                when ${zizzl_vs_recommendation_diff} > 7 then 'No Zizzl Data'
                when ${zizzl_vs_recommendation_diff} > 2.5 then 'Short Shift'
                when ${zizzl_vs_recommendation_diff} between -.5 and .5 then 'Followed'
                when ${zizzl_vs_recommendation_diff} <= -.5 then 'Shift Left Long'
                when ${zizzl_vs_recommendation_diff} >= .5 then 'Shift Left Short'
                else null end;;
  }
}

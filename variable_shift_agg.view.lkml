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
      column: dashboard_vs_zizzl_diff {}
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
    label: "Dashboard vs Recommendation Diff"
    value_format: "0.0"
    type: number
  }

  dimension: dashboard_downstaff_length {
    type: number
    sql: 10.0-${sum_shift_hours} ;;
  }

  dimension: recommendation_downstaff_length {
    type: number
    sql: 10.0-${recommendation} ;;
  }

  dimension: zizzl_downstaff_length {
    type: number
    sql: 10.0-${sum_direct_hours} ;;
  }

  measure: sum_actual_vs_recommendation_diff {
    value_format: "0.0"
    label: "Sum Dashboard vs Recommendation Diff"
    type: sum_distinct
    sql: ${actual_vs_recommendation_diff} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_zizzl_vs_recommendation_diff {
    value_format: "0.0"
    label: "Sum Zizzl vs Recommendation Diff"
    type: sum_distinct
    sql: ${zizzl_vs_recommendation_diff} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_dashboard_vs_zizzl_diff_diff {
    value_format: "0.0"
    label: "Sum Dashboard vs Zizzl Diff"
    type: sum_distinct
    sql: ${dashboard_vs_zizzl_diff} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_dashboard_downstaff_length {
    value_format: "0.0"
    type: sum_distinct
    sql: ${dashboard_downstaff_length} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_recommendation_downstaff_length {
    value_format: "0.0"
    type: sum_distinct
    sql: ${recommendation_downstaff_length} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_recommendation_downstaff_length_w_zizzl {
    value_format: "0.0"
    type: sum_distinct
    sql: ${recommendation_downstaff_length} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
    filters: {
      field: no_zizzl_data
      value: "no"
    }
  }

  measure: sum_dashboard_downstaff_length_w_zizzl{
    value_format: "0.0"
    type: sum_distinct
    sql: ${dashboard_downstaff_length} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
    filters: {
      field: no_zizzl_data
      value: "no"
    }
  }


  measure: sum_zizzl_downstaff_length {
    value_format: "0.0"
    type: sum_distinct
    sql: ${zizzl_downstaff_length} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: count_distinct_no_short_shifts {
    type: count_distinct
    sql: concat(${date_date}, ${shift_name});;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: count_distinct_w_zizzl {
    type: count_distinct
    sql: concat(${date_date}, ${shift_name});;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }

  }

  measure: count_distinct_dashboard_followed{
    type: count_distinct
    sql: concat(${date_date}, ${shift_name});;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: actual_vs_recommendation_diff_category
      value: "Followed"
    }
  }

  measure: count_distinct_zizzl_followed{
    type: count_distinct
    sql: concat(${date_date}, ${shift_name});;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: zizzl_vs_recommendation_diff_category
      value: "Followed"
    }
  }


  measure: count_distinct_zizzl_dashboard_match{
    type: count_distinct
    sql: concat(${date_date}, ${shift_name});;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: zizzl_vs_dashboard_diff_category
      value: "Followed"
    }
  }


  measure: percent_dashboard_followed {
    type: number
    value_format: "0%"
    sql: ${count_distinct_dashboard_followed}::float/${count_distinct_no_short_shifts}::float ;;

  }


  measure: percent_zizzl_followed {
    type: number
    value_format: "0%"
    sql: ${count_distinct_zizzl_followed}::float/${count_distinct_w_zizzl}::float ;;

  }

  measure: percent_zizzl_match_dashboard {
    type: number
    value_format: "0%"
    sql: ${count_distinct_zizzl_dashboard_match}::float/${count_distinct_w_zizzl}::float ;;

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

  dimension: dashboard_vs_zizzl_diff {
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

  dimension: no_zizzl_data{
    type: yesno
    sql:  ${zizzl_vs_recommendation_diff_category} in ('No Zizzl Data','Likely Bad Data')  ;;
  }

  dimension: short_shift_dashboard{
    type: yesno
    sql:  ${actual_vs_recommendation_diff_category} in('Short Shift', 'Likely Bad Data') ;;
  }
  dimension: zizzl_vs_dashboard_diff_category {
    type: string
    label: "Dashboard vs Zizzl Diff Category"
    sql: case when ${dashboard_vs_zizzl_diff} < -2.5 then 'Likely Bad Data'
                when ${dashboard_vs_zizzl_diff} > 7 then 'No Zizzl Data'
                when ${dashboard_vs_zizzl_diff} > 2.5 then 'Short Shift'
                when ${dashboard_vs_zizzl_diff} between -.5 and .5 then 'Followed'
                when ${dashboard_vs_zizzl_diff} <= -.5 then 'Shift Left Long'
                when ${dashboard_vs_zizzl_diff} >= .5 then 'Shift Left Short'
                else null end;;
  }

  measure: sum_dashboard_hours_w_zizzl{
    value_format: "0.0"
    label: "Sum Dashboard Hours w Zizzl"
    type: sum_distinct
    sql: ${sum_shift_hours} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_dashboard_hours{
    value_format: "0.0"
    label: "Sum Dashboard Hours"
    type: sum_distinct
    sql: ${sum_shift_hours} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_recommendation_hours_w_zizzl{
    value_format: "0.0"
    label: "Sum Recommendation Hours w Zizzl"
    type: sum_distinct
    sql: ${recommendation} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_recommendation_hours{
    value_format: "0.0"
    label: "Sum Recommendation Hours"
    type: sum_distinct
    sql: ${recommendation} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }

  measure: sum_zizzl_hours{
    value_format: "0.0"
    label: "Sum Zizzl Hours"
    type: sum_distinct
    sql: ${sum_direct_hours} ;;
    sql_distinct_key: concat(${date_date}, ${shift_name}) ;;
    filters: {
      field: no_zizzl_data
      value: "no"
    }
    filters: {
      field: short_shift_dashboard
      value: "no"
    }
  }


}

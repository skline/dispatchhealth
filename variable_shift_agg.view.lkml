view: variable_shift_agg {
    derived_table: {
      sql_trigger_value: SELECT MAX(created_at) FROM public.care_request_statuses ;;
      explore_source: variable_shift_tracking {
        column: date_date {}
        column: date_week {}
        column: date_month {}
        column: date_year {}
        column: shift_name {}
        column: recommendation {}
        column: name_adj { field: markets.name_adj }
        column: sum_shift_hours { field: shift_teams.sum_shift_hours }
        column: actual_vs_recommendation_diff {}
        filters: {
          field: variable_shift_tracking.date_date
          value: "NOT NULL"
        }
      }
    }
    dimension: date_date {
      label: "Date"
      type: date
    }

  dimension: date_week {
    label: "Week"
    type: date_week
  }

  dimension: date_month{
    label: "Month"
    type: date_month
  }

  dimension: date_year{
    label: "Year"
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
      value_format: "0.0"
      type: number
    }
    dimension: actual_vs_recommendation_diff {
      type: number
    }
    dimension: actual_vs_recommendation_diff_category {
      type: string
      sql: case when ${actual_vs_recommendation_diff} < 2.5 then 'Likely Bad Data'
                when ${actual_vs_recommendation_diff} > 2.5 then 'Short Shift'
                when ${actual_vs_recommendation_diff} between -.5 and .5 then 'Followed'
                when ${actual_vs_recommendation_diff} <= -.5 then 'Shift Left Long'
                when ${actual_vs_recommendation_diff} >= .5 then 'Shift Left Short'
                else null end;;
    }
  }

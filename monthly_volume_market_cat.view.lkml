# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: monthly_volume_market_cat {
  derived_table: {
    explore_source: care_requests {
      column: high_level_category { field: channel_items.high_level_category }
      column: name_adj { field: markets.name_adj }
      column: on_scene_month { field: care_request_flat.on_scene_month }
      column: complete_count { field: care_request_flat.complete_count }
      column: market_age { field: market_start_date.market_age }
      column: monthly_complete_run_rate_seasonal_adj { field: care_request_flat.monthly_complete_run_rate_seasonal_adj }
      column: monthly_visits_run_rate { field: care_request_flat.monthly_visits_run_rate }
      filters: {
        field: care_request_flat.on_scene_month
        value: "NOT NULL"
      }
      filters: {
        field: channel_items.high_level_category
        value: "-No Channel"
      }
      filters: {
        field: market_start_date.market_age
        value: "NOT NULL"
      }
    }
  }
  dimension: high_level_category {}
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: on_scene_month {
    description: "The local date/time that the care request team arrived on-scene"
    type: date_month
  }
  dimension: complete_count {
    type: number
  }
  dimension: market_age {
    description: "Age in months from market open"
    type: number
  }
  dimension: monthly_complete_run_rate_seasonal_adj {
    value_format: "#,##0"
    type: number
  }
  dimension: monthly_visits_run_rate {
    type: number
  }

  measure: avg_monthly_complete_run_rate_seasonal_adj {
    type: average_distinct
    value_format: "#,##0"
    sql: ${monthly_complete_run_rate_seasonal_adj} ;;
    sql_distinct_key: concat(${high_level_category}, ${on_scene_month}, ${market_age}, ${name_adj}) ;;
  }

  measure: avg_monthly_visits_run_rate {
    type: average_distinct
    value_format: "#,##0"
    sql: ${monthly_visits_run_rate} ;;
    sql_distinct_key: concat(${high_level_category}, ${on_scene_month}, ${market_age}, ${name_adj}) ;;
  }
}

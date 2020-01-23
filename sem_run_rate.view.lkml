# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: sem_run_rate {
  derived_table: {
    sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
    indexes: ["date_month", "id_adj"]
    explore_source: ga_adwords_cost_clone {
      column: date_month {}
      column: name_adj { field: markets.name_adj }
      column: ad_cost_monthly_run_rate {}
      column: id_adj { field: markets.id_adj }
    }
  }
  dimension: date_month {
    type: date_month
  }
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: ad_cost_monthly_run_rate {
    value_format: "$#;($#)"
    type: number
  }
  dimension: id_adj {
    description: "Market ID where WMFR is included as part of Denver (159)"
  }
}

# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: overflow_by_day_market {
  derived_table: {
    indexes: ["name", "created_date"]
    explore_source: care_requests {
      column: name { field: markets.name }
      column: created_date { field: care_request_flat.created_date }
      column: count_distinct {}
      filters: {
        field: care_request_flat.overflow_visit
        value: "Yes"
      }
      filters: {
        field: care_request_flat.created_date
        value: "180 days ago for 180 days"
      }
    }
  }
  dimension: name {
    label: "market name"
  }
  dimension: created_date {
    description: "The local date/time that the care request was created."
    type: date
  }
  dimension: count_distinct {
    type: number
  }

  measure: overflow_visits {
    type: sum_distinct
    sql: ${count_distinct} ;;
    sql_distinct_key: concat(${name}, ${created_date}) ;;
  }
}

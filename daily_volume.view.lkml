# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: daily_volume {
  derived_table: {
    explore_source: care_requests {
      column: name_adj { field: markets.name_adj }
      column: on_scene_date { field: care_request_flat.on_scene_date }
      column: complete_count { field: care_request_flat.complete_count }
      filters: {
        field: care_request_flat.on_scene_date
        value: "NOT NULL"
      }
      filters: {
        field: care_request_flat.on_scene_date
        value: "NOT NULL"
      }
      filters: {
        field: service_lines.name
        value: "-COVID-19 Facility Testing,-Advanced Care"
      }
    }
  }
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: on_scene_date {
    description: "The local date/time that the care request team arrived on-scene"
    type: date
  }
  dimension: complete_count {
    type: number
  }
  measure: max_complete_count {
    type: number
    sql: max(${complete_count}) ;;
  }
}

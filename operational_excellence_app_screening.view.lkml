# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: operational_excellence_app_screening {
  derived_table: {
    explore_source: care_requests {
      column: first_name { field: secondary_screening_provider.first_name }
      column: last_name { field: secondary_screening_provider.last_name }
      column: escalated_on_phone_count { field: care_request_flat.escalated_on_phone_count }
      column: escalated_on_scene_count { field: care_request_flat.escalated_on_scene_count }
      column: count_distinct {}
      column: created_month { field: care_request_flat.created_month }
      column: market_name {field:markets.name_adj}
      filters: {
        field: care_request_flat.created_date
        value: "2 months ago for 2 months"
      }
      filters: {
        field: care_request_flat.secondary_screening
        value: "Yes"
      }
      filters: {
        field: care_requests.count_distinct
        value: ">=12"
      }
    }
  }
  dimension: first_name {
    type: string
  }
  dimension: last_name {
    type: string
  }
  dimension: escalated_on_phone_count {
    type: number
  }
  measure: sum_escalated_on_phone {
    description: "The sum of all phone escalations"
    type: sum
    sql: ${escalated_on_phone_count} ;;
  }
  dimension: escalated_on_scene_count {
    type: number
  }
  measure: sum_escalated_on_scene {
    description: "The sum of all on scene escalations"
    type: sum
    sql: ${escalated_on_scene_count} ;;
  }
  dimension: count_distinct {
    type: number
    description: "Count of distinct care requests"
  }
  measure: sum_care_requests {
    type: sum
    description: "The sum of all care requests"
    sql: ${count_distinct} ;;
  }

  dimension: created_month {
    description: "The local date/time that the care request was created."
    type: date_month
  }
  dimension: market_name {
    type: string
  }
}

# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: productivity_agg {
  derived_table: {
    explore_source: shift_teams {
      column: start_date {}
      column: sum_shift_hours_no_arm_advanced {}
      column: complete_count { field: care_request_flat.complete_count }
      column: complete_count_no_arm_advanced { field: care_request_flat.complete_count_no_arm_advanced }
      column: count_wmfr_billable { field: care_requests.count_wmfr_billable }
      column: count_smfr_billable { field: care_requests.count_smfr_billable }
      column: complete_count_advanced { field: care_request_flat.complete_count_advanced }
      column: productivity {}
      column: sum_goal_volume {}
      column: name_adj { field: markets.name_adj }
      column: cpr_market { field: markets.cpr_market }
      column: count_complete_overflow { field: care_request_flat.count_complete_overflow }
      column: escalated_on_scene_count { field: care_request_flat.escalated_on_scene_count }
      filters: {
        field: shift_teams.start_date
        value: "30 days ago for 30 days"
      }
      filters: {
        field: service_lines.name
        value: "-COVID-19 Facility Testing"
      }
    }
  }
  dimension: start_date {
    type: date
  }
  dimension: sum_shift_hours_no_arm_advanced {
    label: "Shift Teams Sum Shift Hours (no arm, advanced or tele)"
    value_format: "0.0"
    type: number
  }

  measure: total_shift_hours_no_arm_advanced {
    type: sum_distinct
    value_format: "0.0"
    sql: ${sum_shift_hours_no_arm_advanced} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }
  dimension: complete_count {
    type: number
  }
  dimension: complete_count_no_arm_advanced {
    label: "Care Request Flat Complete Count (no arm, advanced or tele)"
    type: number
  }
  measure: total_complete_count_no_arm_advanced {
    type: sum_distinct
    sql: ${complete_count_no_arm_advanced} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }
  measure: total_productivity {
    type: number
    value_format: "0.00"
    sql: ${total_complete_count_no_arm_advanced}::float/${total_shift_hours_no_arm_advanced}::float ;;
  }
  dimension: count_wmfr_billable {
    type: number
  }
  dimension: count_smfr_billable {
    type: number
  }
  dimension: complete_count_advanced {
    type: number
  }
  dimension: productivity {
    value_format: "0.00"
    type: number
  }
  dimension: sum_goal_volume {
    type: number
  }
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: cpr_market {
    label: "Markets Cpr Market (Yes / No)"
    description: "Flag to identify CPR markets (hard-coded)"
    type: yesno
  }
  dimension: count_complete_overflow {
    description: "Count of completed care requests OR on-scene escalations (Not Same Day)"
    type: number
  }
  dimension: escalated_on_scene_count {
    type: number
  }
}

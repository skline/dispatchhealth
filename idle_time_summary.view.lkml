# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: idle_time_summary {
  derived_table: {
    explore_source: care_requests {
      column: id { field: shift_teams.id }
      column: name { field: cars.name }
      column: start_date { field: shift_teams.start_date }
      column: start_time_of_day { field: shift_teams.start_time_of_day }
      column: start_time { field: shift_teams.start_time }
      column: productivity { field: shift_teams.productivity }
      column: count_board_optimizer_requests {}
      column: sum_shift_hours { field: shift_teams.sum_shift_hours }
      column: first_accepted_decimal { field: care_request_flat.first_accepted_decimal }
      column: count_billable_est {}
      column: total_drive_time_minutes { field: care_request_flat.total_drive_time_minutes }
      column: total_on_scene_time_minutes { field: care_request_flat.total_on_scene_time_minutes }
      column: shift_end_last_cr_diff_adj {}
      column: sum_break_time_minutes { field: breaks.sum_break_time_minutes }
      column: shift_start_first_on_route_diff {}
      column: average_drive_time_minutes { field: care_request_flat.average_drive_time_minutes }
      column: name_smfr { field: markets.name_smfr }
      filters: {
        field: cars.name
        value: "-SMFR_Car,-WMFR CAR,-Denver_Advanced Care"
        }
        filters: {
        field: shift_teams.start_date
        value: "90 days ago for 90 days"
      }
    }
  }
  dimension: id {
    type: number
  }
  dimension: name {}
  dimension_group: start_date {
    type: time
    convert_tz: no
  }
  dimension: start_time_of_day {
    type: date_time_of_day
  }
  dimension: start_time {
    type: date_time
  }
  dimension: productivity {
    value_format: "0.00"
    type: number
  }
  dimension: count_board_optimizer_requests {
    description: "A count of all care requests that were assigned by the board optimizers"
    type: number
  }
  dimension: sum_shift_hours {
    value_format: "0.0"
    type: number
  }
  dimension: first_accepted_decimal {
    description: "The first accepted time of day, represented as a decimal"
    value_format: "0.00"
    type: number
  }
  dimension: count_billable_est {
    description: "Count of completed care requests OR on-scene escalations"
    type: number
  }
  dimension: total_drive_time_minutes {
    description: "The number of minutes between on-route time and on-scene time"
    value_format: "0.0"
    type: number
  }
  dimension: total_on_scene_time_minutes {
    description: "The sum of minutes between complete time and on scene time"
    value_format: "0.00"
    type: number
  }
  dimension: shift_end_last_cr_diff_adj {
    label: "Care Requests Hours between Last Patient Seen and Shift End Adj"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    type: number
  }
  dimension: sum_break_time_minutes {
    description: "Sum of the total number of break minutes"
    value_format: "0.00"
    type: number
  }
  dimension: shift_start_first_on_route_diff {
    label: "Care Requests Hours Between Shift Start and First On Route"
    value_format: "0.00"
    type: number
  }
  dimension: average_drive_time_minutes {
    description: "The average minutes between on-route time and on-scene time"
    value_format: "0"
    type: number
  }
  dimension: name_smfr {
    description: "market name"
    type: string
  }

  dimension: intraday_dead_time {
    type: number
    sql: (${sum_shift_hours} - ${shift_start_first_on_route_diff} - ((${total_on_scene_time_minutes} + ${total_drive_time_minutes} + ${sum_break_time_minutes})/60) + ${shift_end_last_cr_diff_adj})*60 ;;
  }
  measure: sum_intraday_dead_time{
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${intraday_dead_time} ;;

  }

}

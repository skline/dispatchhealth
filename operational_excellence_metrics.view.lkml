# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: operational_excellence_metrics {
  derived_table: {
    explore_source: care_requests {
      column: shift_team_id { field: care_request_flat.shift_team_id }
      column: shift_start_day_of_week { field: care_request_flat.shift_start_day_of_week }
      column: shift_start_month { field: care_request_flat.shift_start_month }
      column: shift_start_date { field: care_request_flat.shift_start_date }
      column: market_name { field: markets.name }
      column: car_name { field: cars.name }
      column: shift_start_time { field: care_request_flat.shift_start_time }
      column: shift_start_time_of_day { field: care_request_flat.shift_start_time_of_day }
      column: shift_end_time { field: care_request_flat.shift_end_time }
      column: shift_end_time_of_day { field: care_request_flat.shift_end_time_of_day }
      column: last_update_time_time { field: shifts_end_of_shift_times.last_update_time_time }
      column: shift_included_break { field: breaks.shift_included_break }
      column: start_time { field: breaks.start_time }
      column: end_time { field: breaks.end_time }
      column: break_time_minutes { field: breaks.break_time_minutes }
      column: shift_start_decimal { field: care_request_flat.shift_start_decimal }
      column: shift_end_decimal { field: care_request_flat.shift_end_decimal }
      column: max_on_scene_time {}
      column: shift_start_first_on_route_diff {}
      column: shift_end_last_cr_diff_adj {}
      column: first_accepted_decimal { field: care_request_flat.first_accepted_decimal }
      column: min_on_route_time {}
      column: app_car_staff { field: cars.app_car_staff }
      column: emt_car_staff { field: cars.emt_car_staff }
      column: count_billable_est {}
      column: total_drive_time_minutes_google { field: care_request_flat.total_drive_time_minutes_google }
      column: total_on_scene_time_minutes { field: care_request_flat.total_on_scene_time_minutes }
      filters: {
        field: provider_profiles.position
        value: "emt,advanced practice provider"
      }
      filters: {
        field: markets.name
        value: "Denver,Colorado Springs,Las Vegas"
      }
      filters: {
        field: care_request_flat.shift_start_date
        value: "2 months ago for 2 months"
      }
    }
  }
  dimension: shift_team_id {
    type: number
  }
  dimension: shift_start_day_of_week {
    description: "The local date/time of a shift start"
    #type: date_day_of_week
    type: string
  }
  dimension: shift_start_month {
    description: "The local date/time of a shift start"
    type: date_month
  }
  dimension: baseline_month {
    description: "A flag indicating that the month is the baseline month"
    type: yesno
    sql: ${shift_start_month} = '2019-04' ;;
  }
  dimension: shift_start_date {
    description: "The local date/time of a shift start"
    type: date
  }
  dimension: car_name {
    type: string
  }
  dimension: market_name {
    type: string
  }

  dimension: shift_start_time {
    description: "The local date/time of a shift start"
    type: date_time
  }
  dimension: shift_start_time_of_day {
    description: "The local date/time of a shift start"
    type: date_time_of_day
  }
  dimension: shift_end_time {
    description: "The local date/time of a shift end"
    type: date_time
  }
  dimension: shift_end_time_of_day {
    description: "The local date/time of a shift end"
    type: date_time_of_day
  }
  dimension: last_update_time_time {
    description: "The local date and time when the care request team is back at the office"
    type: date_time
  }
  dimension: shift_included_break {
    label: "Breaks Shift Included Break (Yes / No)"
    description: "A break was taken duirng the duration of the shift"
    type: yesno
  }
  dimension: start_time {
    type: date_time
  }
  dimension: end_time {
    type: date_time
  }
  dimension: break_time_minutes {
    description: "number of minutes between break start time and break end time"
    value_format: "0.00"
    type: number
  }
  dimension: shift_start_decimal {
    description: "The shift start time of day, represented as a decimal"
    value_format: "0.00"
    type: number
  }
  dimension: shift_end_decimal {
    description: "The shift start time of day, represented as a decimal"
    value_format: "0.00"
    type: number
  }
  dimension: shift_hours {
    description: "The total shift hours"
    value_format: "0.00"
    type: number
    sql: ${shift_end_decimal} - ${shift_start_decimal} ;;
  }
  measure: sum_shift_hours {
    description: "The sum of all shift hours"
    value_format: "0.00"
    type: sum_distinct
    sql_distinct_key: ${shift_team_id} ;;
    sql: ${shift_hours} ;;
  }
  dimension: max_on_scene_time {
    label: "Care Requests Last Care Request Completed Time"
    type: number
  }
  dimension: shift_start_first_on_route_diff {
    label: "Care Requests Hours Between Shift Start and First On Route"
    type: number
  }
  dimension: shift_end_last_cr_diff_adj {
    label: "Care Requests Hours between Last Patient Seen and Shift End Adj"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    type: number
  }
  dimension: first_accepted_decimal {
    description: "The first accepted time of day, represented as a decimal"
    value_format: "0.00"
    type: number
  }
  dimension: min_on_route_time {
    label: "Care Requests First Care Request On Route Time"
    type: number
  }
  dimension: app_car_staff {
    type: string
  }
  dimension: emt_car_staff {
    type: string
  }
  dimension: count_billable_est {
    description: "Count of completed care requests OR on-scene escalations"
    type: number
  }
  dimension: total_drive_time_minutes_google {
    description: "The sum of drive time from Google in minutes"
    value_format: "0.00"
    type: number
  }
  measure: sum_google_drive_time {
    description: "The sum of all Google drive time"
    value_format: "0.00"
    type: sum_distinct
    sql_distinct_key: ${shift_team_id} ;;
    sql: ${total_drive_time_minutes_google} ;;
  }
  dimension: total_on_scene_time_minutes {
    description: "The sum of minutes between complete time and on scene time"
    value_format: "0.00"
    type: number
  }
  measure: sum_on_scene_time {
    description: "The sum of all on-scene times"
    value_format: "0.00"
    type: sum_distinct
    sql_distinct_key: ${shift_team_id} ;;
    sql: ${total_on_scene_time_minutes} ;;
  }
    dimension: cr_assigned_at_shift_start {
      description: "A flag indicating that the care team was assigned a patient at shift start"
      type: yesno
      sql: ${first_accepted_decimal} <= ${shift_start_decimal} ;;
    }

  measure: avg_shift_start_first_on_route {
    label: "Average Hours Between Shift Start and First On Route"
    description: "The avg number of hours between shift starting and first on route"
    type: average
    sql: ${shift_start_first_on_route_diff} ;;
    value_format: "0.00"
  }

  measure: sum_shift_start_first_on_route {
    label: "Sum Hours Between Shift Start and First On Route"
    description: "The Sum of hours between shift starting and first on route"
    type: sum_distinct
    sql_distinct_key: ${shift_team_id} ;;
    sql: ${shift_start_first_on_route_diff} ;;
    value_format: "0.00"
  }

  measure: avg_shift_end_last_cr_diff_adj {
    label: "Average Hours Between last Care Request and Shift End"
    description: "The avg number of hours between the completion of the last care request and shift end"
    type: average
    sql: ${shift_end_last_cr_diff_adj} ;;
    value_format: "0.00"
  }

  measure: sum_shift_end_last_cr_diff_adj {
    label: "Sum of Hours Between last Care Request and Shift End"
    description: "The sum of hours between the completion of the last care request and shift end"
    type: sum_distinct
    sql_distinct_key: ${shift_team_id} ;;
    sql: ${shift_end_last_cr_diff_adj} ;;
    value_format: "0.00"
  }


  measure: avg_shift_start_first_on_route_baseline {
    label: "Average Hours Between Shift Start and First On Route (April 2019 Baseline)"
    description: "The avg number of hours between shift starting and first on route"
    type: average
    sql: ${shift_start_first_on_route_diff} ;;
    value_format: "0.00"
    filters: {
      field: baseline_month
      value: "yes"
    }
  }

  measure: avg_shift_start_first_on_route_non_baseline {
    label: "Average Hours Between Shift Start and First On Route (Non-Baseline)"
    description: "The avg number of hours between shift starting and first on route"
    type: average
    sql: ${shift_start_first_on_route_diff} ;;
    value_format: "0.00"
    filters: {
      field: baseline_month
      value: "no"
    }
  }

  measure: count_distinct_shifts {
    description: "The count of distinct shift ID's"
    type: count_distinct
    sql: ${shift_team_id} ;;
  }
}

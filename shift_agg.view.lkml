# If necessary, uncommentf the line below to include explore_source.
# include: "dashboard.model.lkml"

view: shift_agg {
  derived_table: {
    explore_source: care_requests {
      column: shift_start_date { field: care_request_flat.shift_start_date }
      column: shift_start_day_of_week { field: care_request_flat.shift_start_day_of_week }
      column: name { field: cars.name }
      column: shift_start_time { field: care_request_flat.shift_start_time }
      column: shift_start_time_of_day { field: care_request_flat.shift_start_time_of_day }
      column: shift_end_time { field: care_request_flat.shift_end_time }
      column: shift_end_time_of_day { field: care_request_flat.shift_end_time_of_day }
      column: last_update_time_time { field: shifts_end_of_shift_times.last_update_time_time }
      column: max_on_scene_time {}
      column: shift_start_first_on_route_diff {}
      column: shift_end_last_cr_diff_adj {}
      column: first_accepted_decimal { field: care_request_flat.first_accepted_decimal }
      column: min_on_route_time {}
      column: app_car_staff { field: cars.app_car_staff }
      column: count_billable_est {}
      column: name_adj { field: markets.name_adj }
      column: cpr_market { field: markets.cpr_market }
      column: emt_car_staff { field: cars.emt_car_staff }
      column: total_drive_time_minutes_coalesce { field: care_request_flat.total_drive_time_minutes_coalesce }
      column: total_on_scene_time_minutes { field: care_request_flat.total_on_scene_time_minutes }
      filters: {
        field: provider_profiles.position
        value: "advanced practice provider,emt"
      }
      filters: {
        field: care_request_flat.shift_start_date
        value: "30 days ago for 30 days"
      }
      filters: {
        field: service_lines.name
        value: "-Advanced Care,-COVID-19 Facility Testing"
      }
      filters: {
        field: cars.name
        value: "-%Swab%,-%Advanced%,-%MFR%"
      }
    }
  }
  dimension: shift_start_date {
    description: "The local date/time of a shift start"
    type: date
  }

  dimension: shift_start_day_of_week {
    type: string
  }

  dimension: name {
    label: "Car Name"
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
  dimension: max_on_scene_time {
    label: "Care Requests Last Care Request Completed Time"
    type: number
  }
  dimension: shift_start_first_on_route_diff {
    label: "Care Requests Hours Between Shift Start and First On Route"
    value_format: "0.00"
    type: number
  }
  dimension: shift_end_last_cr_diff_adj {
    label: "Care Requests Hours between Last Patient Seen and Shift End Adj"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    type: number
  }

  dimension: shift_end_last_cr_diff_positive {
    label: "Care Requests Hours between Last Patient Seen and Shift End positive"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    type: number
    sql: ${shift_end_last_cr_diff_adj}*-1 ;;
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
    type: number
  }
  dimension: count_billable_est {
    description: "Count of completed care requests OR on-scene escalations"
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
  dimension: emt_car_staff {
    type: number
  }
  dimension: total_drive_time_minutes_coalesce {
    description: "google drive time if available, otherwise regular drive time"
    value_format: "0.0"
    type: number
  }
  dimension: total_on_scene_time_minutes {
    description: "The sum of minutes between complete time and on scene time"
    value_format: "0.00"
    type: number
  }

  dimension: shift_hours {
    type: number
    value_format: "0.0"
    sql:EXTRACT(EPOCH FROM (${shift_end_time}::timestamp- ${shift_start_time}::timestamp))::float/(60.0*60.0);;
  }

  dimension: shift_productivity {
    type: number
    sql: ${count_billable_est}::float / ${shift_hours}::float;;
  }

  dimension: productive_shift_hours {
    type: number
    sql: ${shift_hours} + ${shift_end_last_cr_diff_adj} - ${shift_start_first_on_route_diff};;
  }

  dimension: shift_productivity_no_dead_time {
    type: number
    sql: ${count_billable_est} / (${shift_hours} + ${shift_end_last_cr_diff_adj} - ${shift_start_first_on_route_diff});;
  }


  dimension: care_request_assigned_at_shift_start {
    type: yesno
    sql: if(${first_accepted_decimal} < extract_hours(${shift_start_time}) + extract_minutes(${shift_start_time}), 1, 0);;
  }

  dimension: minutes_early_or_late {
    type: yesno
    sql: diff_minutes(${last_update_time_time}, ${shift_end_time});;
  }

  dimension: hours_to_first_assignment {
    type: number
    sql: ${first_accepted_decimal} - (extract(hour from timestamp ${shift_start_time}::timestamp)+ extract(minute from timestamp ${shift_start_time}::timestamp));;
  }

  dimension: dead_time {
    type: number
    value_format: "0"
    sql: ${shift_hours}*60 - ${total_drive_time_minutes_coalesce} -${total_on_scene_time_minutes} ;;
  }

  dimension: dead_time_percent {
    type: number
    value_format: "0%"
    sql: ${dead_time}::float/(${shift_hours}*60)::float ;;
    }


  measure: avg_dead_time{
    type: average_distinct
    value_format: "0"
    sql: ${dead_time} ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: avg_dead_time_percent{
    type: average_distinct
    value_format: "0%"
    sql: ${dead_time_percent} ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: avg_shift_start_first_on_route_diff{
    label: "Deadtime Start of Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${shift_start_first_on_route_diff}*60 ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: avg_shift_shift_end_last_cr_diff_positive{
    label: "Deadtime End of Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${shift_end_last_cr_diff_positive}::float*60 ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: avg_dead_time_intra_shift{
    label: "Deadtime Intra Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${dead_time_intra_shift} ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: sum_total_on_scene_time_minutes {
    label: "Sum of All Of Scene Time"
    type: sum_distinct
    value_format: "0.00"
    sql: ${total_on_scene_time_minutes} ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: sum_total_drivetime_minutes {
    label: "Sum of All Of Drive Time"
    type: sum_distinct
    value_format: "0.00"
    sql: ${total_drive_time_minutes_coalesce} ;;
    sql_distinct_key: concat(${shift_start_time}, ${name}, ${name_adj}) ;;
  }

  measure: avg_on_scene_hours{
    label: "On-Scene Time Minutes (avg)"
    type: number
    value_format: "0"
    sql: ${sum_total_on_scene_time_minutes}::float/${productivity_agg.total_complete_count_no_arm_advanced} ;;
  }

  measure: avg_drivetime_hours{
    label: "Drivetime Minutes (avg)"
    type: number
    value_format: "0"
    sql: ${sum_total_drivetime_minutes}::float/${productivity_agg.total_complete_count_no_arm_advanced} ;;
  }




  dimension: dead_time_intra_shift {
    type: number
    sql: (${shift_hours}*60 - ${total_drive_time_minutes_coalesce} -${total_on_scene_time_minutes} + ${shift_end_last_cr_diff_adj}*60 - ${shift_start_first_on_route_diff}*60) ;;
  }


}

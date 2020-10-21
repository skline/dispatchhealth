view: granular_shift_tracking {
  sql_table_name: looker_scratch.granular_shift_tracking ;;

  dimension: accept_time_of_day {
    type: number
    sql: ${TABLE}."accept_time_of_day" ;;
  }

  dimension: app_car_staff {
    type: string
    sql: ${TABLE}."app_car_staff" ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}."car_id" ;;
  }

  dimension: car_name {
    type: string
    sql: ${TABLE}."car_name" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension: complete_bool {
    type: number
    sql: ${TABLE}."complete_bool" ;;
  }

  dimension: complete_time_of_day {
    type: number
    sql: ${TABLE}."complete_time_of_day" ;;
  }

  dimension: diff_on_route_to_last_action {
    type: number
    sql: ${TABLE}."diff_on_route_to_last_action" ;;
  }

  dimension: drive_time_minutes {
    type: number
    sql: ${TABLE}."drive_time_minutes" ;;
  }

  dimension: emt_car_staff {
    type: string
    sql: ${TABLE}."emt_car_staff" ;;
  }

  dimension: first_accepted_bool {
    type: number
    sql: ${TABLE}."first_accepted_bool" ;;
  }

  dimension: last_care_request_bool {
    type: number
    sql: ${TABLE}."last_care_request_bool" ;;
  }

  dimension: last_update_time_time_of_day {
    type: number
    sql: ${TABLE}."last_update_time_time_of_day" ;;
  }

  dimension: on_route_time_of_day {
    type: number
    sql: ${TABLE}."on_route_time_of_day" ;;
  }

  dimension: on_scene_minutes {
    type: number
    sql: ${TABLE}."on_scene_minutes" ;;
  }

  dimension: on_scene_time_of_day {
    type: number
    sql: ${TABLE}."on_scene_time_of_day" ;;
  }

  dimension: patient_assigned_bool {
    type: number
    sql: ${TABLE}."patient_assigned_bool" ;;
  }

  dimension: prior_complete_time {
    type: number
    sql: ${TABLE}."prior_complete_time" ;;
  }

  dimension: resolved_reason_full {
    type: string
    sql: ${TABLE}."resolved_reason_full" ;;
  }

  dimension_group: shift {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."shift_date" ;;
  }

  dimension: shift_end_time_of_day {
    type: number
    sql: ${TABLE}."shift_end_time_of_day" ;;
  }

  dimension: shift_start_time_of_day {
    type: number
    sql: ${TABLE}."shift_start_time_of_day" ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}."shift_team_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [car_name]
  }
}

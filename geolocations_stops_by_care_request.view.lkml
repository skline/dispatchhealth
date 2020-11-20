view: geolocations_stops_by_care_request {
  derived_table: {
    sql:
    SELECT
    shift_teams_id AS shift_team_id,
    car_id,
    unnest(care_request_ids) AS care_request_id,
    num_care_requests,
    ROUND(SUM(minutes_stopped)::numeric,1) AS on_scene_time,
    ROUND((SUM(minutes_stopped) / num_care_requests::float)::numeric,1) AS stop_time_per_care_request
    FROM geolocation.stops_summary
    GROUP BY 1,2,3,4;;

      indexes: ["shift_team_id", "car_id", "care_request_id"]
      sql_trigger_value: SELECT MAX(geolocations_id) FROM geolocation.stops_summary ;;
  }

  dimension: care_request_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: num_care_requests_at_location {
    type: number
    description: "The number of care requests seen at the same location"
    sql: ${TABLE}.num_care_requests ;;
  }

  measure: count_distinct_care_requests {
    type: count_distinct
    description: "The count of all distinct care requests.  May not match billable_est
    due to inability to match certain care requests to car stops"
  }

  dimension: on_scene_time {
    type: number
    description: "The total stop time for the care request.
      Total stop time is divided by the number of patients when multiple patients are treated
      at the same location"
    value_format: "0.0"
    sql: ${TABLE}.on_scene_time ;;
  }

  measure: total_on_scene_time {
    type: sum_distinct
    description: "The sum of all car stop times for care requests"
    sql_distinct_key: ${care_request_id} ;;
    sql: ${on_scene_time} ;;
  }

  measure: average_on_scene_time {
    type: average_distinct
    sql_distinct_key: ${care_request_id} ;;
    description: "The average of all car stop times for care requests"
    sql: ${on_scene_time} ;;
  }

  measure: on_scene_time_25th_percentile {
    type: percentile_distinct
    percentile: 25
    sql_distinct_key: ${care_request_id} ;;
    sql: ${on_scene_time} ;;
  }

  measure: on_scene_time_75th_percentile {
    type: percentile_distinct
    percentile: 75
    sql_distinct_key: ${care_request_id} ;;
    sql: ${on_scene_time} ;;
  }



}

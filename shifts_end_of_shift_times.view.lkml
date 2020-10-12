view: shifts_end_of_shift_times {
  derived_table: {
    sql:
SELECT
  st.id AS shift_team_id,
  gl.car_id,
  cars.name AS car_name,
  m.name AS market_name,
  tz.pg_tz,
  DATE(gl.updated_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz) AS shift_date,
  MAX(gl.updated_at) AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS last_update_time
  FROM geo_locations gl
  LEFT JOIN cars
    ON gl.car_id = cars.id
  LEFT JOIN markets m
    ON cars.market_id = m.id
  LEFT JOIN looker_scratch.timezones tz
    ON m.sa_time_zone = tz.rails_tz
  LEFT JOIN shift_teams st
    ON gl.car_id = st.car_id AND
       DATE(gl.updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') = DATE(st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain')
  GROUP BY 1,2,3,4,5,6 ;;

  sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
  indexes: ["shift_team_id"]
  }

  dimension: shift_team_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension_group: last_update_time {
    type: time
    description: "The local date and time when the care request team is back at the office"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.last_update_time ;;
  }

  dimension: mins_early_or_late {
    type: number
    description: "The number of minutes between shift end time and back at office time"
    sql: (EXTRACT(EPOCH FROM ${care_request_flat.shift_end_raw})-EXTRACT(EPOCH FROM ${last_update_time_raw}))::float/60.0 ;;
    value_format: "0"
  }

  measure: count_late_shifts {
    type: count_distinct
    sql: ${shift_team_id} ;;
    filters: {
      field: mins_early_or_late
      value: "< 0"
    }
  }

  measure: median_mins_early_late {
    description: "The median number of minutes between shift end and time back at the office (positive=early, negative=late)"
    type: median
    sql: ${mins_early_or_late} ;;
    value_format: "0"
  }

  dimension: early_late_tier {
    type: tier
    tiers: [-60, -45, -30, -15, 0, 15, 30, 45, 60, 75]
    style: integer
    sql: ${mins_early_or_late} ;;
  }

  measure: count_shifts {
    type: count_distinct
    sql: ${shift_team_id} ;;
  }

}

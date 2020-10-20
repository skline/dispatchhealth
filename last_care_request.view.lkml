view: last_care_request {
  derived_table: {
    sql:
  SELECT
  cr.market_id,
  cr.last_care_request_id,
  cr.shift_team_id,
  crs.updated_at AS complete_time
  FROM
    (SELECT
      cr.id AS last_care_request_id,
      cr.market_id,
      cr.shift_team_id,
      crs.updated_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS complete_time,
      ROW_NUMBER() OVER(PARTITION BY cr.market_id, DATE(crs.updated_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz),
      cr.shift_team_id ORDER BY cr.market_id, cr.shift_team_id, crs.updated_at DESC) AS rn
    FROM care_requests cr
    LEFT JOIN care_request_statuses crs
      ON cr.id = crs.care_request_id AND crs.name = 'complete'
    LEFT JOIN markets m
      ON cr.market_id = m.id
    LEFT JOIN looker_scratch.timezones tz
      ON m.sa_time_zone = tz.rails_tz) AS cr
  JOIN
    (SELECT
      care_request_id,
      name,
      MIN(updated_at) AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS updated_at
    FROM care_request_statuses
    WHERE name = 'complete'
    GROUP BY 1,2) crs
    ON cr.last_care_request_id = crs.care_request_id AND cr.rn = 1 ;;

      sql_trigger_value: SELECT MAX(id) FROM care_requests ;;
      indexes: ["last_care_request_id"]
    }

  dimension: last_care_request_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.last_care_request_id ;;
  }

  dimension: last_care_request_flag {
    type: yesno
    sql: ${last_care_request_id} IS NOT NULL ;;
  }

  dimension_group: complete {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_month
    ]
    sql: ${TABLE}.complete_time ;;
  }

  dimension: hrs_btwn_last_cr_eos {
    label: "Hours Btwn Last Pt and Shift End > 90 Min"
    type: yesno
    sql:  (((EXTRACT(EPOCH FROM ${complete_raw}::timestamp - ${care_request_flat.shift_end_time}::timestamp)))/3600)::decimal <= -1.50 ;;
  }

  dimension: last_complete_to_last_updated_mins {
    description: "The time between the the last completed care request time stamp and the last updated time stamp (arrived back at office)"
    type: number
    sql: (EXTRACT(EPOCH FROM ${shifts_end_of_shift_times.last_update_time_raw}) - EXTRACT(EPOCH FROM ${last_care_request.complete_raw}))/60 ;;
    value_format: "0.0"
  }

  measure: avg_last_complete_to_last_updated_mins {
    description: "The time between the the last completed care request time stamp and the last updated time stamp (arrived back at office)"
    type: average_distinct
    sql: ${last_complete_to_last_updated_mins} ;;
    value_format: "0.0"
  }

  dimension: last_complete_to_shift_end_mins {
    description: "The time between the the last completed care request time stamp and the last updated time stamp (arrived back at office)"
    type: number
    sql: (EXTRACT(EPOCH FROM ${care_request_flat.shift_end_raw}) - EXTRACT(EPOCH FROM ${last_care_request.complete_raw}))/60 ;;
    value_format: "0.0"
  }

  measure: avg_last_complete_to_shift_end_mins {
    description: "The time between the the last completed care request time stamp and the last updated time stamp (arrived back at office)"
    type: average_distinct
    sql: ${last_complete_to_shift_end_mins} ;;
    value_format: "0.0"
  }




}

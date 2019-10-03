view: shift_team_stops {
  derived_table: {
    sql: WITH stops AS (
    SELECT
    geo.shift_team_id,
    CASE WHEN care.care_request_id IS NOT NULL THEN 'care request'
      WHEN brk.id IS NOT NULL THEN 'break'
      ELSE 'other'
    END AS stop_type,
    geo.car_id,
    care.care_request_id,
    geo.stop_time,
    geo.start_time,
    care.accepted_time,
    care.completed_time,
    COUNT(DISTINCT
      CASE WHEN care.accepted_time < geo.stop_time AND geo.stop_time < care.completed_time THEN care.care_request_id
        ELSE NULL
      END) AS assigned_care_requests,
    COUNT(DISTINCT latitude) AS num_stops,
    COUNT(DISTINCT care.care_request_id) AS num_care_requests,
    ROUND(SUM(geo.minutes_stopped)::int) AS total_stop_time,
    ROUND(MAX(geo.minutes_stopped)::int) AS max_stop_time
    FROM looker_scratch.shift_stop_times AS geo
    LEFT JOIN (
      SELECT
        cr.id AS care_request_id,
        st.id AS shift_team_id,
        st.car_id,
        MAX(cra.started_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS accepted_time,
        MAX(cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS on_scene_time,
        MAX(crc.started_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS completed_time
        FROM public.care_requests cr
        JOIN public.care_request_statuses cra
            ON cr.id = cra.care_request_id AND cra.name = 'accepted'
        JOIN public.care_request_statuses cros
            ON cr.id = cros.care_request_id AND cros.name = 'on_scene'
        JOIN public.care_request_statuses crc
            ON cr.id = crc.care_request_id AND crc.name = 'complete'
        LEFT JOIN public.shift_teams st
            ON cr.shift_team_id = st.id
        LEFT JOIN public.markets mkt
            ON cr.market_id = mkt.id
        LEFT JOIN looker_scratch.timezones tz
            ON mkt.sa_time_zone = tz.rails_tz
        GROUP BY 1,2,3
        ORDER BY 4) AS care
    ON care.shift_team_id = geo.shift_team_id AND care.completed_time >= geo.stop_time AND care.on_scene_time <= geo.start_time
    LEFT JOIN public.breaks brk
        ON geo.shift_team_id = brk.shift_team_id AND brk.start_time AT TIME ZONE 'UTC' AT TIME ZONE geo.timezone <= geo.start_time
        AND brk.end_time AT TIME ZONE 'UTC' AT TIME ZONE geo.timezone >= geo.stop_time
    --WHERE geo.shift_team_id = 20335
    GROUP BY 1,2,3,4,5,6,7,8
    ORDER BY 5)

SELECT
  shift_team_id,
  stop_type,
  car_id,
  SUM(num_stops) AS num_stops,
  COUNT(DISTINCT care_request_id) AS num_care_requests,
  SUM(total_stop_time) AS total_stop_time,
  MAX(max_stop_time) AS max_stop_time,
  SUM(CASE WHEN stop_type <> 'care request' AND num_assigned > 0 THEN 1 ELSE 0 END) AS stops_with_assigned_cr
  FROM (
    SELECT
      stops.*,
      COUNT(DISTINCT(fut.care_request_id)) AS num_assigned
      FROM stops
      LEFT JOIN stops AS fut
        ON stops.shift_team_id = fut.shift_team_id AND stops.stop_type <> 'care request' AND fut.stop_type = 'care request'
           AND fut.accepted_time < stops.stop_time AND stops.stop_time < fut.completed_time
      GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
      ORDER BY stops.stop_time) AS ss
  WHERE shift_team_id IS NOT NULL
  GROUP BY 1,2,3
  ORDER BY 1,2 ;;

      sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;
      indexes: ["shift_team_id"]
    }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.shift_team_id::varchar, ' ', ${TABLE}.stop_type) ;;
  }

    dimension: shift_team_id {
      type: number
      sql: ${TABLE}.shift_team_id ;;
    }

    dimension: stop_type {
      type: string
      sql: ${TABLE}.stop_type ;;
    }

    dimension: num_stops {
      type: number
      sql: ${TABLE}.num_stops ;;
    }

    dimension: num_care_requests {
      type: number
      sql: ${TABLE}.num_care_requests ;;
    }

    dimension: total_stop_time {
      type: number
      sql: ${TABLE}.total_stop_time ;;
    }

    dimension: max_stop_time {
      type: number
      sql: ${TABLE}.max_stop_time ;;
    }

    dimension: stops_with_assigned_cr {
      type: number
      sql: ${TABLE}.stops_with_assigned_cr ;;
    }

    measure: num_shifts {
      type: count_distinct
      sql: ${shift_team_id} ;;
    }

    measure: total_stops {
      type: sum
      description: "The total number of stops"
      sql: ${num_stops} ;;
    }

    measure: total_stops_with_assigned_cr {
      description: "The total number of stops where at least 1 care request is currently assigned"
      type: sum
      sql: ${stops_with_assigned_cr} ;;
    }

    measure: avg_number_other_stops {
      type: average
      sql: ${num_stops} ;;
      filters: {
        field: stop_type
        value: "other"
      }
    }

    measure: avg_stop_time {
      type: number
      sql: SUM(${total_stop_time}) / SUM(${num_stops}) ;;
      value_format: "0.00"
    }



}

view: shift_team_stops {
  derived_table: {
    sql: WITH stops AS (
SELECT
    geo.id,
    geo.shift_team_id,
    geo.latitude,
    geo.longitude,
    CASE WHEN care.care_request_id IS NOT NULL THEN 'care request'
      WHEN brk.id IS NOT NULL THEN 'break'
      ELSE 'other'
    END AS stop_type,
    geo.car_id,
    care.care_request_id,
    care.market_id,
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
        mkt.id AS market_id,
        MAX(cra.started_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS accepted_time,
        MAX(cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS on_scene_time,
        MIN(crc.started_at AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS completed_time
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
        GROUP BY 1,2,3,4
        ORDER BY 5) AS care
    ON care.shift_team_id = geo.shift_team_id AND care.completed_time >= geo.stop_time AND care.on_scene_time <= geo.start_time
    LEFT JOIN public.breaks brk
        ON geo.shift_team_id = brk.shift_team_id AND brk.start_time AT TIME ZONE 'UTC' AT TIME ZONE geo.timezone <= geo.start_time
        AND brk.end_time AT TIME ZONE 'UTC' AT TIME ZONE geo.timezone >= geo.stop_time
    --WHERE geo.shift_team_id = 28166
    WHERE geo.shift_team_id IS NOT NULL
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
    ORDER BY 1,5
    )

SELECT
                MIN(stops.id) AS id,
                stops.shift_team_id,
                ROUND(ad.latitude::numeric,5) AS latitude,
                ROUND(ad.longitude::numeric,5) AS longitude,
                stop_type,
                car_id,
                care_request_id,
                market_id,
                MIN(stop_time) AS stop_time,
                MAX(start_time) AS start_time,
                accepted_time,
                completed_time,
                MAX(assigned_care_requests) AS assigned_care_requests,
                np.total_stop_time,
                np.num_patients,
                np.total_stop_time / np.num_patients AS on_scene_time
            FROM stops
            LEFT JOIN public.addressable_items ai
                ON stops.care_request_id = ai.addressable_id
            LEFT JOIN public.addresses ad
                ON ai.address_id = ad.id
            LEFT JOIN (
            SELECT
                shift_team_id,
                ROUND(ad.latitude::numeric,5) AS latitude,
                ROUND(ad.longitude::numeric,5) AS longitude,
                COUNT(DISTINCT care_request_id) AS num_patients,
                SUM(total_stop_time) AS total_stop_time
            FROM stops
            LEFT JOIN public.addressable_items ai
                ON stops.care_request_id = ai.addressable_id
            LEFT JOIN public.addresses ad
                ON ai.address_id = ad.id
            WHERE stop_type = 'care request'
            GROUP BY 1,2,3) np
                ON ROUND(ad.latitude::numeric,5) = np.latitude AND ROUND(ad.longitude::numeric,5) = np.longitude
            WHERE stop_type = 'care request'
            GROUP BY 2,3,4,5,6,7,8,11,12,14,15,16
    UNION ALL (
            SELECT
                id,
                shift_team_id,
                latitude,
                longitude,
                stop_type,
                car_id,
                care_request_id,
                market_id,
                stop_time,
                start_time,
                accepted_time,
                completed_time,
                assigned_care_requests,
                total_stop_time,
                0 AS num_patients,
                NULL AS on_scene_time
            FROM stops
            WHERE stop_type <> 'care request')
ORDER BY 2,9;;

      sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;
      indexes: ["shift_team_id"]
    }

  dimension: concat_primary_id {
    primary_key: yes
    hidden: yes
    type: string
    #sql: CONCAT(${TABLE}.id::varchar, ' ', COALESCE(${TABLE}.care_request_id::varchar, '0')) ;;
    sql: COALESCE(${care_request_id}::varchar, ${id}::varchar) ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

    dimension: shift_team_id {
      type: number
      sql: ${TABLE}.shift_team_id ;;
    }

    dimension: care_request_id {
      type: number
      sql: ${TABLE}.care_request_id ;;
    }

    dimension: stop_type {
      type: string
      sql: ${TABLE}.stop_type ;;
    }

    dimension: total_stop_time {
      type: number
      sql: ${TABLE}.total_stop_time ;;
    }

    dimension: num_patients {
      type: number
      sql: ${TABLE}.num_patients ;;
    }

    dimension: on_scene_time {
      type: number
      sql: ${TABLE}.on_scene_time ;;
    }

    dimension: latitude {
      type: number
      sql: ${TABLE}.latitude ;;
    }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: stop_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

    measure: num_shifts {
      type: count_distinct
      sql: ${shift_team_id} ;;
    }

  measure: num_stops {
    type: count_distinct
    sql: ${concat_primary_id} ;;
  }

    measure: avg_stop_time {
      type: average_distinct
      sql: ${total_stop_time} ;;
      value_format: "0.00"
    }

    measure: avg_on_scene_time {
      type: average_distinct
      sql: ${on_scene_time} ;;
      value_format: "0.0"
    }



}

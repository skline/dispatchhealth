view: stop_times_by_care_request {
    derived_table: {
      sql: WITH care AS (
    SELECT
        cr.id AS care_request_id,
        st.id AS shift_team_id,
        st.car_id,
        mkt.id AS market_id,
        ROUND(ad.latitude::numeric,5) AS latitude,
        ROUND(ad.longitude::numeric,5) AS longitude,
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
        LEFT JOIN public.addressable_items ai
            ON cr.id = ai.addressable_id AND ai.addressable_type = 'CareRequest'
        LEFT JOIN public.addresses ad
            ON ai.address_id = ad.id
        LEFT JOIN public.shift_teams st
            ON cr.shift_team_id = st.id
        LEFT JOIN public.markets mkt
            ON cr.market_id = mkt.id
        LEFT JOIN looker_scratch.timezones tz
            ON mkt.sa_time_zone = tz.rails_tz
        --WHERE st.id = 28199
        GROUP BY 1,2,3,4,5,6
        ORDER BY 5
        )

SELECT
    crd.*,
    np.num_patients,
    np.distance,
    np.total_stop_time,
    np.total_stop_time / np.num_patients AS on_scene_time
    FROM (
        SELECT
            geo.shift_team_id,
            care.care_request_id,
            care.car_id,
            care.market_id,
            care.latitude,
            care.longitude,
            MIN(geo.stop_time) AS stop_time,
            MAX(geo.start_time) AS start_time
        FROM looker_scratch.shift_stop_times AS geo
        LEFT JOIN care
            ON care.shift_team_id = geo.shift_team_id AND
               care.completed_time >= geo.stop_time AND
               care.on_scene_time <= geo.start_time
        --WHERE geo.shift_team_id IN (28199) AND care.care_request_id IS NOT NULL
        WHERE care.care_request_id IS NOT NULL
        GROUP BY 1,2,3,4,5,6) AS crd
    LEFT JOIN (
        SELECT
            geo.shift_team_id,
            care.latitude,
            care.longitude,
            MIN(ROUND(((ACOS(SIN(RADIANS(geo.latitude )) * SIN(RADIANS(care.latitude)) +
            COS(RADIANS(geo.latitude)) * COS(RADIANS(care.latitude)) * COS(RADIANS(care.longitude - geo.longitude))) * 6371) / 1.60934)::numeric, 4)) AS distance,
            COUNT(DISTINCT care.care_request_id) AS num_patients,
            ROUND(SUM(DISTINCT geo.minutes_stopped)::int) AS total_stop_time
        FROM looker_scratch.shift_stop_times AS geo
        LEFT JOIN care
            ON care.shift_team_id = geo.shift_team_id AND
               care.completed_time >= geo.stop_time AND
               care.on_scene_time <= geo.start_time
        --WHERE geo.shift_team_id IN (28199) AND care.care_request_id IS NOT NULL
        WHERE care.care_request_id IS NOT NULL
        GROUP BY 1,2,3) AS np
            ON crd.shift_team_id = np.shift_team_id AND
               crd.latitude = np.latitude AND
               crd.longitude = np.longitude
        ORDER BY 1 DESC;;

        sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;
        indexes: ["shift_team_id","care_request_id","market_id","car_id"]
      }

    dimension: shift_team_id {
      type: number
      sql: ${TABLE}.shift_team_id ;;
    }

  dimension: care_request_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: num_patients {
    type: number
    sql: ${TABLE}.num_patients ;;
  }

  dimension: total_stop_time {
    type: number
    sql: ${TABLE}.total_stop_time ;;
  }

  dimension: on_scene_time {
    type: number
    value_format: "0.0"
    sql: ${TABLE}.on_scene_time ;;
  }

  dimension: actual_minus_pred_on_scene {
    type: number
    description: "The actual (car stop time) on scene time minus predicted on scene time"
    sql: ${on_scene_time} - ${care_request_flat.mins_on_scene_predicted} ;;
  }

  dimension: real_minus_pred_tier {
    type: tier
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${actual_minus_pred_on_scene} ;;
    }

  measure: sum_patients {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: total_on_scene_time {
    type: sum_distinct
    value_format: "0.0"
    sql: ${on_scene_time} ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  measure: avg_on_scene_time {
    type: average_distinct
    value_format: "0.0"
    sql: ${on_scene_time} ;;
    sql_distinct_key: ${care_request_id} ;;
  }

}

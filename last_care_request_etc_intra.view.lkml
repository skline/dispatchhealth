view: last_care_request_etc_intra {
  derived_table: {
    sql:
    SELECT DISTINCT
  st.shift_team_id,
  st.car_id,
  lcr.market_id,
  lcr.last_timestamp,
  lcr.current_status,
  lcr.pt_latitude,
  lcr.pt_longitude,
  lcr.etos
  FROM public.intraday_shift_teams st
  JOIN
        (SELECT
          care_request_id,
          (meta_data ->> 'market_id')::integer AS market_id,
          (meta_data ->> 'shift_team_id')::integer AS shift_team_id,
          (meta_data ->> 'etc')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS last_etc,
          (meta_data ->> 'completed_at')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS completed_at,
          COALESCE((meta_data ->> 'etc')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain',
                   (meta_data ->> 'completed_at')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain', NULL) AS last_timestamp,
          (meta_data ->> 'latitude')::float8 AS pt_latitude,
          (meta_data ->> 'longitude')::float8 AS pt_longitude,
          (meta_data ->> 'etos')::integer AS etos,
          (meta_data ->> 'current_queue') AS current_queue,
          (meta_data ->> 'current_status') AS current_status,
          ROW_NUMBER() OVER(
                PARTITION BY (meta_data ->> 'shift_team_id')::integer
                ORDER BY COALESCE((meta_data ->> 'etc')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain',
                   (meta_data ->> 'completed_at')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain', NULL) DESC) AS rn
        FROM public.intraday_care_requests icr
        JOIN public.intraday_shift_teams ist
          ON (meta_data ->> 'shift_team_id')::integer = ist.shift_team_id
        WHERE DATE(ist.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') = DATE 'today' AND
        --(meta_data ->> 'market_id')::integer = 159 AND
        COALESCE((meta_data ->> 'etc')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain',
                   (meta_data ->> 'completed_at')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain', NULL) IS NOT NULL
        GROUP BY 1,2,3,4,5,7,8,9,10,11) AS lcr
  ON st.shift_team_id = lcr.shift_team_id AND lcr.rn = 1
  WHERE st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' > current_date - interval '1 day'
  GROUP BY 1,2,3,4,5,6,7,8
  ORDER BY st.shift_team_id ;;
    }

  dimension: shift_team_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: current_status {
    type: string
    sql: ${TABLE}.current_status ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension: etos {
    type: number
    sql: ${TABLE}.etos ;;
  }

  dimension_group: last_etc {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour_of_day,
      time_of_day,
      date,
      week,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.last_timestamp;;
  }

  dimension: pt_latitude {
    type: number
    sql: ${TABLE}.pt_latitude ;;
  }

  dimension: pt_longitude {
    type: number
    sql: ${TABLE}.pt_longitude ;;
  }

  dimension: pt_location {
    type: location
    sql_latitude: ${pt_latitude} ;;
    sql_longitude: ${pt_longitude} ;;
  }


}

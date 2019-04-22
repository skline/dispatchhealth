view: shifts_end_of_shift_times {
  derived_table: {
    sql:
    SELECT DISTINCT
  st.shift_team_id,
  st.car_id,
  lcr.market_id,
  lcr.last_etc,
  lcr.pt_latitude,
  lcr.pt_longitude
  FROM public.intraday_shift_teams st
  JOIN
        (SELECT
          care_request_id,
          (meta_data ->> 'market_id')::integer AS market_id,
          (meta_data ->> 'shift_team_id')::integer AS shift_team_id,
          (meta_data ->> 'etc')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS last_etc,
          (meta_data ->> 'latitude') AS pt_latitude,
          (meta_data ->> 'longitude') AS pt_longitude,
          ROW_NUMBER() OVER(PARTITION BY (meta_data ->> 'shift_team_id')::integer ORDER BY (meta_data ->> 'etc')::timestamp DESC) AS rn
        FROM public.intraday_care_requests
        WHERE created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' > current_date - interval '1 day' AND
        (meta_data ->> 'etc')::timestamp IS NOT NULL) AS lcr
  ON st.shift_team_id = lcr.shift_team_id AND lcr.rn = 1
  WHERE st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' > current_date - interval '1 day'
  GROUP BY 1,2,3,4,5,6
  ORDER BY st.shift_team_id ;;
    }

  dimension: shift_team_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
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
    sql: ${TABLE}.last_etc;;
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

view: shift_routes {
  derived_table: {
    sql:
      SELECT
        f.*,
        EXTRACT(EPOCH FROM (
            (lead(update_time, 1, update_time) OVER (partition by market_id, car_id, CAST(update_time AS date) ORDER BY market_id, car_id, update_time))
            - (update_time)))::float/60.0 AS time_difference,
        CAST(market_id AS text)||CAST(car_id AS text)||CAST(DATE(update_time) AS text) AS p_key
      FROM
      (SELECT
         mkt.id AS market_id,
         stm.car_id,
         MAX(crs.started_at) AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS update_time,
         MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS complete_time,
         CASE
           WHEN ABS((EXTRACT(EPOCH FROM comp.started_at)-EXTRACT(EPOCH FROM crs.started_at))::float/60.0) < 241
           THEN (EXTRACT(EPOCH FROM comp.started_at)-EXTRACT(EPOCH FROM crs.started_at))::float/60.0
           ELSE NULL
         END AS mins_on_scene,
         a.latitude,
         a.longitude,
         1 AS care_request_location
         FROM care_requests cr
         JOIN care_request_statuses crs
           ON cr.id = crs.care_request_id AND crs.name = 'on_scene'
         JOIN care_request_statuses comp
           ON cr.id = comp.care_request_id AND comp.name = 'complete'
         JOIN addressable_items ai
           ON cr.id = ai.addressable_id AND ai.addressable_type = 'CareRequest'
         JOIN addresses a
           ON ai.address_id = a.id AND ai.addressable_type = 'CareRequest'
         JOIN shift_teams stm
           ON cr.shift_team_id = stm.id
         LEFT JOIN markets mkt
           ON cr.market_id = mkt.id
         LEFT JOIN looker_scratch.timezones tzs
           ON mkt.sa_time_zone = tzs.rails_tz
         WHERE mkt.id IS NOT NULL
         GROUP BY 1,2,5,6,7,8, pg_tz
        UNION
        SELECT
          m.id AS market_id,
          gl.car_id,
          gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS update_time,
          NULL AS complete_time,
          0 AS mins_on_scene,
          gl.latitude,
          gl.longitude,
          0 AS care_request_location
        FROM geo_locations gl
        LEFT JOIN shift_teams st
          ON st.car_id = gl.car_id AND DATE(st.start_time) = DATE(gl.created_at)
        LEFT JOIN cars
          ON gl.car_id = cars.id
        LEFT JOIN markets m
          ON cars.market_id = m.id
        LEFT JOIN looker_scratch.timezones tz
          ON m.sa_time_zone = tz.rails_tz) AS f
        ORDER BY market_id, car_id, update_time DESC ;;

    sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
    indexes: ["market_id", "car_id"]
  }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CAST(${market_id} AS text)||CAST(${car_id} AS text)||CAST(DATE(${update_time}) AS text) ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension: care_request_location {
    type: number
    sql: ${TABLE}.care_request_location ;;
  }

  dimension: mins_on_scene {
    type: number
    sql: ${TABLE}.mins_on_scene ;;
    value_format: "0.00"
  }

  dimension_group: update {
    type: time
    description: "The local date and time when latitude/longitude was updated"
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
    sql: ${TABLE}.update_time ;;
  }

  dimension_group: complete {
    type: time
    description: "The local date and time when latitude/longitude was updated"
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
    sql: ${TABLE}.complete_time ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: car_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: time_difference {
    type: number
    sql: ${TABLE}.time_difference ;;
    value_format: "0.00"
  }

  measure: avg_time_difference {
    type: average
    sql: ${time_difference} ;;
    value_format: "0.00"
  }

  dimension: distance_to_office {
    type: distance
    start_location_field: car_location
    end_location_field: markets.office_location
    units: miles
  }

}

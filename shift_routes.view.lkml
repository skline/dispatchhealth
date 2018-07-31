view: shift_routes {
  derived_table: {
    sql:
      SELECT
        mkt.id AS market_id,
        stm.car_id,
        crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS update_time,
        a.latitude,
        a.longitude,
        1 AS care_request_location
        FROM care_requests cr
        JOIN care_request_statuses crs
          ON cr.id = crs.care_request_id AND crs.name = 'on_scene'
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
        UNION
        SELECT
          m.id AS market_id,
          gl.car_id,
          gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS update_time,
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
          ON m.sa_time_zone = tz.rails_tz
        WHERE random() <= 0.25 ;;

    sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
    indexes: ["market_id", "car_id"]
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

}

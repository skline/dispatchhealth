view: on_route_locations {
  derived_table: {
    sql:
    WITH geo AS (
SELECT
  car_id,
  latitude,
  longitude,
  updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS updated_time,
  LEAD(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain',1) OVER
      (PARTITION BY car_id, DATE(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') ORDER BY car_id, updated_at)
      AS next_time,
  (EXTRACT(EPOCH FROM LEAD(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain',1) OVER
      (PARTITION BY car_id, DATE(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') ORDER BY car_id, updated_at))
  - EXTRACT(EPOCH FROM updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain'))/60 AS time_difference
  FROM geo_locations
  WHERE DATE(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') >= '2019-06-01'
  ORDER BY (EXTRACT(EPOCH FROM LEAD(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain',1) OVER
      (PARTITION BY car_id, DATE(updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') ORDER BY car_id, updated_at))
  - EXTRACT(EPOCH FROM updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain'))/60 DESC)

SELECT
    cr.market_id,
    st.id AS shift_team_id,
    cars.id AS car_id,
    cars.name,
    cr.id AS care_request_id,
    geo.latitude AS on_route_latitude,
    geo.longitude AS on_route_longitude,
    ROW_NUMBER() OVER (PARTITION BY cr.shift_team_id ORDER BY cr.shift_team_id, crs.started_at) AS care_request_number,
    LAG(adr.latitude,1, mgl.latitude) OVER(PARTITION BY st.id ORDER BY st.id, crs.started_at) AS prior_cr_latitude,
    LAG(adr.longitude,1, mgl.longitude) OVER(PARTITION BY st.id ORDER BY st.id, crs.started_at) AS prior_cr_longitude,
    geo.next_time AS geo_on_route_time,
    geo.time_difference,
    MAX(crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') AS on_route_time
    FROM care_requests cr
    JOIN care_request_statuses crs
        ON cr.id = crs.care_request_id AND crs.name = 'on_route'
    LEFT JOIN looker_scratch.market_geo_locations mgl
        ON cr.market_id = mgl.market_id
    LEFT JOIN shift_teams st
        ON cr.shift_team_id = st.id
    LEFT JOIN cars
        ON st.car_id = cars.id
    LEFT JOIN addressable_items ai
        ON cr.id = ai.addressable_id AND ai.addressable_type = 'CareRequest'
    LEFT JOIN addresses adr
        ON ai.address_id = adr.id
    LEFT JOIN geo
        ON cars.id = geo.car_id AND
        crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' > geo.updated_time AND
        crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' <= next_time
    WHERE DATE(crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') >= '2019-06-01'
    GROUP BY 1,2,3,4,5,6,7,crs.started_at,adr.latitude, adr.longitude, mgl.latitude, mgl.longitude,11,12
    ORDER BY 1,2,12 ;;

      sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;
      indexes: ["care_request_id", "market_id", "shift_team_id"]
    }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: care_request_order {
    description: "The order of the shift team's care request"
    type: number
    sql: ${TABLE}.care_request_number ;;
  }

  dimension_group: geo_on_route_time {
    convert_tz: no
    description: "The timestamp when the car began going on-route"
    type:time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.geo_on_route_time ;;
  }

  dimension_group: on_route_time {
    convert_tz: no
    description: "The timestamp when the care team indicated they were going on-route"
    type:time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_route_time ;;
  }

  dimension: on_route_lag {
    description: "The difference between indicated on-route time and actual on-route"
    type: number
    sql: (EXTRACT(EPOCH FROM ${geo_on_route_time_raw}) - EXTRACT(EPOCH FROM ${on_route_time_raw})) / 60 ;;
    value_format: "0.00"
  }

  measure: avg_on_route_lag {
    description: "The average time difference between indicated on-route and actual on-route"
    type: average
    sql: ${on_route_lag} ;;
    value_format: "0.00"
  }

  measure: median_on_route_lag {
    description: "The median time difference between indicated on-route and actual on-route"
    type: median
    sql: ${on_route_lag} ;;
    value_format: "0.00"
  }

  dimension: care_request_location {
    type: location
    description: "The location of the last care request"
    sql_latitude: ${TABLE}.prior_cr_latitude ;;
    sql_longitude: ${TABLE}.prior_cr_longitude ;;
  }

  dimension: on_route_location {
    type: location
    description: "The location where the care team was located when they indicated on-route"
    sql_latitude: ${TABLE}.on_route_latitude ;;
    sql_longitude: ${TABLE}.on_route_longitude ;;
  }

  dimension: distance_from_cr_to_actual {
    type: distance
    description: "The distance between last care request and actual on-route locations"
    start_location_field: care_request_location
    end_location_field: on_route_location
    units: miles
    value_format: "0.00"
  }


  dimension: different_on_route_location {
    description: "A flag indicating that the actual on route location is > 0.25 miles from the last care request"
    type: yesno
    sql: ${distance_from_cr_to_actual} >= 0.25 ;;
  }

}

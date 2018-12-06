view: care_request_distances {
  derived_table: {
    sql: SELECT
    markets.id AS market_id,
    cr.id as care_request_id,
    tz.timezone,
    cars.name,
    a.latitude,
    a.longitude,
    tz.latitude as office_lat,
    tz.longitude as office_lon,
    MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE tz.timezone AS complete_date,
    lead(cars.name, 1, 'ZZZZZZ') OVER (partition by CAST(MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE tz.timezone AS date) ORDER BY cars.name, MIN(comp.started_at)) AS next_car,
    CASE
      WHEN lead(cars.name, 1, 'ZZZZZ') OVER (partition by CAST(MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE tz.timezone AS date) ORDER BY cars.name, MIN(comp.started_at)) != cars.name
        THEN 1
      ELSE 0
    END AS last_care_request,
    lead(a.latitude, 1, CAST(tz.latitude AS double precision)) OVER (partition by cars.name, CAST(MIN(comp.started_at) AS date) ORDER BY cars.name, MIN(comp.started_at)) AS next_latitude,
    lead(a.longitude, 1, CAST(tz.longitude AS double precision)) OVER (partition by cars.name, CAST(MIN(comp.started_at) AS date) ORDER BY cars.name, MIN(comp.started_at)) AS next_longitude,

    CASE
      WHEN
       lead(a.latitude, 1, CAST(tz.latitude AS double precision)) OVER
        (partition by cars.name, CAST(MIN(comp.started_at) AS date)
        ORDER BY cars.name, MIN(comp.started_at)) = a.latitude AND
       lead(a.longitude, 1, CAST(tz.longitude AS double precision)) OVER
         (partition by cars.name, CAST(MIN(comp.started_at) AS date)
         ORDER BY cars.name, MIN(comp.started_at)) = a.longitude
        THEN 0::float
      ELSE
        ROUND(((ACOS(SIN(RADIANS(a.latitude)) * SIN(RADIANS(
        lead(a.latitude, 1, CAST(tz.latitude AS double precision)) OVER (partition by cars.name, CAST(MIN(comp.started_at) AS date) ORDER BY cars.name, MIN(comp.started_at))
        )) + COS(RADIANS(a.latitude)) * COS(RADIANS(
        lead(a.latitude, 1, CAST(tz.latitude AS double precision)) OVER (partition by cars.name, CAST(MIN(comp.started_at) AS date) ORDER BY cars.name, MIN(comp.started_at))
        )) * COS(RADIANS(
        lead(a.longitude, 1, CAST(tz.longitude AS double precision)) OVER (partition by cars.name, CAST(MIN(comp.started_at) AS date) ORDER BY cars.name, MIN(comp.started_at))
        - a.longitude ))) * 6371) / 1.60934)::decimal, 1)
    END AS distance_to_next
  FROM care_requests cr
  LEFT JOIN care_request_statuses AS comp
    ON cr.id = comp.care_request_id AND comp.name = 'complete' and comp.deleted_at is null
  LEFT JOIN addressable_items ai
    ON cr.id = ai.addressable_id AND ai.addressable_type = 'CareRequest'
  LEFT JOIN addresses a
    ON ai.address_id = a.id
  LEFT JOIN shift_teams st
    ON st.id = cr.shift_team_id
  LEFT JOIN cars
    ON st.car_id = cars.id
  JOIN markets
    ON cr.market_id = markets.id
  JOIN looker_scratch.market_geo_locations AS tz
    ON markets.id = tz.market_id
  GROUP BY 1,2,3,4,5,6,7,8
  ORDER BY 4,9 ;;

  sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
  indexes: ["care_request_id"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: market_id {
    type: string
    sql: ${TABLE}.market_id ;;
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: tz_desc {
    type: string
    hidden: yes
    sql: ${TABLE}.tz_desc ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: office_lat {
    type: number
    sql: ${TABLE}.office_lat ;;
  }

  dimension: office_lon {
    type: number
    sql: ${TABLE}.office_lon ;;
  }

  dimension: office_location {
    type: location
    sql_latitude: ${TABLE}.office_lat ;;
    sql_longitude: ${TABLE}.office_lon ;;
  }

  dimension_group: complete_date {
    type: time
    sql: ${TABLE}.complete_date ;;
  }

  dimension: last_care_request_flag {
    type: yesno
    sql: ${TABLE}.last_care_request = 1 ;;
  }

  dimension: next_latitude {
    type: number
    sql: ${TABLE}.next_latitude ;;
  }

  dimension: next_longitude {
    type: number
    sql: ${TABLE}.next_longitude ;;
  }

  dimension: next_location {
    type: location
    sql_latitude: ${TABLE}.next_latitude ;;
    sql_longitude: ${TABLE}.next_longitude ;;
  }

  dimension: distance_to_next {
    type: number
    sql: ${TABLE}.distance_to_next ;;
  }

  measure: distance_home {
    type: average
    description: "The direct-line distance between the last care request and the clinical office"
    sql: ${TABLE}.distance_to_next ;;
    filters: {
      field: last_care_request_flag
      value: "yes"
    }
  }

  dimension: care_request_location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  set: detail {
    fields: [
      market_id,
      care_request_id,
      tz_desc,
      name,
      latitude,
      longitude,
      office_lat,
      office_lon,
      last_care_request_flag,
      next_latitude,
      next_longitude,
      distance_to_next,
      care_request_location
    ]
  }
}

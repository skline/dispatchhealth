view: intraday_potential_care_requests {
  derived_table: {
    sql:
     SELECT
  care_request_id,
  (meta_data ->> 'market_id')::integer AS market_id,
  (meta_data ->> 'shift_team_id')::integer AS shift_team_id,
  (meta_data ->> 'etc')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE mgl.timezone AS etc,
  (meta_data ->> 'latitude')::float8 AS latitude,
  (meta_data ->> 'longitude')::float8 AS longitude,
  (meta_data ->> 'street_address_1') AS address1,
  (meta_data ->> 'street_address_2') AS address2,
  (meta_data ->> 'city') AS city,
  (meta_data ->> 'state') AS state,
  (meta_data ->> 'zipcode')::varchar AS zipcode,
  (meta_data ->> 'etos')::integer AS time_on_scene,
  (meta_data ->> 'current_queue') AS current_queue,
  (meta_data ->> 'current_status') AS current_status,
  (meta_data ->> 'scheduled_status_comments') AS scheduled_comment,
  sli.name AS service_line,
  mgl.latitude AS office_latitude,
  mgl.longitude AS office_longitude,
  (meta_data ->> 'created_at')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE mgl.timezone AS created_at
  FROM public.intraday_care_requests icr
  LEFT JOIN looker_scratch.service_lines_intra sli
    ON (meta_data ->> 'service_line_id')::integer = sli.id
  LEFT JOIN looker_scratch.markets_intra mi
    ON (meta_data ->> 'market_id')::integer = mi.id
  LEFT JOIN looker_scratch.market_geo_locations_intra mgl
    ON mi.id = mgl.market_id
  WHERE (meta_data ->> 'current_status') IN ('requested','accepted','scheduled') AND
  sli.name NOT IN ('Post Acute Follow up', 'Post Acute Follow Up (HPN)', '911 Service') AND
  (meta_data ->> 'created_at')::timestamp AT TIME ZONE 'UTC' AT TIME ZONE mgl.timezone > current_date - interval '1 day' ;;
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: service_line {
    type: string
    sql: ${TABLE}.service_line ;;
  }

  dimension: scheduled_comment {
    type: string
    sql: ${TABLE}.scheduled_comment ;;
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}.address1 ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}.address2 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zipcode {
    type: string
    sql: ${TABLE}.zipcode ;;
  }

  dimension: time_on_scene {
    type: number
    sql: ${TABLE}.time_on_scene ;;
  }

  dimension: current_queue {
    type: string
    sql: ${TABLE}.current_queue ;;
  }

  dimension: current_status {
    type: string
    sql: ${TABLE}.current_status ;;
  }

  dimension_group: etc {
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
    sql: ${TABLE}.etc;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: office_latitude {
    type: number
    sql: ${TABLE}.office_latitude ;;
  }

  dimension: office_longitude {
    type: number
    sql: ${TABLE}.office_longitude ;;
  }

  dimension: office_location {
    type: location
    sql_latitude: ${office_latitude} ;;
    sql_longitude: ${office_longitude} ;;
  }

  dimension: distance_from_last_cr {
    type: distance
    start_location_field: last_care_request_etc_intra.pt_location
    end_location_field: location
    units: miles
  }

  dimension: distance_to_office {
    type: distance
    start_location_field: location
    end_location_field: office_location
    units: miles
  }


}

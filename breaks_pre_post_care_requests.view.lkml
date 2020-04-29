view: breaks_pre_post_care_requests {
  derived_table: {
sql: SELECT
  crpre.*,
  crpost.post_break_care_request_id,
  crpost.post_break_address1,
  crpost.post_break_address2,
  crpost.post_break_city,
  crpost.post_break_state,
  crpost.post_break_zipcode,
  crpost.post_break_latitude,
  crpost.post_break_longitude,
  crpost.break_end,
  crpost.post_break_on_scene_time,
  crpost.break_to_on_scene_mins,
  break.car_id,
  break.break_latitude,
  break.break_longitude,
  break.car_stopped,
  break.car_started
FROM
--Sub-query to create last care request before break
(SELECT
  pb.shift_team_id,
  pb.market_id,
  pb.id AS pre_break_care_request_id,
  ad.street_address_1 AS pre_break_address1,
  ad.street_address_2 AS pre_break_address2,
  ad.city AS pre_break_city,
  ad.state AS pre_break_state,
  ad.zipcode AS pre_break_zipcode,
  ad.latitude AS pre_break_latitude,
  ad.longitude AS pre_break_longitude,
  pb.break_start AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS break_start,
  pb.complete_time AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS pre_break_complete_time,
  pb.complete_to_break_diff/60 AS complete_to_break_mins
  FROM
(SELECT
  cr.id,
  cr.market_id,
  cr.shift_team_id,
  crs.started_at AS complete_time,
  brk.start_time AS break_start,
  EXTRACT(EPOCH FROM brk.start_time) - EXTRACT(EPOCH FROM crs.started_at) AS complete_to_break_diff,
  ROW_NUMBER() OVER(PARTITION BY cr.shift_team_id ORDER BY cr.shift_team_id, crs.started_at DESC) AS row_num
  FROM care_requests cr
  LEFT JOIN care_request_statuses crs
    ON cr.id = crs.care_request_id AND crs.name = 'complete'
  LEFT JOIN breaks brk
    ON cr.shift_team_id = brk.shift_team_id
  WHERE brk.start_time >= crs.started_at
  GROUP BY 1,2,3,4,5
  ORDER BY 3) AS pb
  LEFT JOIN addressable_items ai
    ON pb.id = ai.addressable_id AND ai.addressable_type = 'CareRequest'
  LEFT JOIN addresses ad
    ON ai.address_id = ad.id
  LEFT JOIN markets m
    ON pb.market_id = m.id
  LEFT JOIN looker_scratch.timezones tz
    ON m.sa_time_zone = tz.rails_tz
  WHERE pb.row_num = 1 AND m.enable_breaks IS TRUE) AS crpre

LEFT JOIN

--Sub-query to create first care request after break
(SELECT
  ab.shift_team_id,
  ab.id AS post_break_care_request_id,
  ad.street_address_1 AS post_break_address1,
  ad.street_address_2 AS post_break_address2,
  ad.city AS post_break_city,
  ad.state AS post_break_state,
  ad.zipcode AS post_break_zipcode,
  ad.latitude AS post_break_latitude,
  ad.longitude AS post_break_longitude,
  ab.break_end AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS break_end,
  ab.on_scene_time AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS post_break_on_scene_time,
  ab.break_to_on_scene_diff/60 AS break_to_on_scene_mins
  FROM
(SELECT
  cr.id,
  cr.market_id,
  cr.shift_team_id,
  crs.started_at AS on_scene_time,
  brk.end_time AS break_end,
  EXTRACT(EPOCH FROM crs.started_at) - EXTRACT(EPOCH FROM brk.end_time) AS break_to_on_scene_diff,
  ROW_NUMBER() OVER(PARTITION BY cr.shift_team_id ORDER BY cr.shift_team_id, crs.started_at) AS row_num
  FROM care_requests cr
  LEFT JOIN care_request_statuses crs
    ON cr.id = crs.care_request_id AND crs.name = 'on_scene'
  LEFT JOIN breaks brk
    ON cr.shift_team_id = brk.shift_team_id
  WHERE brk.end_time <= crs.started_at
  GROUP BY 1,2,3,4,5
  ORDER BY 3) AS ab
  LEFT JOIN addressable_items ai
    ON ab.id = ai.addressable_id AND ai.addressable_type = 'CareRequest'
  LEFT JOIN addresses ad
    ON ai.address_id = ad.id
  LEFT JOIN markets m
    ON ab.market_id = m.id
  LEFT JOIN looker_scratch.timezones tz
    ON m.sa_time_zone = tz.rails_tz
  WHERE ab.row_num = 1 AND m.enable_breaks IS TRUE) AS crpost

  ON crpre.shift_team_id = crpost.shift_team_id
  JOIN

  (SELECT
  st.car_id,
  brk.shift_team_id,
(select gl.latitude AS break_latitude
  from geo_locations gl
  WHERE brk.start_time >= gl.created_at AND
    st.car_id=gl.car_id AND
    DATE(st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') = DATE(gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain')
  ORDER BY gl.created_at DESC
  LIMIT 1),
  (select gl.longitude AS break_longitude
  from geo_locations gl
  WHERE brk.start_time >= gl.created_at AND
    st.car_id=gl.car_id AND
    DATE(st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') = DATE(gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain')
  ORDER BY gl.created_at DESC
  LIMIT 1),
  (select gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS car_stopped
  from geo_locations gl
  WHERE brk.start_time >= gl.created_at AND
    st.car_id=gl.car_id AND
    DATE(st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') = DATE(gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain')
  ORDER BY gl.created_at DESC
  LIMIT 1),
  (select gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' AS car_started
  from geo_locations gl
  WHERE brk.start_time <= gl.created_at AND
    st.car_id=gl.car_id AND
    DATE(st.start_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') = DATE(gl.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain')
  ORDER BY gl.created_at
  LIMIT 1)
  FROM shift_teams st
  LEFT JOIN breaks brk
    ON st.id = brk.shift_team_id) AS break

  ON crpre.shift_team_id = break.shift_team_id ;;

  sql_trigger_value: SELECT 1 ;;
  indexes: ["shift_team_id"]
}

dimension: shift_team_id {
  primary_key: yes
  type: number
  sql: ${TABLE}.shift_team_id ;;
}

dimension: pre_break_latitude {
  type: number
  sql: ${TABLE}.pre_break_latitude ;;
}

dimension: pre_break_longitude {
  type: number
  sql: ${TABLE}.pre_break_longitude ;;
}

dimension: pre_break_location {
  type: location
  sql_latitude: ${pre_break_latitude} ;;
  sql_longitude: ${pre_break_longitude} ;;
}

  dimension: post_break_latitude {
    type: number
    sql: ${TABLE}.post_break_latitude ;;
  }

  dimension: post_break_longitude {
    type: number
    sql: ${TABLE}.post_break_longitude ;;
  }

  dimension: post_break_location {
    type: location
    sql_latitude: ${post_break_latitude} ;;
    sql_longitude: ${post_break_longitude} ;;
  }

  dimension: break_latitude {
    type: number
    sql: ${TABLE}.break_latitude ;;
  }

  dimension: break_longitude {
    type: number
    sql: ${TABLE}.break_longitude ;;
  }

  dimension: break_location {
    type: location
    sql_latitude: ${break_latitude} ;;
    sql_longitude: ${break_longitude} ;;
  }

dimension: distance_to_break {
  type: distance
  units: miles
  start_location_field: pre_break_location
  end_location_field: break_location
}

dimension: distance_from_break {
  type: distance
  units: miles
  start_location_field: break_location
  end_location_field: post_break_location
}

  dimension: distance_without_break {
    type: distance
    units: miles
    start_location_field: pre_break_location
    end_location_field: post_break_location
  }

  dimension_group: break_start {
    type: time
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.break_start ;;
  }

  dimension_group: break_end {
    type: time
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.break_end ;;
  }

  dimension_group: car_started {
    type: time
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.car_started ;;
  }

  dimension_group: car_stopped {
    type: time
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.car_stopped ;;
  }












}

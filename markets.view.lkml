view: markets {
  sql_table_name: public.markets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: id_adj {
    type: string
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' then 159
      else ${id} end;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: contact_phone {
    type: string
    sql: ${TABLE}.contact_phone ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: enabled {
    type: yesno
    sql: ${TABLE}.enabled ;;
  }

  dimension: enroute_audio {
    type: string
    sql: ${TABLE}.enroute_audio ;;
  }

  dimension: humanity_id {
    type: string
    sql: ${TABLE}.humanity_id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: office_latitude {
    type: number
    sql: CASE
          WHEN ${id} = 162 THEN 36.1577462
          WHEN ${id} = 161 THEN 33.4213962
          WHEN ${id} = 164 THEN 37.606789
          WHEN ${id} = 159 THEN 39.7722937
          WHEN ${id} = 160 THEN 38.8851405
          WHEN ${id} = 166 THEN 35.5256793
          WHEN ${id} = 165 THEN 29.73728509999999
          WHEN ${id} = 167 THEN 39.709569
          WHEN ${id} = 168 THEN 42.105445
          WHEN ${id} = 169 THEN 32.979254
        END;;
  }

  dimension: office_longitude {
    type: number
    sql: CASE
          WHEN ${id} = 162 THEN -115.19155599999999
          WHEN ${id} = 161 THEN -111.96673450000003
          WHEN ${id} = 164 THEN -77.528929
          WHEN ${id} = 159 THEN -104.9835581
          WHEN ${id} = 160 THEN -104.83465469999999
          WHEN ${id} = 166 THEN -97.55798500000003
          WHEN ${id} = 165 THEN -95.59298539999998
          WHEN ${id} = 167 THEN -105.086286
          WHEN ${id} = 168 THEN -72.619331
          WHEN ${id} = 169 THEN -96.714748
        END;;
  }

  dimension: office_location {
    type: location
    sql_latitude:${office_latitude} ;;
    sql_longitude:${office_longitude} ;;
  }

  dimension: distance_home {
    type: distance
    start_location_field: addresses.care_request_location
    end_location_field: office_location
    units: miles
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_image {
    type: string
    sql: ${TABLE}.market_image ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: name_adj {
    type: string
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' then 'Denver'
    else ${name} end;;
  }

  dimension: name_smfr {
    type: string
    sql: case when ${cars.name} = 'SMFR_Car' then 'South Metro Fire Rescue'
         else ${name} end ;;
  }

  dimension: old_close_at {
    type: string
    sql: ${TABLE}.old_close_at ;;
  }

  dimension: old_open_at {
    type: string
    sql: ${TABLE}.old_open_at ;;
  }

  dimension: old_open_duration {
    type: number
    sql: ${TABLE}.old_open_duration ;;
  }

  dimension: primary_insurance_search_enabled {
    type: yesno
    sql: ${TABLE}.primary_insurance_search_enabled ;;
  }

  dimension: provider_group_name {
    type: string
    sql: ${TABLE}.provider_group_name ;;
  }

  dimension: sa_time_zone {
    type: string
    sql: ${TABLE}.sa_time_zone ;;
  }

  dimension: service_area_image {
    type: string
    sql: ${TABLE}.service_area_image ;;
  }

  dimension: short_name {
    type: string
    sql: ${TABLE}.short_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, provider_group_name, short_name, care_requests.count]
  }
  measure: digital_adjusted {
    type: number
    sql: ${care_request_complete.count_distinct}+${incontact_spot_check_by_market.spot_check_care_requests} ;;
  }
  measure: non_digital_adjusted {
    type: number
    sql: ${care_request_complete.count_distinct} - ${incontact_spot_check_by_market.spot_check_care_requests} ;;
  }
}

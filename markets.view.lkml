view: markets {
  sql_table_name: public.markets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
}

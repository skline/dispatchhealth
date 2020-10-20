view: billing_cities {
  sql_table_name: public.billing_cities ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }


  dimension: billing_city_id {
    type: number
    sql: ${TABLE}."billing_city_id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: default_department {
    type: string
    sql: ${TABLE}."default_department" ;;
  }

  dimension: display_insurance_note {
    type: yesno
    sql: ${TABLE}."display_insurance_note" ;;
  }

  dimension: enabled {
    type: yesno
    sql: ${TABLE}."enabled" ;;
  }

  dimension: insurance_note {
    type: string
    sql: ${TABLE}."insurance_note" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."latitude" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."longitude" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: primary_insurance_search_enabled {
    type: yesno
    sql: ${TABLE}."primary_insurance_search_enabled" ;;
  }

  dimension: provider_group_name {
    type: string
    sql: ${TABLE}."provider_group_name" ;;
  }

  dimension: short_name {
    type: string
    sql: ${TABLE}."short_name" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: tz_name {
    type: string
    sql: ${TABLE}."tz_name" ;;
  }

  dimension: tz_short_name {
    type: string
    sql: ${TABLE}."tz_short_name" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: usual_provider {
    type: string
    sql: ${TABLE}."usual_provider" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      name,
      short_name,
      provider_group_name,
      tz_name,
      tz_short_name
    ]
  }
}

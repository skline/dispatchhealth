view: addresses {
  sql_table_name: public.addresses ;;
  label: "Address of Care Request"

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: care_request_location {
    description: "The Latitude/Longitude combination of the care request (used for maps)"
    type: location
    sql_latitude:${latitude} ;;
    sql_longitude:${longitude} ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address_1 {
    type: string
    sql: ${TABLE}.street_address_1 ;;
  }

  dimension: full_addresss {
    type: string
    sql: concat(${street_address_1},': ', ${street_address_2},': ', ${city},': ', ${state},': ', ${zipcode}) ;;
  }

  dimension: street_address_2 {
    type: string
    sql: ${TABLE}.street_address_2 ;;
  }

  measure: count_unique_addresses {
    type: count_distinct
    sql: ${street_address_1} ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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

  dimension: zipcode_short {
    label: "Five Digit Zip Code"
    type: zipcode
    sql: left(${zipcode}, 5) ;;
  }

  dimension: zip_23139 {
    type: yesno
    sql: ${zipcode_short} = '23139' ;;
  }

  measure: zipcode_list {
    type: string
    sql: array_agg(${zipcode_short}) ;;
  }

  dimension: scf_code {
    type: string
    description: "The sectional center facility code (first 3 digits of the zip)"
    sql: left(${zipcode}, 3) ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

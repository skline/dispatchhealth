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

  dimension: latitude_round_4_decimal {
    type: number
    sql:round(${latitude}::numeric,4);;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: longitude_round_4_decimal {
    type: number
    sql: round(${longitude}::numeric,4);;
  }

  dimension: care_request_location {
    description: "The Latitude/Longitude combination of the care request (used for maps)"
    type: location
    sql_latitude:${latitude} ;;
    sql_longitude:${longitude} ;;
  }

  dimension: care_request_location_truncated {
    description: "Used to approximate households. The location based on rounded 4 decimal Latitude/Longitude combination of the care request (used for maps)."
    type: location
    sql_latitude:${latitude_round_4_decimal} ;;
    sql_longitude:${longitude_round_4_decimal} ;;
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

  dimension: fort_worth {
    type: yesno
    sql: ${zipcode_short} in('76028', '75078', '76262', '76248', '76244', '76182', '76180', '76177', '76164', '76148', '76140', '76137', '76134', '76133', '76132', '76131', '76129', '76127', '76123', '76120', '76119', '76118', '76117', '76116', '76115', '76114', '76112', '76111', '76110', '76109', '76107', '76105', '76104', '76103', '76102', '76092', '76060', '76054', '76053', '76034') ;;
  }

  dimension: zip_23139 {
    type: yesno
    sql: ${zipcode_short} = '23139' ;;
  }

  dimension: zip_code_in_dh_market {
    description: "The address of the care rquest zip code is in a DH market assigned zip code and is not a saftey warned zip code"
    type:  yesno
    sql:${zipcodes.zip} IS NOT NULL AND
    ${zipcodes.safety_warning} != 'yes';;
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

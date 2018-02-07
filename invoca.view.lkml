view: invoca {
  sql_table_name: looker_scratch.invoca ;;

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: address_type {
    type: string
    sql: ${TABLE}.address_type ;;
  }

  dimension: age_range {
    type: number
    sql: ${TABLE}.age_range ;;
  }

  dimension: call_record_ikd {
    type: string
    sql: ${TABLE}.call_record_ikd ;;
  }

  dimension: call_segment_path {
    type: string
    sql: ${TABLE}.call_segment_path ;;
  }

  dimension: caller_id {
    type: number
    sql: ${TABLE}.caller_id ;;
  }

  dimension: carrier {
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_append {
    type: string
    sql: ${TABLE}.city_append ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: display_name {
    type: string
    sql: ${TABLE}.display_name ;;
  }

  dimension: education {
    type: string
    sql: ${TABLE}.education ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: fees {
    type: number
    sql: ${TABLE}.fees ;;
  }

  dimension: final_campaign {
    type: string
    sql: ${TABLE}.final_campaign ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: has_children {
    type: string
    sql: ${TABLE}.has_children ;;
  }

  dimension: high_net_worth {
    type: string
    sql: ${TABLE}.high_net_worth ;;
  }

  dimension: home_value {
    type: string
    sql: ${TABLE}.home_value ;;
  }

  dimension: household_income {
    type: string
    sql: ${TABLE}.household_income ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: length_residence {
    type: string
    sql: ${TABLE}.length_residence ;;
  }

  dimension: line_type {
    type: string
    sql: ${TABLE}.line_type ;;
  }

  dimension: marital_status {
    type: string
    sql: ${TABLE}.marital_status ;;
  }

  dimension: occupation {
    type: string
    sql: ${TABLE}.occupation ;;
  }

  dimension: original_publisher {
    type: string
    sql: ${TABLE}.original_publisher ;;
  }

  dimension: original_publisher_id {
    type: string
    sql: ${TABLE}.original_publisher_id ;;
  }

  dimension: own_rent {
    type: string
    sql: ${TABLE}.own_rent ;;
  }

  dimension: phone_type {
    type: string
    sql: ${TABLE}.phone_type ;;
  }

  dimension: prepaid {
    type: string
    sql: ${TABLE}.prepaid ;;
  }

  dimension: primary_email {
    type: string
    sql: ${TABLE}.primary_email ;;
  }

  dimension: profile_fees {
    type: number
    sql: ${TABLE}.profile_fees ;;
  }

  dimension: promo_number_description {
    type: string
    sql: ${TABLE}.promo_number_description ;;
  }

  dimension: recording {
    type: string
    sql: ${TABLE}.recording ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: revenue {
    type: string
    sql: ${TABLE}.revenue ;;
  }

  dimension: signal_name {
    type: string
    sql: ${TABLE}.signal_name ;;
  }

  dimension: source {
    type: number
    sql: ${TABLE}.source ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_time ;;
  }
  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: total_connected_duration {
    type: string
    sql: ${TABLE}.total_connected_duration ;;
  }

  dimension: total_duration {
    type: string
    sql: ${TABLE}.total_duration ;;
  }

  dimension: total_ivr_duration {
    type: string
    sql: ${TABLE}.total_ivr_duration ;;
  }

  dimension: total_key_presses {
    type: string
    sql: ${TABLE}.total_key_presses ;;
  }

  dimension: transactions {
    type: number
    sql: ${TABLE}.transactions ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
  dimension:  end_time {
    type: string
    sql: addtime(${start_raw}, ${total_duration});;

  }

  dimension:  end_time_plus_one {
    type: string
    sql: addtime(${start_raw}, ${total_duration}+1);;

  }

  dimension:  end_time_minus_one {
    type: string
    sql: addtime(${start_raw}, ${total_duration}-1);;

  }


  measure: count {
    type: count
    drill_fields: [last_name, first_name, display_name, signal_name]
  }
}

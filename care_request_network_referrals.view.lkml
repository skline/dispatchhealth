view: care_request_network_referrals {
  sql_table_name: public.care_request_network_referrals ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: distance_in_meters {
    type: number
    sql: ${TABLE}.distance_in_meters ;;
  }

  dimension: network_referral_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.network_referral_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, network_referrals.id, network_referrals.name]
  }
}

view: insurance_network_network_referrals {
  sql_table_name: public.insurance_network_network_referrals ;;

  dimension: default {
    type: yesno
    sql: ${TABLE}."default" ;;
  }

  dimension: insurance_network_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.insurance_network_id ;;
  }

  dimension: network_referral_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.network_referral_id ;;
  }

  measure: count {
    type: count
    drill_fields: [insurance_networks.id, insurance_networks.name, network_referrals.id, network_referrals.name]
  }
}

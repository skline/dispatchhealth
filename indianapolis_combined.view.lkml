view: indianapolis_combined {
  sql_table_name: looker_scratch.indianapolis_combined ;;

  dimension: ka_aso {
    type: number
    sql: ${TABLE}.ka_aso ;;
  }

  dimension: na_aso {
    type: number
    sql: ${TABLE}.na_aso ;;
  }

  dimension: optum_ccm_isnp {
    type: number
    sql: ${TABLE}.optum_ccm_isnp ;;
  }

  dimension: optumcare_apn {
    type: number
    sql: ${TABLE}.optumcare_apn ;;
  }

  dimension: uhc_fl {
    type: number
    sql: ${TABLE}.uhc_fl ;;
  }

  dimension: uhc_ma {
    type: number
    sql: ${TABLE}.uhc_ma ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

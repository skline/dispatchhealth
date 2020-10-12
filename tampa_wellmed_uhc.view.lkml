view: tampa_wellmed_uhc {
  sql_table_name: looker_scratch.tampa_wellmed_uhc ;;

  dimension: florida_wellmed {
    type: number
    sql: ${TABLE}.florida_wellmed ;;
  }

  dimension: optum_ccm_isnp {
    type: number
    sql: ${TABLE}.optum_ccm_isnp ;;
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

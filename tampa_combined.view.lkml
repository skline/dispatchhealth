view: tampa_combined {
  sql_table_name: looker_scratch.tampa_combined ;;

  dimension: c_s_medicare_dnsp {
    type: number
    sql: ${TABLE}.c_s_medicare_dnsp ;;
  }

  dimension: florida_wellmed {
    type: number
    sql: ${TABLE}.florida_wellmed ;;
  }

  dimension: ka_aso {
    type: number
    sql: ${TABLE}.ka_aso ;;
  }

  dimension: medicaid {
    type: number
    value_format_name: id
    sql: ${TABLE}.medicaid ;;
  }

  dimension: na_aso {
    type: number
    sql: ${TABLE}.na_aso ;;
  }

  dimension: optum_ccm_isnp {
    type: number
    sql: ${TABLE}.optum_ccm_isnp ;;
  }

  dimension: uhc_fi {
    type: number
    sql: ${TABLE}.uhc_fi ;;
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

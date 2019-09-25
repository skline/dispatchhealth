view: optum_uhc_atl {
  sql_table_name: looker_scratch.optum_uhc_atl ;;

  dimension: optum_ccm_insp {
    type: number
    sql: ${TABLE}.optum_ccm_insp ;;
  }

  dimension: optum_ccm_total {
    type: number
    sql: ${TABLE}.optum_ccm_total ;;
  }

  dimension: optum_ccm_uhc_ma_total {
    type: number
    sql: ${TABLE}.optum_ccm_uhc_ma_total ;;
  }

  dimension: optum_home_dnsp {
    type: number
    sql: ${TABLE}.optum_home_dnsp ;;
  }

  dimension: uhc_ma_chronic_snp {
    type: number
    sql: ${TABLE}.uhc_ma_chronic_snp ;;
  }

  dimension: uhc_ma_community {
    type: number
    sql: ${TABLE}.uhc_ma_community ;;
  }

  dimension: uhc_ma_dsnp {
    type: number
    sql: ${TABLE}.uhc_ma_dsnp ;;
  }

  dimension: uhc_ma_total {
    type: number
    sql: ${TABLE}.uhc_ma_total ;;
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

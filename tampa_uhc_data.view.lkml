view: tampa_uhc_data {
  sql_table_name: looker_scratch.tampa_uhc_data ;;

  dimension: c_s_medicare_dnsp {
    type: number
    sql: ${TABLE}.c_s_medicare_dnsp ;;
  }

  dimension: medicaid {
    type: number
    sql: ${TABLE}.medicaid ;;
  }

  dimension: medicaid_plus_c_s_medicare_dnsp {
    type: number
    sql:${medicaid}+${c_s_medicare_dnsp};;
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

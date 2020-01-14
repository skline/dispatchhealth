view: tampa_uhc_aso {
  sql_table_name: looker_scratch.tampa_uhc_aso ;;

  dimension: ka_aso {
    type: number
    sql: ${TABLE}.ka_aso ;;
  }

  dimension: na_aso {
    type: number
    sql: ${TABLE}.na_aso ;;
  }

  dimension: uhc_fi {
    type: number
    sql: ${TABLE}.uhc_fi ;;
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

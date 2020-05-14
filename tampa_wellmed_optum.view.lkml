view: tampa_wellmed_optum {
  sql_table_name: looker_scratch.tampa_wellmed_optum ;;

  dimension: optum_grand_total {
    type: number
    sql: ${TABLE}.optum_grand_total ;;
  }

  dimension: wellmed_grand_total {
    type: number
    sql: ${TABLE}.wellmed_grand_total ;;
  }

  dimension: wellmed_optum_grand_total {
    type: number
    sql: ${TABLE}.wellmed_optum_grand_total ;;
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

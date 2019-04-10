view: aetna_uhc_ma {
  sql_table_name: looker_scratch.aetna_uhc_ma ;;

  dimension: count_mem {
    type: number
    sql: ${TABLE}.count_mem ;;
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

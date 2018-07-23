view: uhc_ma_houston {
  sql_table_name: looker_scratch.uhc_ma_houston ;;

  dimension: mem_count {
    type: number
    sql: ${TABLE}.mem_count ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

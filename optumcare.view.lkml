view: optumcare {
  sql_table_name: looker_scratch.optumcare ;;

  dimension: optumcare {
    type: number
    sql: ${TABLE}.optumcare ;;
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

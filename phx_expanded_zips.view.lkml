view: phx_expanded_zips {
  sql_table_name: looker_scratch.phx_expanded_zips ;;

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: number
    sql:count(distinct ${zipcode});;
  }
}

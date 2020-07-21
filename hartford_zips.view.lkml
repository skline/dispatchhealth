view: hartford_zips {
  sql_table_name: looker_scratch.hartford_zips ;;

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

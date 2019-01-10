view: az_zipcodes {
  sql_table_name: looker_scratch.az_zipcodes ;;

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

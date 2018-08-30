view: thpg_zipcode {
  sql_table_name: looker_scratch.thpg_zipcode ;;

  dimension: zipcodes {
    type: zipcode
    sql: ${TABLE}.zipcodes ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

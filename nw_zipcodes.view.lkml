view: nw_zipcodes {
  sql_table_name: looker_scratch.nw_zipcodes ;;

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
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

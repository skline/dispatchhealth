view: houston_zipcodes_processed {
  sql_table_name: looker_scratch.houston_zipcodes_processed ;;

  dimension: count_members {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: sum_count {
    type: sum_distinct
    sql: ${count_members} ;;
  }
}

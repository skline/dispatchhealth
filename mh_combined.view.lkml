view: mh_combined {
  sql_table_name: looker_scratch.mh_combined ;;

  dimension: total_count {
    type: number
    sql: ${TABLE}.total_count ;;
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

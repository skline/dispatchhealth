view: psu_count_data {
  sql_table_name: looker_scratch.psu_count_data ;;

  dimension: members {
    type: number
    sql: ${TABLE}.members ;;
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

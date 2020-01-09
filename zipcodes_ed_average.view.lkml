view: zipcodes_ed_average {
  sql_table_name: looker_scratch.zipcodes_ed_average ;;

  dimension: code_average_ed_event_ptmpy {
    type: number
    sql: ${TABLE}.code_average_ed_event_ptmpy ;;
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

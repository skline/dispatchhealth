view: thr_summarized {
  sql_table_name: looker_scratch.thr_summarized ;;

  dimension: member_count {
    type: number
    sql: ${TABLE}.member_count ;;
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

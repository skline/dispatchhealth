view: thr_zips {
  sql_table_name: looker_scratch.thr_zips ;;

  dimension: memeber_count {
    type: number
    sql: ${TABLE}.memeber_count ;;
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

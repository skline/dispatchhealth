view: thr_hospitals_zip {
  sql_table_name: looker_scratch.thr_hospitals_zip ;;

  dimension: hospital_assign {
    type: string
    sql: ${TABLE}.hospital_assign ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: ${zipcode} ;;
    sql: ${zipcode} ;;

  }

  measure: count {
    type: count
    drill_fields: []
  }
}

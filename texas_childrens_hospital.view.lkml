view: texas_childrens_hospital {
  sql_table_name: looker_scratch.texas_childrens_hospital ;;

  dimension: patient_cnt {
    type: number
    sql: ${TABLE}.patient_cnt ;;
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

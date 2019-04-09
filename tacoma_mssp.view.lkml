view: tacoma_mssp {
  sql_table_name: looker_scratch.tacoma_mssp ;;

  dimension: count_members {
    type: number
    sql: ${TABLE}.count_members ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: ${TABLE}.zip_code ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

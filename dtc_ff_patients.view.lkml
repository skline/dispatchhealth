view: dtc_ff_patients {
  sql_table_name: looker_scratch.dtc_ff_patients ;;

  dimension: high_level_category {
    type: string
    sql: ${TABLE}.high_level_category ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

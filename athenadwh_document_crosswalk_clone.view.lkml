view: athenadwh_document_crosswalk_clone {
  sql_table_name: looker_scratch.athenadwh_document_crosswalk_clone ;;

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
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

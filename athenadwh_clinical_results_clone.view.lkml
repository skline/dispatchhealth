view: athenadwh_clinical_results_clone {
  sql_table_name: looker_scratch.athenadwh_clinical_results_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: clinical_order_type_group {
    type: string
    sql: ${TABLE}.clinical_order_type_group ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension: clinical_result_id {
    type: number
    sql: ${TABLE}.clinical_result_id ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
  }

  dimension_group: created_datetime {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: specimen_source {
    type: string
    sql: ${TABLE}.specimen_source ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

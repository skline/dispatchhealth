view: patient_payer_lookup {
  sql_table_name: looker_scratch.patient_payer_lookup ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: dashboard_patient_id {
    type: number
    sql: ${TABLE}.dashboard_patient_id ;;
  }

  dimension: primary_payer_dim_id {
    type: number
    sql: ${TABLE}.primary_payer_dim_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

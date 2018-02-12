view: cpt_em_references {
  label: "CPT E&M Reference Table"
  sql_table_name: jasperdb.cpt_em_references ;;

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: cpt_code {
    label: "CPT code"
    type: string
    sql: ${TABLE}.cpt_code ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: em_care_level {
    label: "E&M CPT code Care Level"
    type: string
    sql: ${TABLE}.em_care_level ;;
  }

  dimension: em_patient_type {
    label: "E&M code Patient Type"
    type: string
    sql: ${TABLE}.em_patient_type ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

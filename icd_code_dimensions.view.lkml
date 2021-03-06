view: icd_code_dimensions {
  label: "ICD Code Dimensions"
  sql_table_name: jasperdb.icd_code_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: alpha_extension {
    type: string
    sql: ${TABLE}.alpha_extension ;;
  }

  dimension: category_header {
    type: string
    sql: ${TABLE}.category_header ;;
  }

  dimension: coding_system {
    type: string
    sql: ${TABLE}.coding_system ;;
  }

  dimension_group: created {
    hidden: yes
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: code_and_desc  {
    type: string
    sql: CONCAT(${TABLE}.diagnosis_code,
        ${TABLE}.diagnosis_description) ;;
    hidden: yes
  }

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}.diagnosis_code ;;
  }

  measure: diagnosis_codes_concat {
    label: "ICD 10 Diagnosis Codes"
    type: string
    sql: GROUP_CONCAT(DISTINCT ${diagnosis_code} SEPARATOR ' | ') ;;
  }

  dimension: diagnosis_code_decimal {
    type: string
    sql: ${TABLE}.diagnosis_code_decimal ;;
  }

  dimension: diagnosis_description {
    type: string
    sql: ${TABLE}.diagnosis_description ;;
  }

  measure: diagnosis_desc_concat {
    label: "ICD 10 Diagnosis Descriptions"
    type: string
    sql: GROUP_CONCAT(DISTINCT ${diagnosis_description} SEPARATOR ' | ') ;;
  }

  dimension: diagnosis_group {
    type: string
    sql: ${TABLE}.diagnosis_group ;;
  }

  dimension_group: updated {
    hidden: yes
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

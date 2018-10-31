view: icd_code_dimensions_clone {
  label: "ICD Code Dimensions Clone"
  sql_table_name: looker_scratch.icd_code_dimensions_clone ;;

  dimension: id {
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

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}.diagnosis_code ;;
  }

  dimension: disease_state {
    type: string
    description: "Grouped disease state for post-acute reporting"
    sql: CASE
          WHEN ${diagnosis_code} = 'I50' THEN 'CHF'
          WHEN ${diagnosis_code} = 'J44' THEN 'COPD'
          WHEN ${diagnosis_code} = 'A41' THEN 'Sepsis'
          WHEN ${diagnosis_code} IN ('J12', 'J18', 'J84', 'Z87') THEN 'Pneumonia'
          WHEN ${diagnosis_code} IN ('L03', 'K12', 'H05', 'N48') THEN 'Cellulitis'
          WHEN ${diagnosis_code} = 'Z96' THEN 'Post-Op Total Joint'
          ELSE 'Other'
        END;;
    drill_fields: [diagnosis_code,
                   diagnosis_description]
  }

  dimension: diagnosis_code_decimal {
    type: string
    sql: ${TABLE}.diagnosis_code_decimal ;;
  }

  dimension: diagnosis_description {
    type: string
    sql: ${TABLE}.diagnosis_description ;;
  }

  measure: diagnosis_codes_concat {
    label: "ICD 10 Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_code}), ' | ') ;;
  }

  measure: disease_state_concat {
    label: "Disease State(s)"
    type: string
    sql: array_to_string(array_agg(DISTINCT  ${disease_state}), ', ') ;;
  }

  measure: diagnosis_desc_concat {
    label: "ICD 10 Diagnosis Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT  ${diagnosis_description}), ' | ') ;;
  }

  dimension: diagnosis_group {
    type: string
    sql: ${TABLE}.diagnosis_group ;;
  }

  dimension_group: updated {
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

  dimension: likely_flu_diganosis {
    type: yesno
    sql: ${diagnosis_code} in('J09', 'J11', 'J10','J06',  'J20', 'J18', 'J20') ;;
  }
}

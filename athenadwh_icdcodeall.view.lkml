view: athenadwh_icdcodeall {
  view_label: "ICD Diagnosis Codes and Descriptions"
  sql_table_name: looker_scratch.athenadwh_icdcodeall ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
    sql: SUBSTRING(TRIM(${TABLE}.diagnosis_code), 0, 4) ;;
  }

  dimension: diagnosis_description {
    type: string
    sql: ${TABLE}.diagnosis_code_description ;;
  }

  dimension: diagnosis_code_group {
    type: string
    sql: ${TABLE}.diagnosis_code_group ;;
  }

  dimension: diagnosis_code_set {
    type: string
    sql: ${TABLE}.diagnosis_code_set ;;
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

  dimension: confusion_altered_awareness {
    type: yesno
    description: "Diagnosis of confusion, altered awareness, weakness, or behavioral disturbance"
    sql: ${diagnosis_code} IN ('R40','R41','R53','F03') ;;
  }

  dimension: wheelchair_homebound {
    type: yesno
    description: "Diagnosis of Hemiplegia, paraplegia or homebound medical necessity"
    sql: ${diagnosis_code} IN ('G81','G82') OR ${medical_necessity_notes.note} SIMILAR TO '%(mobility issues|transportation|leave the home)%' ;;
  }

  measure: diagnosis_codes_concat {
    label: "ICD 10 Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_code}), ' | ') ;;
  }

  measure: count_distinct_icd_10 {
    type: count_distinct
    sql: ${diagnosis_code} ;;
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

  dimension: likely_flu_diganosis {
    type: yesno
    sql: ${diagnosis_code} in('J09', 'J11', 'J10','J06',  'J20', 'J18', 'J20') ;;
  }

  dimension_group: effective {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.effective_date ;;
  }

  dimension_group: expiration {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.expiration_date ;;
  }

  dimension: icd_code_id {
    type: number
    sql: ${TABLE}.icd_code_id ;;
  }

  dimension: parent_diagnosis_code {
    type: string
    sql: ${TABLE}.parent_diagnosis_code ;;
  }

  dimension: unstripped_diagnosis_code {
    type: string
    sql: ${TABLE}.unstripped_diagnosis_code ;;
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
}
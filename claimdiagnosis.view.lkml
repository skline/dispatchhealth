view: claimdiagnosis {
  sql_table_name: athena.claimdiagnosis ;;
  view_label: "Athena Claim Diagnoses (DEV)"
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: claim_diagnosis_id {
    type: number
    hidden: yes
    sql: ${TABLE}."claim_diagnosis_id" ;;
  }

  dimension: claim_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_id" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}."diagnosis_code" ;;
  }

  dimension: diagnosis_codeset_name {
    type: string
    hidden: yes
    sql: ${TABLE}."diagnosis_codeset_name" ;;
  }

  dimension: icd_code_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."icd_code_id" ;;
  }

  dimension: sequence_number {
    type: number
    description: "The priority of the ICD-10 code e.g. 1 is first"
    sql: ${TABLE}."sequence_number" ;;
  }

  dimension_group: updated_at {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, diagnosis_codeset_name]
  }
}

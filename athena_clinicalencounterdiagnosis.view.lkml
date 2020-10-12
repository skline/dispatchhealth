view: athena_clinicalencounterdiagnosis {
  sql_table_name: athena.clinicalencounterdiagnosis ;;
  view_label: "Athena Clinical Encounter Diagnoses (DEV)"

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

  dimension: clinical_encounter_dx_id {
    type: number
    hidden: yes
    sql: ${TABLE}."clinical_encounter_dx_id" ;;
  }

  dimension: clinical_encounter_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_encounter_id" ;;
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

  dimension: icd_code_id {
    type: string
    group_label: "IDs"
    sql: ${TABLE}."icd_code_id" ;;
  }

  dimension: laterality {
    type: string
    hidden: yes
    sql: ${TABLE}."laterality" ;;
  }

  dimension: note {
    type: string
    hidden: yes
    sql: ${TABLE}."note" ;;
  }

  dimension: ordering {
    type: number
    description: "The priority order of the ICD-10 code (e.g. 0 is first priority)"
    sql: ${TABLE}."ordering" ;;
  }

  dimension: snomed_code {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."snomed_code" ;;
  }

  dimension: status {
    type: string
    hidden: yes
    sql: ${TABLE}."status" ;;
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
    drill_fields: [id]
  }
}

view: clinicalencounterdiagnosis {
  sql_table_name: athena.clinicalencounterdiagnosis ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: clinical_encounter_dx_id {
    type: number
    sql: ${TABLE}."clinical_encounter_dx_id" ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}."clinical_encounter_id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}."icd_code_id" ;;
  }

  dimension: laterality {
    type: string
    sql: ${TABLE}."laterality" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension: ordering {
    type: number
    sql: ${TABLE}."ordering" ;;
  }

  dimension: snomed_code {
    type: number
    sql: ${TABLE}."snomed_code" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

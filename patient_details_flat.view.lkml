view: patient_details_flat {
  sql_table_name: looker_scratch.patient_details_flat ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension: clinical_notes_sent {
    type: string
    sql: ${TABLE}."clinical_notes_sent" ;;
  }

  dimension: count_medications {
    type: number
    sql: ${TABLE}."count_medications" ;;
  }

  dimension: cpt_codes {
    type: string
    sql: ${TABLE}."cpt_codes" ;;
  }

  dimension: cpt_descriptions {
    type: string
    sql: ${TABLE}."cpt_descriptions" ;;
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

  dimension: diagnosis_descriptions {
    type: string
    sql: ${TABLE}."diagnosis_descriptions" ;;
  }

  dimension: em_care_level {
    type: string
    sql: ${TABLE}."em_care_level" ;;
  }

  dimension: primary_diagnosis_desc {
    type: string
    sql: ${TABLE}."primary_diagnosis_desc" ;;
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

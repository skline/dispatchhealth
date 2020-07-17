view: athena_clinicalencounter {
  sql_table_name: athena.clinicalencounter ;;
  drill_fields: [id]
  view_label: "Athena Clinical Encounters (DEV)"

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

  dimension: appointment_char {
    type: string
    hidden: yes
    sql: ${TABLE}."appointment_char" ;;
  }

  dimension: appointment_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."appointment_id" ;;
  }

  dimension: appointment_tickler_id {
    type: number
    hidden: yes
    sql: ${TABLE}."appointment_tickler_id" ;;
  }

  dimension: assigned_to {
    type: string
    hidden: yes
    sql: ${TABLE}."assigned_to" ;;
  }

  dimension: billing_tab_reviewed {
    type: string
    description: "The user and date/time that the billing tab was reviewed"
    sql: ${TABLE}."billing_tab_reviewed" ;;
  }

  dimension: chart_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."chart_id" ;;
  }

  dimension: claim_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."claim_id" ;;
  }

  dimension: clinical_encounter_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_encounter_id" ;;
  }

  dimension: clinical_encountertype {
    type: string
    description: "The encounter type: VISIT or ORDERSONLY"
    sql: ${TABLE}."clinical_encountertype" ;;
  }

  dimension: closed_by {
    type: string
    description: "The Athena user that closed the encounter"
    sql: ${TABLE}."closed_by" ;;
  }

  dimension_group: closed_datetime {
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
    sql: ${TABLE}."closed_datetime" ;;
  }

  dimension_group: created {
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
    hidden: yes
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

  dimension: department_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."department_id" ;;
  }

  dimension_group: encounter {
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
    sql: ${TABLE}."encounter_date" ;;
  }

  dimension: encounter_status {
    type: string
    description: "The status of the encounter e.g. 'checked in', etc."
    sql: ${TABLE}."encounter_status" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_location {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_location" ;;
  }

  dimension: patient_status {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_status" ;;
  }

  dimension: provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."provider_id" ;;
  }

  dimension: specialty {
    type: string
    hidden: yes
    sql: ${TABLE}."specialty" ;;
  }

  dimension: supervising_provider_id {
    type: number
    hidden: yes
    sql: ${TABLE}."supervising_provider_id" ;;
  }

  dimension_group: updated {
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
    drill_fields: [id, appointment.rescheduled_appointment_id, claim.original_claim_id]
  }
}

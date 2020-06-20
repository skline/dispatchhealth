view: claim {
  sql_table_name: athena.claim ;;
  drill_fields: [original_claim_id]
  view_label: "Athena Charts (DEV)"

  dimension: original_claim_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."original_claim_id" ;;
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

  dimension: claim_appointment_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_appointment_id" ;;
  }

  dimension_group: claim_created_datetime {
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
    sql: ${TABLE}."claim_created_datetime" ;;
  }

  dimension: claim_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."claim_id" ;;
  }

  dimension: claim_primary_patient_ins_id {
    type: number
    group_label: "Ids"
    sql: ${TABLE}."claim_primary_patient_ins_id" ;;
  }

  dimension: claim_referral_auth_id {
    type: number
    sql: ${TABLE}."claim_referral_auth_id" ;;
  }

  dimension: claim_referring_provider_id {
    type: number
    sql: ${TABLE}."claim_referring_provider_id" ;;
  }

  dimension: claim_scheduling_provider_id {
    type: number
    sql: ${TABLE}."claim_scheduling_provider_id" ;;
  }

  dimension: claim_secondary_patient_ins_id {
    type: number
    sql: ${TABLE}."claim_secondary_patient_ins_id" ;;
  }

  dimension_group: claim_service {
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
    sql: ${TABLE}."claim_service_date" ;;
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

  dimension_group: hospitalization_from {
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
    sql: ${TABLE}."hospitalization_from_date" ;;
  }

  dimension_group: hospitalization_to {
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
    sql: ${TABLE}."hospitalization_to_date" ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_claim_status {
    type: string
    sql: ${TABLE}."patient_claim_status" ;;
  }

  dimension: patient_department_id {
    type: number
    sql: ${TABLE}."patient_department_id" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_rounding_list_id {
    type: number
    sql: ${TABLE}."patient_rounding_list_id" ;;
  }

  dimension: primary_claim_status {
    type: string
    sql: ${TABLE}."primary_claim_status" ;;
  }

  dimension: rendering_provider_id {
    type: number
    sql: ${TABLE}."rendering_provider_id" ;;
  }

  dimension: reserved19 {
    type: string
    sql: ${TABLE}."reserved19" ;;
  }

  dimension: secondary_claim_status {
    type: string
    sql: ${TABLE}."secondary_claim_status" ;;
  }

  dimension: service_department_id {
    type: number
    sql: ${TABLE}."service_department_id" ;;
  }

  dimension: supervising_provider_id {
    type: number
    sql: ${TABLE}."supervising_provider_id" ;;
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
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      original_claim_id,
      claim.original_claim_id,
      appointment.count,
      claim.count,
      clinicalencounter.count,
      transaction.count
    ]
  }
}

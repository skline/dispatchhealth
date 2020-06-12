view: appointment {
  sql_table_name: athena.appointment ;;
  drill_fields: [rescheduled_appointment_id]

  dimension: rescheduled_appointment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."rescheduled_appointment_id" ;;
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

  dimension_group: appmt_scheduled_datetime_ast {
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
    sql: ${TABLE}."appmt_scheduled_datetime_ast" ;;
  }

  dimension: appointment_cancel_reason {
    type: string
    sql: ${TABLE}."appointment_cancel_reason" ;;
  }

  dimension_group: appointment_cancelled_datetime {
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
    sql: ${TABLE}."appointment_cancelled_datetime" ;;
  }

  dimension: appointment_char {
    type: string
    sql: ${TABLE}."appointment_char" ;;
  }

  dimension_group: appointment_check_in_datetime {
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
    sql: ${TABLE}."appointment_check_in_datetime" ;;
  }

  dimension_group: appointment_check_out_datetime {
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
    sql: ${TABLE}."appointment_check_out_datetime" ;;
  }

  dimension: appointment_created_by {
    type: string
    sql: ${TABLE}."appointment_created_by" ;;
  }

  dimension_group: appointment_created_datetime {
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
    sql: ${TABLE}."appointment_created_datetime" ;;
  }

  dimension_group: appointment {
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
    sql: ${TABLE}."appointment_date" ;;
  }

  dimension: appointment_deleted_by {
    type: string
    sql: ${TABLE}."appointment_deleted_by" ;;
  }

  dimension_group: appointment_deleted_datetime {
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
    sql: ${TABLE}."appointment_deleted_datetime" ;;
  }

  dimension: appointment_duration {
    type: number
    sql: ${TABLE}."appointment_duration" ;;
  }

  dimension: appointment_frozen_reason {
    type: string
    sql: ${TABLE}."appointment_frozen_reason" ;;
  }

  dimension: appointment_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."appointment_id" ;;
  }

  dimension_group: appointment_scheduled_datetime {
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
    sql: ${TABLE}."appointment_scheduled_datetime" ;;
  }

  dimension_group: appointment_starttime {
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
    sql: ${TABLE}."appointment_starttime" ;;
  }

  dimension: appointment_status {
    type: string
    sql: ${TABLE}."appointment_status" ;;
  }

  dimension: appointment_type_block_id {
    type: number
    sql: ${TABLE}."appointment_type_block_id" ;;
  }

  dimension: appointment_type_id {
    type: number
    sql: ${TABLE}."appointment_type_id" ;;
  }

  dimension: cancelled_by {
    type: string
    sql: ${TABLE}."cancelled_by" ;;
  }

  dimension: checked_in_by {
    type: string
    sql: ${TABLE}."checked_in_by" ;;
  }

  dimension: checked_out_by {
    type: string
    sql: ${TABLE}."checked_out_by" ;;
  }

  dimension: claim_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."claim_id" ;;
  }

  dimension: collections_amount {
    type: number
    sql: ${TABLE}."collections_amount" ;;
  }

  dimension: collections_amount_collected {
    type: number
    sql: ${TABLE}."collections_amount_collected" ;;
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

  dimension_group: cycle {
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
    sql: ${TABLE}."cycle_time" ;;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}."department_id" ;;
  }

  dimension: family_collection_collected {
    type: number
    sql: ${TABLE}."family_collection_collected" ;;
  }

  dimension: family_outstanding_collected {
    type: number
    sql: ${TABLE}."family_outstanding_collected" ;;
  }

  dimension: frozenyn {
    type: string
    sql: ${TABLE}."frozenyn" ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: no_charge_entry_reason {
    type: string
    sql: ${TABLE}."no_charge_entry_reason" ;;
  }

  dimension: no_charge_entry_sign_off {
    type: string
    sql: ${TABLE}."no_charge_entry_sign_off" ;;
  }

  dimension: parent_appointment_id {
    type: number
    sql: ${TABLE}."parent_appointment_id" ;;
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_family_collection_amt {
    type: number
    sql: ${TABLE}."patient_family_collection_amt" ;;
  }

  dimension: patient_family_outstanding_amt {
    type: number
    sql: ${TABLE}."patient_family_outstanding_amt" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_outstanding_amount {
    type: number
    sql: ${TABLE}."patient_outstanding_amount" ;;
  }

  dimension: patient_outstanding_collected {
    type: number
    sql: ${TABLE}."patient_outstanding_collected" ;;
  }

  dimension: patient_outstanding_pmt_choice {
    type: string
    sql: ${TABLE}."patient_outstanding_pmt_choice" ;;
  }

  dimension: patient_unapplied_amount {
    type: number
    sql: ${TABLE}."patient_unapplied_amount" ;;
  }

  dimension: patient_unapplied_collected {
    type: number
    sql: ${TABLE}."patient_unapplied_collected" ;;
  }

  dimension: primary_patient_insurance_id {
    type: number
    sql: ${TABLE}."primary_patient_insurance_id" ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}."provider_id" ;;
  }

  dimension: referral_auth_id {
    type: number
    sql: ${TABLE}."referral_auth_id" ;;
  }

  dimension: referring_provider_id {
    type: number
    sql: ${TABLE}."referring_provider_id" ;;
  }

  dimension: rescheduled_by {
    type: string
    sql: ${TABLE}."rescheduled_by" ;;
  }

  dimension_group: rescheduled_datetime {
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
    sql: ${TABLE}."rescheduled_datetime" ;;
  }

  dimension: scheduled_by {
    type: string
    sql: ${TABLE}."scheduled_by" ;;
  }

  dimension: scheduling_provider {
    type: string
    sql: ${TABLE}."scheduling_provider" ;;
  }

  dimension: scheduling_template_id {
    type: number
    sql: ${TABLE}."scheduling_template_id" ;;
  }

  dimension: secondary_patient_insurance_id {
    type: number
    sql: ${TABLE}."secondary_patient_insurance_id" ;;
  }

  dimension_group: start_check_in_datetime {
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
    sql: ${TABLE}."start_check_in_datetime" ;;
  }

  dimension_group: stop_sign_off_datetime {
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
    sql: ${TABLE}."stop_sign_off_datetime" ;;
  }

  dimension: suggested_overbooking {
    type: number
    sql: ${TABLE}."suggested_overbooking" ;;
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
    drill_fields: [rescheduled_appointment_id, appointment.rescheduled_appointment_id, claim.original_claim_id, appointment.count, clinicalencounter.count]
  }
}

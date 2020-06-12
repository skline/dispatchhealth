view: appointment {
  sql_table_name: athena.appointment ;;
  drill_fields: [rescheduled_appointment_id]
  view_label: "Athena Appointments (IN DEV)"

  dimension: rescheduled_appointment_id {
    type: number
    group_label: "Ids"
    group_item_label: "Rescheduled Appointment"
    sql: ${TABLE}."rescheduled_appointment_id" ;;
  }

  dimension: id {
    type: number
    hidden: yes
    primary_key: yes
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

  dimension_group: appmt_scheduled_datetime_ast {
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
    sql: ${TABLE}."appmt_scheduled_datetime_ast" ;;
  }

  dimension: appointment_cancel_reason {
    type: string
    group_label: "Reasons"
    group_item_label: "Cancelled"
    sql: ${TABLE}."appointment_cancel_reason" ;;
  }

  dimension_group: appointment_cancelled_datetime {
    type: time
    label: "Datetime Cancelled"
#     group_item_label: "Cancelled"
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
    hidden: yes
    sql: ${TABLE}."appointment_char" ;;
  }

  dimension_group: appointment_check_in_datetime {
    type: time
    label: "Datetime Check In"
#     group_item_label: "Check-In"
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
    label: "Datetime Check Out"
#     group_item_label: "Check-Out"
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
    group_label: "Usernames"
    group_item_label: "Created By"
    sql: ${TABLE}."appointment_created_by" ;;
  }

  dimension_group: appointment_created_datetime {
    type: time
    label: "Datetime Created"
#     group_item_label: "Created"
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
    label: "Datetime Appointment"
#     group_item_label: "Appointment"
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
    group_label: "Usernames"
    group_item_label: "Deleted By"
    sql: ${TABLE}."appointment_deleted_by" ;;
  }

  dimension_group: appointment_deleted_datetime {
    type: time
    label: "Datetime Deleted"
#     group_item_label: "Deleted"
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
    hidden: yes
    sql: ${TABLE}."appointment_duration" ;;
  }

  dimension: appointment_frozen_reason {
    type: string
    group_label: "Reasons"
    group_item_label: "Frozen"
    sql: ${TABLE}."appointment_frozen_reason" ;;
  }

  dimension: appointment_id {
    type: number
    group_label: "Ids"
    group_item_label: "Appointment"
    # hidden: yes
    sql: ${TABLE}."appointment_id" ;;
  }

  dimension_group: appointment_scheduled_datetime {
    type: time
    label: "Datetime Scheduled"
#     group_item_label: "Scheduled"
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
    label: "Datetime Start"
#     group_item_label: "Start"
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day
    ]
    sql: ${TABLE}."appointment_starttime" ;;
  }

  dimension: appointment_status {
    type: string
    sql: ${TABLE}."appointment_status" ;;
  }

  dimension: appointment_type_block_id {
    type: number
    group_label: "Ids"
    group_item_label: "Appointment Type Block"
    sql: ${TABLE}."appointment_type_block_id" ;;
  }

  dimension: appointment_type_id {
    type: number
    group_label: "Ids"
    group_item_label: "Appointment Type"
    sql: ${TABLE}."appointment_type_id" ;;
  }

  dimension: cancelled_by {
    type: string
    group_label: "Usernames"
    group_item_label: "Cancelled"
    sql: ${TABLE}."cancelled_by" ;;
  }

  dimension: checked_in_by {
    type: string
    group_label: "Usernames"
    group_item_label: "Checked-In"
    sql: ${TABLE}."checked_in_by" ;;
  }

  dimension: checked_out_by {
    type: string
    group_label: "Usernames"
    group_item_label: "Checked-Out"
    sql: ${TABLE}."checked_out_by" ;;
  }

  dimension: claim_id {
    type: number
    group_label: "Ids"
    group_item_label: "Claim"
    # hidden: yes
    sql: ${TABLE}."claim_id" ;;
  }

  dimension: collections_amount {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Collections"
    sql: ${TABLE}."collections_amount" ;;
  }

  dimension: collections_amount_collected {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Collected"
    sql: ${TABLE}."collections_amount_collected" ;;
  }

  dimension_group: created {
    type: time
    label: "Datetime Created"
    group_item_label: "Created"
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
    label: "Datetime Cycle"
#     group_item_label: "Cycle"
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
    group_label: "Ids"
    group_item_label: "Department"
    sql: ${TABLE}."department_id" ;;
  }

  dimension: family_collection_collected {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Family Collected"
    sql: ${TABLE}."family_collection_collected" ;;
  }

  dimension: family_outstanding_collected {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Family Outstanding"
    sql: ${TABLE}."family_outstanding_collected" ;;
  }

  dimension: frozenyn {
    type: string
    hidden: yes
    sql: ${TABLE}."frozenyn" ;;
  }

  dimension: no_charge_entry_reason {
    type: string
    group_label: "Reasons"
    group_item_label: "No Charge Entry"
    sql: ${TABLE}."no_charge_entry_reason" ;;
  }

  dimension: no_charge_entry_sign_off {
    type: string
    group_label: "Usernames"
    sql: ${TABLE}."no_charge_entry_sign_off" ;;
  }

  dimension: parent_appointment_id {
    type: number
    group_label: "Ids"
    group_item_label: "Parent Appointment"
    sql: ${TABLE}."parent_appointment_id" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_family_collection_amt {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Family Collection"
    sql: ${TABLE}."patient_family_collection_amt" ;;
  }

  dimension: patient_family_outstanding_amt {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Family Outstanding"
    sql: ${TABLE}."patient_family_outstanding_amt" ;;
  }

  dimension: patient_id {
    type: number
    group_label: "Ids"
    group_item_label: "Patient"
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_outstanding_amount {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Patient Outstanding"
    sql: ${TABLE}."patient_outstanding_amount" ;;
  }

  dimension: patient_outstanding_collected {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Patient Outstanding Collected"
    sql: ${TABLE}."patient_outstanding_collected" ;;
  }

  dimension: patient_outstanding_pmt_choice {
    type: string
    sql: ${TABLE}."patient_outstanding_pmt_choice" ;;
  }

  dimension: patient_unapplied_amount {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Patient Unapplied"
    sql: ${TABLE}."patient_unapplied_amount" ;;
  }

  dimension: patient_unapplied_collected {
    type: number
    hidden: yes
#     group_label: "Amounts"
#     group_item_label: "Family Unapplied Collected"
    sql: ${TABLE}."patient_unapplied_collected" ;;
  }

  dimension: primary_patient_insurance_id {
    type: number
    group_label: "Ids"
    group_item_label: "Primary Patient Insurance"
    sql: ${TABLE}."primary_patient_insurance_id" ;;
  }

  dimension: provider_id {
    type: number
    group_label: "Ids"
    group_item_label: "Provider"
    sql: ${TABLE}."provider_id" ;;
  }

  dimension: referral_auth_id {
    type: number
    group_label: "Ids"
    group_item_label: "Referral Authorization"
    sql: ${TABLE}."referral_auth_id" ;;
  }

  dimension: referring_provider_id {
    type: number
    group_label: "Ids"
    group_item_label: "Referring Provider"
    sql: ${TABLE}."referring_provider_id" ;;
  }

  dimension: rescheduled_by {
    type: string
    group_label: "Usernames"
    group_item_label: "Rescheduled"
    sql: ${TABLE}."rescheduled_by" ;;
  }

  dimension_group: rescheduled_datetime {
    type: time
    label: "Datetime Rescheduled"
#     group_item_label: "Rescheduled"
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
    group_label: "Usernames"
    group_item_label: "Scheduled"
    sql: ${TABLE}."scheduled_by" ;;
  }

  dimension: scheduling_provider {
    type: string
    group_label: "Usernames"
    group_item_label: "Scheduling Provider"
    sql: ${TABLE}."scheduling_provider" ;;
  }

  dimension: scheduling_template_id {
    type: number
    group_label: "Ids"
    group_item_label: "Scheduling Template"
    sql: ${TABLE}."scheduling_template_id" ;;
  }

  dimension: secondary_patient_insurance_id {
    type: number
    group_label: "Ids"
    group_item_label: "Secondary Patient Insurance"
    sql: ${TABLE}."secondary_patient_insurance_id" ;;
  }

  dimension_group: start_check_in_datetime {
    type: time
    label: "Datetime Check In Start"
#     group_item_label: "Check-In Start"
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
    label: "Datetime Sign Off Stop"
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
    hidden: yes
    sql: ${TABLE}."suggested_overbooking" ;;
  }

  dimension_group: updated {
    type: time
    label: "Datetime Updated"
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

  measure: count_appointments {
    type: count_distinct
    sql: ${appointment_id} ;;
    drill_fields: [rescheduled_appointment_id, appointment.rescheduled_appointment_id, claim.original_claim_id, appointment.count, clinicalencounter.count]
  }
}

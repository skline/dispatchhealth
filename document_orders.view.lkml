view: document_orders {
  sql_table_name: athena.document_orders ;;
  drill_fields: [id]
  view_label: "Athena Document Orders"

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
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

  dimension_group: alarm {
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
    sql: ${TABLE}."alarm_date" ;;
  }

  dimension: alarm_days {
    type: number
    description: "The number of days set before an inbox alarm is triggered"
    sql: ${TABLE}."alarm_days" ;;
  }

  dimension: approved_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."approved_by" ;;
  }

  dimension_group: approved {
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
    sql: ${TABLE}."approved_datetime" ;;
  }

  dimension: assigned_to {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."assigned_to" ;;
  }

  dimension: chart_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."chart_id" ;;
  }

  dimension: clinical_encounter_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_encounter_id" ;;
  }

  dimension: clinical_order_genus {
    type: string
    description: "The high-level description of the order e.g. 'URINALYSIS', 'CMP', etc."
    group_label: "Description"
    sql: ${TABLE}."clinical_order_genus" ;;
  }

  dimension: clinical_order_type {
    type: string
    description: "The detailed description of the order e.g. 'URINALYSIS DIPSTICK', etc."
    group_label: "Description"
    sql: ${TABLE}."clinical_order_type" ;;
  }

  dimension: clinical_order_type_group {
    type: string
    description: "LAB or IMAGING"
    group_label: "Description"
    sql: ${TABLE}."clinical_order_type_group" ;;
  }

  dimension: clinical_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_provider_id" ;;
  }

  dimension: clinical_provider_order_type {
    type: string
    description: "The order type as defined by the fulfilling provider"
    group_label: "Description"
    sql: ${TABLE}."clinical_provider_order_type" ;;
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
    group_label: "User Actions"
    sql: ${TABLE}."created_by" ;;
  }

  dimension: created_clinical_encounter_id {
    type: number
    hidden: yes
    sql: ${TABLE}."created_clinical_encounter_id" ;;
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

  dimension: cvx {
    type: string
    hidden: yes
    sql: ${TABLE}."cvx" ;;
  }

  dimension: deactivated_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."deactivated_by" ;;
  }

  dimension_group: deactivated {
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
    sql: ${TABLE}."deactivated_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    group_label: "User Actions"
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

  dimension: denied_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."denied_by" ;;
  }

  dimension_group: denied {
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
    sql: ${TABLE}."denied_datetime" ;;
  }

  dimension: department_id {
    type: number
    # hidden: yes
    group_label: "IDs"
    sql: ${TABLE}."department_id" ;;
  }

  dimension: document_class {
    type: string
    description: "ORDER or DME"
    group_label: "Description"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: document_results_document_id {
    type: number
    group_label: "IDs"
    description: "The document ID associated with the order result"
    sql: ${TABLE}."document_results_document_id" ;;
  }

  dimension: document_results_id {
    type: number
    hidden: yes
    sql: ${TABLE}."document_results_id" ;;
  }

  dimension: external_note {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."external_note" ;;
  }

  dimension: fbd_med_id {
    type: string
    group_label: "IDs"
    sql: ${TABLE}."fbd_med_id" ;;
  }

  dimension_group: future_submit {
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
    sql: ${TABLE}."future_submit_datetime" ;;
  }

  dimension: image_exists_yn {
    type: string
    sql: ${TABLE}."image_exists_yn" ;;
  }

  dimension: interface_vendor_name {
    type: string
    hidden: yes
    sql: ${TABLE}."interface_vendor_name" ;;
  }

  dimension: notifier {
    type: string
    group_label: "User Actions"
    description: "The entity creating the notification of the order e.g. 'ATHENA', 'HOU - HOME STAFF', etc."
    sql: ${TABLE}."notifier" ;;
  }

  dimension_group: observation {
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
    sql: ${TABLE}."observation_datetime" ;;
  }

  dimension_group: order {
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
    sql: ${TABLE}."order_datetime" ;;
  }

  dimension: order_document_id {
    type: number
    hidden: yes
    sql: ${TABLE}."order_document_id" ;;
  }

  dimension: order_text {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."order_text" ;;
  }

  dimension: out_of_network_ref_reason_name {
    type: string
    hidden: yes
    sql: ${TABLE}."out_of_network_ref_reason_name" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_note {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."patient_note" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."priority" ;;
  }

  dimension: provider_note {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."provider_note" ;;
  }

  dimension: provider_username {
    type: string
    sql: ${TABLE}."provider_username" ;;
  }

  dimension_group: received {
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
    sql: ${TABLE}."received_datetime" ;;
  }

  dimension: result_notes {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."result_notes" ;;
  }

  dimension: reviewed_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."reviewed_by" ;;
  }

  dimension_group: reviewed {
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
    sql: ${TABLE}."reviewed_datetime" ;;
  }

  dimension: route {
    type: string
    hidden: yes
    sql: ${TABLE}."route" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: specimen_collected_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."specimen_collected_by" ;;
  }

  dimension_group: specimen_collected {
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
    sql: ${TABLE}."specimen_collected_datetime" ;;
  }

  dimension: specimen_description {
    type: string
    sql: ${TABLE}."specimen_description" ;;
  }

  dimension: specimen_draw_location {
    type: string
    sql: ${TABLE}."specimen_draw_location" ;;
  }

  dimension: specimen_source {
    type: string
    sql: ${TABLE}."specimen_source" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
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

  dimension: vaccine_route {
    type: string
    hidden: yes
    sql: ${TABLE}."vaccine_route" ;;
  }

  dimension: order_created_to_submitted  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_order_submitted.order_submitted_raw}) -
          EXTRACT(EPOCH FROM ${athena_order_created.order_created_raw})) / 3600 ;;
  }

  measure: average_created_to_submitted {
    description: "Average time between order created and submitted (Hrs)"
    group_label: "Time Cycle Management"
    type: average
    sql: ${order_created_to_submitted} ;;
    value_format: "0.00"
  }

  dimension: order_submitted_to_result_rcvd  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_result_created.result_created_raw}) -
      EXTRACT(EPOCH FROM ${athena_order_submitted.order_submitted_raw})) / 3600 ;;
  }

  measure: average_submitted_to_result_rcvd {
    description: "Average time between order submitted and result received (Hrs)"
    group_label: "Time Cycle Management"
    type: average
    sql: ${order_submitted_to_result_rcvd} ;;
    value_format: "0.00"
  }

  dimension: result_rcvd_to_closed  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_result_closed.result_closed_raw}) -
      EXTRACT(EPOCH FROM ${athena_result_created.result_created_raw})) / 3600 ;;
  }

  measure: average_result_rcvd_to_closed {
    description: "Average time between order result received and closed (Hrs)"
    group_label: "Time Cycle Management"
    type: average
    sql: ${result_rcvd_to_closed} ;;
    value_format: "0.00"
  }



  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      provider_username,
      interface_vendor_name,
      out_of_network_ref_reason_name,
      patient.first_name,
      patient.last_name,
      patient.new_patient_id,
      patient.guarantor_first_name,
      patient.guarantor_last_name,
      patient.emergency_contact_name,
      department.department_name,
      department.billing_name,
      department.gpci_location_name,
      department.department_id,
      document_results.provider_username,
      document_results.id,
      document_results.interface_vendor_name,
      document_results.out_of_network_ref_reason_name
    ]
  }
}

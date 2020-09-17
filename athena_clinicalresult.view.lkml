view: athena_clinicalresult {
  sql_table_name: athena.clinicalresult ;;
  drill_fields: [id]
  view_label: "Athena Clinical Result"

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

  dimension: clinical_order_genus {
    type: string
    group_label: "Description"
    sql: ${TABLE}."clinical_order_genus" ;;
  }

  dimension: clinical_order_type {
    type: string
    group_label: "Description"
    description: "The detailed description of the order"
    sql: ${TABLE}."clinical_order_type" ;;
  }

  dimension: clinical_order_type_group {
    type: string
    group_label: "Description"
    description: "The high-level description (LAB, IMAGING, etc.)"
    sql: ${TABLE}."clinical_order_type_group" ;;
  }

  dimension: clinical_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_provider_id" ;;
  }

  dimension: clinical_provider_order_type {
    type: string
    group_label: "Description"
    description: "The order type as defined by the fulfilling provider"
    sql: ${TABLE}."clinical_provider_order_type" ;;
  }

  dimension: clinical_result_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_result_id" ;;
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

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: external_note {
    type: string
    group_label: "Description"
    sql: ${TABLE}."external_note" ;;
  }

  dimension: fbd_med_id {
    type: string
    group_label: "IDs"
    sql: ${TABLE}."fbd_med_id" ;;
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

  dimension: order_document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."order_document_id" ;;
  }

  dimension: provider_note {
    type: string
    group_label: "Description"
    sql: ${TABLE}."provider_note" ;;
  }

  dimension: report_status {
    type: string
    group_label: "Description"
    sql: ${TABLE}."report_status" ;;
  }

  dimension: result_document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."result_document_id" ;;
  }

  dimension: result_status {
    type: string
    group_label: "Description"
    sql: ${TABLE}."result_status" ;;
  }

  dimension_group: results_reported {
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
    sql: ${TABLE}."results_reported_datetime" ;;
  }

  dimension_group: specimen_received {
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
    sql: ${TABLE}."specimen_received_datetime" ;;
  }

  dimension: specimen_source {
    type: string
    hidden: yes
    sql: ${TABLE}."specimen_source" ;;
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
    drill_fields: [id]
  }
}

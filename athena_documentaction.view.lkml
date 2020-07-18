view: athena_documentaction {
  sql_table_name: athena.documentaction ;;
  view_label: "Athena Document Actions"
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

  dimension: action {
    type: string
    sql: ${TABLE}."action" ;;
  }

  dimension: action_group {
    type: string
    sql: ${TABLE}."action_group" ;;
  }

  dimension: assigned_to {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."assigned_to" ;;
  }

  measure: assigned_to_users {
    description: "Concatenated list of users assigned to document action"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${assigned_to}), ' | ') ;;
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

  dimension: document_action_id {
    type: number
    group_label: "Ids"
    sql: ${TABLE}."document_action_id" ;;
  }

  dimension: document_category {
    type: string
    hidden: yes
    sql: ${TABLE}."document_category" ;;
  }

  dimension: document_class {
    type: string
    description: "High level document description e.g. 'LETTER', 'LABRESULT', etc."
    group_label: "Descriptions"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_error_reason {
    type: string
    sql: ${TABLE}."document_error_reason" ;;
  }

  dimension: document_id {
    type: number
    group_label: "Ids"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: document_pre_class {
    type: string
    hidden: yes
    sql: ${TABLE}."document_pre_class" ;;
  }

  dimension: document_sub_class {
    type: string
    description: "Second order document description e.g. 'PRESCRIPTION_NEW', etc."
    group_label: "Descriptions"
    sql: ${TABLE}."document_sub_class" ;;
  }

  dimension: erroryn {
    type: string
    sql: ${TABLE}."erroryn" ;;
  }

  dimension: mobile {
    type: string
    sql: ${TABLE}."mobile" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension_group: patient_notified {
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
    sql: ${TABLE}."patient_notified_datetime" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."priority" ;;
  }

  dimension: send_fax_unique_id {
    type: string
    group_label: "Ids"
    sql: ${TABLE}."send_fax_unique_id" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: system_key {
    type: string
    sql: ${TABLE}."system_key" ;;
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

  measure: count_review_touches {
    description: "Count times lab or imaging result were in REVIEW status"
    type: count
    sql: ${document_id} ;;
    group_label: "Document Review Metrics"
    filters: [status: "REVIEW", document_class: "LABRESULT, IMAGINGRESULT", created_by: "-ATHENA,-INTERFACE"]
    drill_fields: [id]
  }

  measure: result_review_users {
    description: "List of users and dates who performed action on results"
    type: string
    sql: array_to_string(array_agg(CONCAT(${created_by},' - ', to_char(${created_date}, 'MM/DD')::varchar)), ', ') ;;
    group_label: "Document Review Metrics"
    drill_fields: [id]
  }
}

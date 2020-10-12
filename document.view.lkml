view: document_test {
  sql_table_name: athena_intermediate.document ;;
  drill_fields: [order_document_id]
  suggestions: no

  dimension: order_document_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_document_id ;;
  }

  dimension: __batch_id {
    type: string
    sql: ${TABLE}.__batch_id ;;
  }

  dimension: __from_filename {
    type: string
    sql: ${TABLE}.__from_filename ;;
  }

  dimension: __from_manifest {
    type: string
    sql: ${TABLE}.__from_manifest ;;
  }

  dimension: __s3_filepath {
    type: string
    sql: ${TABLE}.__s3_filepath ;;
  }

  dimension: alarm_date {
    type: string
    sql: ${TABLE}.alarm_date ;;
  }

  dimension: alarm_days {
    type: number
    sql: ${TABLE}.alarm_days ;;
  }

  dimension: approved_by {
    type: string
    sql: ${TABLE}.approved_by ;;
  }

  dimension: approved_datetime {
    type: string
    sql: ${TABLE}.approved_datetime ;;
  }

  dimension: assigned_to {
    type: string
    sql: ${TABLE}.assigned_to ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: clinical_order_genus {
    type: string
    sql: ${TABLE}.clinical_order_genus ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: clinical_order_type_group {
    type: string
    sql: ${TABLE}.clinical_order_type_group ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension: clinical_provider_order_type {
    type: string
    sql: ${TABLE}.clinical_provider_order_type ;;
  }

  dimension: context_id {
    type: number
    sql: ${TABLE}.context_id ;;
  }

  dimension: context_name {
    type: string
    sql: ${TABLE}.context_name ;;
  }

  dimension: context_parentcontextid {
    type: number
    value_format_name: id
    sql: ${TABLE}.context_parentcontextid ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
  }

  dimension: created_clinical_encounter_id {
    type: number
    sql: ${TABLE}.created_clinical_encounter_id ;;
  }

  dimension: created_datetime {
    type: string
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: cvx {
    type: number
    sql: ${TABLE}.cvx ;;
  }

  dimension: deactivated_by {
    type: string
    sql: ${TABLE}.deactivated_by ;;
  }

  dimension: deactivated_datetime {
    type: string
    sql: ${TABLE}.deactivated_datetime ;;
  }

  dimension: delegate_signed_off_by {
    type: string
    sql: ${TABLE}.delegate_signed_off_by ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}.deleted_by ;;
  }

  dimension: deleted_datetime {
    type: string
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: denied_by {
    type: string
    sql: ${TABLE}.denied_by ;;
  }

  dimension: denied_datetime {
    type: string
    sql: ${TABLE}.denied_datetime ;;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}.department_id ;;
  }

  dimension: document_category {
    type: string
    sql: ${TABLE}.document_category ;;
  }

  dimension: document_class {
    type: string
    sql: ${TABLE}.document_class ;;
  }

  dimension: document_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.document_id ;;
  }

  dimension: document_preclass {
    type: string
    sql: ${TABLE}.document_preclass ;;
  }

  dimension: document_subclass {
    type: string
    sql: ${TABLE}.document_subclass ;;
  }

  dimension: document_subject {
    type: string
    sql: ${TABLE}.document_subject ;;
  }

  dimension: external_note {
    type: string
    sql: ${TABLE}.external_note ;;
  }

  dimension: fbd_med_id {
    type: number
    sql: ${TABLE}.fbd_med_id ;;
  }

  dimension: future_submit_datetime {
    type: string
    sql: ${TABLE}.future_submit_datetime ;;
  }

  dimension: image_exists_yn {
    type: string
    sql: ${TABLE}.image_exists_yn ;;
  }

  dimension: interface_vendor_name {
    type: string
    sql: ${TABLE}.interface_vendor_name ;;
  }

  dimension: needs_provider_delegate_ack_yn {
    type: string
    sql: ${TABLE}.needs_provider_delegate_ack_yn ;;
  }

  dimension: notifier {
    type: string
    sql: ${TABLE}.notifier ;;
  }

  dimension: observation_datetime {
    type: string
    sql: ${TABLE}.observation_datetime ;;
  }

  dimension: order_datetime {
    type: string
    sql: ${TABLE}.order_datetime ;;
  }

  dimension: order_text {
    type: string
    sql: ${TABLE}.order_text ;;
  }

  dimension: out_of_network_ref_reason_name {
    type: string
    sql: ${TABLE}.out_of_network_ref_reason_name ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_note {
    type: string
    sql: ${TABLE}.patient_note ;;
  }

  dimension: priority {
    type: number
    sql: ${TABLE}.priority ;;
  }

  dimension: provider_note {
    type: string
    sql: ${TABLE}.provider_note ;;
  }

  dimension: provider_username {
    type: string
    sql: ${TABLE}.provider_username ;;
  }

  dimension: received_datetime {
    type: string
    sql: ${TABLE}.received_datetime ;;
  }

  dimension: result_notes {
    type: string
    sql: ${TABLE}.result_notes ;;
  }

  dimension: reviewed_by {
    type: string
    sql: ${TABLE}.reviewed_by ;;
  }

  dimension: reviewed_datetime {
    type: string
    sql: ${TABLE}.reviewed_datetime ;;
  }

  dimension: route {
    type: string
    sql: ${TABLE}.route ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: specimen_collected_by {
    type: string
    sql: ${TABLE}.specimen_collected_by ;;
  }

  dimension: specimen_collected_datetime {
    type: string
    sql: ${TABLE}.specimen_collected_datetime ;;
  }

  dimension: specimen_description {
    type: string
    sql: ${TABLE}.specimen_description ;;
  }

  dimension: specimen_draw_location {
    type: string
    sql: ${TABLE}.specimen_draw_location ;;
  }

  dimension: specimen_source {
    type: string
    sql: ${TABLE}.specimen_source ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: vaccine_route {
    type: string
    sql: ${TABLE}.vaccine_route ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_document_id,
      context_name,
      provider_username,
      interface_vendor_name,
      out_of_network_ref_reason_name,
      __from_filename,
      document.context_name,
      document.order_document_id,
      document.provider_username,
      document.interface_vendor_name,
      document.out_of_network_ref_reason_name,
      document.__from_filename,
      document.count
    ]
  }
}

view: test_athena_document_id_table {
  sql_table_name: athena_intermediate.id_table ;;
  suggestions: no

  dimension: __batch_id {
    type: string
    sql: ${TABLE}.__batch_id ;;
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: charge_id {
    type: number
    sql: ${TABLE}.charge_id ;;
  }

  dimension: charge_void_parent_id {
    type: number
    sql: ${TABLE}.charge_void_parent_id ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension: context_id {
    type: number
    sql: ${TABLE}.context_id ;;
  }

  dimension: created_clinical_encounter_id {
    type: number
    sql: ${TABLE}.created_clinical_encounter_id ;;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}.department_id ;;
  }

  dimension: document_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.document_id ;;
  }

  dimension: expected_allowable_schedule_id {
    type: number
    sql: ${TABLE}.expected_allowable_schedule_id ;;
  }

  dimension: fbd_med_id {
    type: number
    sql: ${TABLE}.fbd_med_id ;;
  }

  dimension: from_filename {
    type: string
    sql: ${TABLE}.from_filename ;;
  }

  dimension: from_manifest {
    type: string
    sql: ${TABLE}.from_manifest ;;
  }

  dimension: from_s3_filepath {
    type: string
    sql: ${TABLE}.from_s3_filepath ;;
  }

  dimension: from_table {
    type: string
    sql: ${TABLE}.from_table ;;
  }

  dimension: order_document_id {
    type: number
    sql: ${TABLE}.order_document_id ;;
  }

  dimension: orig_posted_payment_batch_id {
    type: number
    sql: ${TABLE}.orig_posted_payment_batch_id ;;
  }

  dimension: parent_charge_id {
    type: number
    sql: ${TABLE}.parent_charge_id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_payment_id {
    type: number
    sql: ${TABLE}.patient_payment_id ;;
  }

  dimension: payment_batch_id {
    type: number
    sql: ${TABLE}.payment_batch_id ;;
  }

  dimension: provider_group_id {
    type: number
    sql: ${TABLE}.provider_group_id ;;
  }

  dimension: transaction_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_patient_ins_id {
    type: number
    sql: ${TABLE}.transaction_patient_ins_id ;;
  }

  dimension: void_payment_batch_id {
    type: number
    sql: ${TABLE}.void_payment_batch_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      from_filename,
      document.context_name,
      document.order_document_id,
      document.provider_username,
      document.interface_vendor_name,
      document.out_of_network_ref_reason_name,
      document.__from_filename,
      transaction.context_name,
      transaction.transaction_id,
      transaction.__from_filename
    ]
  }
}

view: test_athena_document_transaction {
  sql_table_name: athena_intermediate.transaction ;;
  drill_fields: [transaction_id]
  suggestions: no

  dimension: transaction_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.transaction_id ;;
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

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: charge_from_date {
    type: string
    sql: ${TABLE}.charge_from_date ;;
  }

  dimension: charge_id {
    type: number
    sql: ${TABLE}.charge_id ;;
  }

  dimension: charge_to_date {
    type: string
    sql: ${TABLE}.charge_to_date ;;
  }

  dimension: charge_void_parent_id {
    type: number
    sql: ${TABLE}.charge_void_parent_id ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: closed_post_date {
    type: string
    sql: ${TABLE}.closed_post_date ;;
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

  dimension: custom_transaction_code {
    type: string
    sql: ${TABLE}.custom_transaction_code ;;
  }

  dimension: emgyn {
    type: string
    sql: ${TABLE}.emgyn ;;
  }

  dimension: expected_allowable_schedule_id {
    type: number
    sql: ${TABLE}.expected_allowable_schedule_id ;;
  }

  dimension: expected_allowed_amount {
    type: number
    sql: ${TABLE}.expected_allowed_amount ;;
  }

  dimension: first_billed_datetime {
    type: string
    sql: ${TABLE}.first_billed_datetime ;;
  }

  dimension: last_billed_datetime {
    type: string
    sql: ${TABLE}.last_billed_datetime ;;
  }

  dimension: malpractice_rvu {
    type: number
    sql: ${TABLE}.malpractice_rvu ;;
  }

  dimension: number_of_charges {
    type: number
    sql: ${TABLE}.number_of_charges ;;
  }

  dimension: orig_posted_payment_batch_id {
    type: number
    sql: ${TABLE}.orig_posted_payment_batch_id ;;
  }

  dimension: other_modifier {
    type: string
    sql: ${TABLE}.other_modifier ;;
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

  dimension: place_of_service {
    type: number
    sql: ${TABLE}.place_of_service ;;
  }

  dimension: post_date {
    type: string
    sql: ${TABLE}.post_date ;;
  }

  dimension: practice_expense_rvu {
    type: number
    sql: ${TABLE}.practice_expense_rvu ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
  }

  dimension: provider_group_id {
    type: string
    sql: ${TABLE}.provider_group_id ;;
  }

  dimension: reversal_flag {
    type: number
    sql: ${TABLE}.reversal_flag ;;
  }

  dimension: total_rvu {
    type: number
    sql: ${TABLE}.total_rvu ;;
  }

  dimension: transaction_created_datetime {
    type: string
    sql: ${TABLE}.transaction_created_datetime ;;
  }

  dimension: transaction_method {
    type: string
    sql: ${TABLE}.transaction_method ;;
  }

  dimension: transaction_patient_ins_id {
    type: number
    sql: ${TABLE}.transaction_patient_ins_id ;;
  }

  dimension: transaction_posted_by {
    type: string
    sql: ${TABLE}.transaction_posted_by ;;
  }

  dimension: transaction_reason {
    type: string
    sql: ${TABLE}.transaction_reason ;;
  }

  dimension: transaction_transfer_intent {
    type: string
    sql: ${TABLE}.transaction_transfer_intent ;;
  }

  dimension: transaction_transfer_type {
    type: string
    sql: ${TABLE}.transaction_transfer_type ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  dimension: units {
    type: number
    sql: ${TABLE}.units ;;
  }

  dimension: void_payment_batch_id {
    type: number
    sql: ${TABLE}.void_payment_batch_id ;;
  }

  dimension: voided_date {
    type: string
    sql: ${TABLE}.voided_date ;;
  }

  dimension: work_rvu {
    type: number
    sql: ${TABLE}.work_rvu ;;
  }

  measure: count {
    type: count
    drill_fields: [transaction_id, context_name, __from_filename, id_table.count]
  }
}

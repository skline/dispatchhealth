view: transaction {
  sql_table_name: athena.transaction ;;
  drill_fields: [transaction_id]

  dimension: transaction_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."transaction_id" ;;
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

  dimension: amount {
    type: number
    sql: ${TABLE}."amount" ;;
  }

  dimension_group: charge_from {
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
    sql: ${TABLE}."charge_from_date" ;;
  }

  dimension: charge_id {
    type: number
    sql: ${TABLE}."charge_id" ;;
  }

  dimension_group: charge_to {
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
    sql: ${TABLE}."charge_to_date" ;;
  }

  dimension: charge_void_parent_id {
    type: number
    sql: ${TABLE}."charge_void_parent_id" ;;
  }

  dimension: claim_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."claim_id" ;;
  }

  dimension_group: closed_post {
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
    sql: ${TABLE}."closed_post_date" ;;
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

  dimension: custom_transaction_code {
    type: string
    sql: ${TABLE}."custom_transaction_code" ;;
  }

  dimension: emgyn {
    type: string
    sql: ${TABLE}."emgyn" ;;
  }

  dimension: expected_allowable_schedule_id {
    type: number
    sql: ${TABLE}."expected_allowable_schedule_id" ;;
  }

  dimension: expected_allowed_amount {
    type: number
    sql: ${TABLE}."expected_allowed_amount" ;;
  }

  dimension_group: first_billed_datetime {
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
    sql: ${TABLE}."first_billed_datetime" ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: last_billed_datetime {
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
    sql: ${TABLE}."last_billed_datetime" ;;
  }

  dimension: malpractice_rvu {
    type: number
    sql: ${TABLE}."malpractice_rvu" ;;
  }

  dimension: number_of_charges {
    type: number
    sql: ${TABLE}."number_of_charges" ;;
  }

  dimension: orig_posted_payment_batch_id {
    type: number
    sql: ${TABLE}."orig_posted_payment_batch_id" ;;
  }

  dimension: other_modifier {
    type: string
    sql: ${TABLE}."other_modifier" ;;
  }

  dimension: parent_charge_id {
    type: number
    sql: ${TABLE}."parent_charge_id" ;;
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_payment_id {
    type: number
    sql: ${TABLE}."patient_payment_id" ;;
  }

  dimension: payment_batch_id {
    type: number
    sql: ${TABLE}."payment_batch_id" ;;
  }

  dimension: place_of_service {
    type: string
    sql: ${TABLE}."place_of_service" ;;
  }

  dimension_group: post {
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
    sql: ${TABLE}."post_date" ;;
  }

  dimension: practice_expense_rvu {
    type: number
    sql: ${TABLE}."practice_expense_rvu" ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}."procedure_code" ;;
  }

  dimension: reversal_flag {
    type: yesno
    sql: ${TABLE}."reversal_flag" ;;
  }

  dimension: total_rvu {
    type: number
    sql: ${TABLE}."total_rvu" ;;
  }

  dimension_group: transaction_created_datetime {
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
    sql: ${TABLE}."transaction_created_datetime" ;;
  }

  dimension: transaction_method {
    type: string
    sql: ${TABLE}."transaction_method" ;;
  }

  dimension: transaction_patient_ins_id {
    type: number
    sql: ${TABLE}."transaction_patient_ins_id" ;;
  }

  dimension: transaction_posted_by {
    type: string
    sql: ${TABLE}."transaction_posted_by" ;;
  }

  dimension: transaction_reason {
    type: string
    sql: ${TABLE}."transaction_reason" ;;
  }

  dimension: transaction_transfer_intent {
    type: string
    sql: ${TABLE}."transaction_transfer_intent" ;;
  }

  dimension: transaction_transfer_type {
    type: string
    sql: ${TABLE}."transaction_transfer_type" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."transaction_type" ;;
  }

  dimension: units {
    type: number
    sql: ${TABLE}."units" ;;
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

  dimension: void_payment_batch_id {
    type: number
    sql: ${TABLE}."void_payment_batch_id" ;;
  }

  dimension_group: voided {
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
    sql: ${TABLE}."voided_date" ;;
  }

  dimension: work_rvu {
    type: number
    sql: ${TABLE}."work_rvu" ;;
  }

  measure: count {
    type: count
    drill_fields: [transaction_id, claim.original_claim_id]
  }
}

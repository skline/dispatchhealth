view: athenadwh_transactions_clone {
  sql_table_name: looker_scratch.athenadwh_transactions_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount::numeric ;;
  }

  dimension: payment_amount {
    type: number
    sql: ${amount} * -1 ;;
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: voided_flag
      value: "no"
    }
  }

  dimension: payment_transaction {
    type: yesno
    hidden: no
    sql: ${transaction_type} = 'PAYMENT' ;;
  }

  dimension: charge_transaction {
    type: yesno
    hidden: yes
    sql: ${transaction_type} = 'CHARGE' ;;
  }

  dimension: patient_payment {
    type: yesno
    sql: ${transaction_transfer_type} = 'Patient' AND ${transaction_type} = 'PAYMENT' ;;
  }

  dimension: patient_responsibility {
    type: yesno
    sql: ${transaction_transfer_type} = 'Patient' AND ${transaction_type} = 'TRANSFERIN' ;;
  }

  dimension: patient_responsibility_without_secondary {
    description: "Patient responsibility when not taking secondary payers into account"
    type: yesno
    sql: ${patient_responsibility} OR
        (${transaction_transfer_type} = 'Secondary' AND ${transaction_type} = 'TRANSFERIN') OR
        (${transaction_transfer_type} = 'Secondary' AND ${transaction_type} = 'TRANSFEROUT') ;;
  }

  dimension: copay_transaction {
    description: "Transactions that are specific to copay"
    type: yesno
    sql: ${transaction_reason} = 'COPAY' ;;
  }

  dimension: deductible_transaction {
    description: "Transactions that are specific to deductible"
    type: yesno
    sql: ${transaction_reason} = 'DEDUCTIBLE' ;;
  }

  dimension: coinsurance_transaction {
    description: "Transactions that are specific to coinsurance"
    type: yesno
    sql: ${transaction_reason} = 'COINSURANCE' ;;
  }

  measure: total_oop_paid {
    type: sum
    sql: ${payment_amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_payment
      value: "yes"
    }
  }

  measure: total_revenue {
    type: sum
    sql: ${amount} ;;
    filters: {
      field: payment_transaction
      value: "no"
    }
  }

  measure: total_payments {
    type: sum
    sql: ${payment_amount} ;;
    value_format: "0.00"
    filters: {
      field: payment_transaction
      value: "yes"
    }
  }

  measure: total_patient_responsibility {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility
      value: "yes"
    }
  }

  measure: total_patient_responsibility_copay {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility
      value: "yes"
    }
    filters: {
      field: copay_transaction
      value: "yes"
    }
  }

  measure: total_patient_responsibility_deductible {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility
      value: "yes"
    }
    filters: {
      field: deductible_transaction
      value: "yes"
    }
  }

  measure: total_patient_responsibility_coinsurance {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility
      value: "yes"
    }
    filters: {
      field: coinsurance_transaction
      value: "yes"
    }
  }

  measure: total_patient_responsibility_without_secondary {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility_without_secondary
      value: "yes"
    }
  }

  ### Test block for expected allowable calculation

  dimension: is_valid_exp_allowable {
    type: yesno
    sql: ${transaction_type} = 'CHARGE' AND (
    (${transaction_transfer_type} = 'Primary')
    OR (${transaction_transfer_type} != 'Primary' AND ${athenadwh_patient_insurances_clone.insurance_package_id}::int = -100));;
  }

  dimension: fixed_expected_allowable {
    description: "Expected allowable where charge reversals are dealt with effectively"
    type: number
    sql: CASE
          WHEN ${reversal_flag} = 1 THEN ${expected_allowed_amount}::float * -1
          ELSE ${expected_allowed_amount}::float
        END ;;
  }

  measure: total_expected_allowable_test {
    type: sum
    description: "Transaction type is CHARGE and transfer type is PRIMARY or patient is self-pay"
    sql: ${fixed_expected_allowable}::float ;;
    value_format: "0.00"
    filters: {
      field: is_valid_exp_allowable
      value: "yes"
    }
  }

  dimension: ghost_transaction {
    type: yesno
    sql: ${transaction_reason} = 'GHOST' ;;
  }

  dimension: primary_transaction_type {
    type: yesno
    description: "A flag indicating that the transaction transfer type is primary"
    sql: ${transaction_transfer_type} = 'Primary' ;;
  }

  dimension: voided_date_is_null {
    description: "A flag indicating that the voided date is null."
    type: yesno
    sql: ${voided_date} IS NULL ;;
  }

  measure: total_expected_allowable {
    description: "Transaction type is CHARGE, transaction reason is not GHOST, transaction type is PRIMARY, voided date is NULL"
    type: sum
    sql: ${expected_allowed_amount}::float ;;
    value_format: "0.00"
    sql_distinct_key: ${transaction_id} ;;
    filters: {
      field: charge_transaction
      value: "yes"
    }
    filters: {
      field: ghost_transaction
      value: "no"
    }
    filters: {
      field: primary_transaction_type
      value: "yes"
    }
    filters: {
      field: voided_date_is_null
      value: "yes"
    }
  }

  dimension: charge_id {
    type: number
    sql: ${TABLE}.charge_id ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  measure: count_claims {
    type: count_distinct
    sql: ${claim_id} ;;
    filters: {
      field: voided_date_is_null
      value: "yes"
    }
  }

  measure: count_deductible_claims {
    type: count_distinct
    sql: ${claim_id} ;;
    filters: {
      field: deductible_transaction
      value: "yes"
    }
  }

  measure: count_copay_claims {
    type: count_distinct
    sql: ${claim_id} ;;
    filters: {
      field: copay_transaction
      value: "yes"
    }
  }

  measure: count_coinsurance_claims {
    type: count_distinct
    sql: ${claim_id} ;;
    filters: {
      field: coinsurance_transaction
      value: "yes"
    }
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: expected_allowable_schedule_id {
    type: number
    sql: ${TABLE}.expected_allowable_schedule_id ;;
  }

  dimension: expected_allowed_amount {
    type: number
    sql: ${TABLE}.expected_allowed_amount ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
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
    sql: ${TABLE}.first_billed_datetime ;;
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
    sql: ${TABLE}.last_billed_datetime ;;
  }

  dimension: other_modifier {
    type: string
    sql: ${TABLE}.other_modifier ;;
  }

  dimension: post_date {
    type: date
    sql: ${TABLE}.post_date::date ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
  }

  dimension: reversal_flag {
    type: number
    sql: ${TABLE}.reversal_flag ;;
  }

  dimension: voided_flag {
    type: yesno
    sql: ${voided_date} IS NOT NULL ;;
  }

  dimension: total_rvu {
    type: string
    sql: ${TABLE}.total_rvu ;;
  }

  measure: sum_total_rvu {
    type: sum
    sql: ${total_rvu} ;;
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
    sql: ${TABLE}.transaction_created_datetime ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}.transaction_id ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: voided_date {
    type: string
    sql: ${TABLE}.voided_date ;;
  }

  dimension: work_rvu {
    type: string
    sql: ${TABLE}.work_rvu ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

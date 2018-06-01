view: transaction_facts_clone {
  sql_table_name: looker_scratch.transaction_facts_clone ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    description: "The gross dollar amount of the transaction"
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: athena_charge_id {
    hidden: yes
    type: number
    sql: ${TABLE}.athena_charge_id ;;
  }

  dimension: athena_claim_id {
    label: "EHR Claim ID"
    description: "The ID assigned to each claim filed for an appointment"
    type: number
    sql: ${TABLE}.athena_claim_id ;;
  }

  dimension: athena_transaction_id {
    hidden: yes
    type: number
    sql: ${TABLE}.athena_transaction_id ;;
  }

  dimension: billable_to {
    description: "The role of the payer charged for the activity"
    type: string
    sql: ${TABLE}.billable_to ;;
  }

  dimension: channel_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: claim_status {
    description: "The current primary claim status of the claim; primary indicates that the patient's primary insurance is the responsible payer. values: drop, closed, hold, billed"
    type: string
    sql: ${TABLE}.claim_status ;;
  }

  dimension: cpt_code_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.cpt_code_dim_id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: expected_allowed_amount {
    description: "The dollar amount expected to be paid as calculated by the EHR provider"
    type: number
    sql: ${TABLE}.expected_allowed_amount ;;
  }

  dimension: facility_type_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.facility_type_dim_id ;;
  }

  dimension: fee_schedule_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.fee_schedule_dim_id ;;
  }

  dimension_group: local_first_billed_datetime {
    description: "The date the applicable responsible party charges were first billed"
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
    sql: ${TABLE}.local_first_billed_datetime ;;
  }

  dimension_group: local_last_billed_datetime {
    description: "The most recent bill date for the applicable responsible party"
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
    sql: ${TABLE}.local_last_billed_datetime ;;
  }

  dimension: location_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.location_dim_id ;;
  }

  dimension: market_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: no_charge_entry_reason {
    description: "The provided reason for a no-charge claim"
    type: string
    sql: ${TABLE}.no_charge_entry_reason ;;
  }

  dimension: patient_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.patient_dim_id ;;
  }

  dimension: payer_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.payer_dim_id ;;
  }

  dimension_group: post {
    description: "The date the transaction posted in the EHR"
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.post_date ;;
  }

  dimension: primary_payer_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_payer_dim_id ;;
  }

  dimension: reversal_flag {
    description: "Indicator to reverse the EHR transaction"
    type: number
    sql: ${TABLE}.reversal_flag ;;
  }

  dimension: total_rvu {
    label: "Total RVU"
    description: "Total RVU includes Work, Practice Expense, and Malpractice RVU, also adjusted for number of charges and units. Not adjusted for GPCI location."
    type: number
    sql: ${TABLE}.total_rvu ;;
  }

  dimension: transaction_reason {
    description: "The subtype of adjustment and transfer transaction types"
    type: string
    sql: ${TABLE}.transaction_reason ;;
  }

  dimension: transaction_type {
    description: "The type of the EHR transaction"
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  dimension_group: updated {
    hidden: yes
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

  dimension: visit_dim_number {
    label: "EHR Appointment ID"
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: voided_date {
    description: "The date the EHR transaction is voided"
    type: string
    sql: ${TABLE}.voided_date ;;
  }

  dimension: work_rvu {
    label: "Work RVU"
    description: "The Work RVU value for the procedure code adjusted for the number of charges and units. Not adjusted for GPCI location."
    type: number
    sql: ${TABLE}.work_rvu ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  dimension: voided_flag {
    type: yesno
    sql: ${voided_date} IS NOT NULL ;;
  }

  measure: procedures_count {
    type: count_distinct
    sql: CONCAT(${visit_dim_number}, ${cpt_code_dim_id}) ;;
    filters: {
      field: voided_flag
      value: "no"
    }
  }

  measure: transaction_billable_count {
    type: count_distinct
    sql: ${visit_dim_number} ;;
  }
}

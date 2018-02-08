view: transaction_facts {
  label: "EHR Transaction Facts"
  sql_table_name: jasperdb.transaction_facts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
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
    type: number
    sql: ${TABLE}.athena_claim_id ;;
  }

  dimension: athena_transaction_id {
    hidden: yes
    type: number
    sql: ${TABLE}.athena_transaction_id ;;
  }

  dimension: billable_to {
    type: string
    sql: ${TABLE}.billable_to ;;
  }

  dimension: channel_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: claim_status {
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
    label: "Post Date"
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
    sql: ${TABLE}.post_date ;;
  }

  dimension: primary_payer_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.primary_payer_dim_id ;;
  }

  dimension: reversal_flag {
    type: number
    sql: ${TABLE}.reversal_flag ;;
  }

  dimension: total_rvu {
    label: "Total RVU"
    type: number
    sql: ${TABLE}.total_rvu ;;
  }

  dimension: transaction_reason {
    type: string
    sql: ${TABLE}.transaction_reason ;;
  }

  dimension: transaction_type {
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
    label: "EHR ID"
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: voided_date {
    type: string
    sql: ${TABLE}.voided_date ;;
  }

  dimension: work_rvu {
    label: "Work RVU"
    type: number
    sql: ${TABLE}.work_rvu ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

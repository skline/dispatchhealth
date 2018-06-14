view: athenadwh_transactions_clone {
  sql_table_name: looker_scratch.athenadwh_transactions_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: string
    sql: ${TABLE}.amount ;;
  }

  dimension: charge_id {
    type: number
    sql: ${TABLE}.charge_id ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
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
    type: string
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
    type: string
    sql: ${TABLE}.post_date ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
  }

  dimension: reversal_flag {
    type: number
    sql: ${TABLE}.reversal_flag ;;
  }

  dimension: total_rvu {
    type: string
    sql: ${TABLE}.total_rvu ;;
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
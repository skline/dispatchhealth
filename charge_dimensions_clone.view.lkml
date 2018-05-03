view: charge_dimensions_clone {
  sql_table_name: looker_scratch.charge_dimensions_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: athena_charge_id {
    type: number
    sql: ${TABLE}.athena_charge_id ;;
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

  dimension: expected_allowed_amount {
    type: number
    sql: ${TABLE}.expected_allowed_amount ;;
  }

  dimension: patient_insurance_seq_num {
    type: number
    sql: ${TABLE}.patient_insurance_seq_num ;;
  }

  dimension: payer_dim_id {
    type: number
    sql: ${TABLE}.payer_dim_id ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}

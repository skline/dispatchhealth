view: athena_transaction_summary {
  sql_table_name: athena.transactions_summary ;;

  dimension: claim_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: is_valid_claim {
    type: yesno
    sql: ${athenadwh_appointments_clone.no_charge_entry_reason} IS NULL AND
      ${expected_allowable} > 0.01 ;;
  }

  measure: count_claims {
    type: count_distinct
    description: "Count of claims where no charge entry reason is NULL and exp. allowable > 0.01"
    sql: ${claim_id} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: work_rvu {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.work_rvu ;;
  }

  measure: sum_work_rvu {
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${work_rvu} ;;
  }

  dimension: total_rvu {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.total_rvu ;;
  }

  measure: sum_total_rvus {
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${total_rvu} ;;
  }

  dimension: expected_allowable {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.expected_allowable ;;
  }

  measure: total_expected_allowable {
    type: sum_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${expected_allowable} ;;
  }

  measure: average_expected_allowable {
    type: average_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${expected_allowable} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: patient_responsibility {
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility ;;
  }

  measure: total_patient_responsibility {
    type: sum_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility} ;;
  }

  measure: average_patient_responsibility {
    type: average_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility} ;;
  }

  dimension: patient_responsibility_copay {
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_copay ;;
  }

  measure: total_patient_responsibility_copay {
    type: sum_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_copay} ;;
  }

  measure: average_patient_responsibility_copay {
    type: average_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_copay} ;;
  }

  dimension: patient_responsibility_coinsurance {
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_coinsurance ;;
  }

  measure: total_patient_responsibility_coinsurance {
    type: sum_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  measure: average_patient_responsibility_coinsurance {
    type: average_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  ########## PLACEHOLDER FOR SETTING UP NEW DATA FROM TRANSACTIONS - DE ##########
  measure: total_patient_responsibility_deductible {
    type: sum_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }
  measure: average_patient_responsibility_deductible {
    type: average_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  dimension: patient_responsibility_without_secondary {
    type: number
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_without_secondary ;;
  }

  measure: total_patient_responsibility_without_secondary {
    type: sum_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_without_secondary} ;;
  }

  measure: average_patient_responsibility_without_secondary {
    type: average_distinct
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_without_secondary} ;;
  }

}

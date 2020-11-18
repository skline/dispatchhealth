view: athena_transaction_summary {
  sql_table_name: athena.transactions_summary ;;

  dimension: claim_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: gpci_work_multiplier {
    type: number
    group_label: "GPCI Multipliers"
    description: "The GPCI work multiplier for Medicare reimbursement"
    sql: CASE WHEN ${markets.short_name_adj} IN ('ATL','BOI','CLE','COS','DEN','IND',
    'KNX','MIA','NSH','OKC','OLY','PHX','RDU','RIC','SPO','TAC','TPA') THEN 1.000
  WHEN ${markets.short_name_adj} IN ('LAS','RNO') THEN 1.004
  WHEN ${markets.short_name_adj} = 'FTW' THEN 1.011
  WHEN ${markets.short_name_adj} = 'POR' THEN 1.016
  WHEN ${markets.short_name_adj} = 'DAL' THEN 1.018
WHEN ${markets.short_name_adj} = 'SPR' THEN 1.023
WHEN ${markets.short_name_adj} = 'HOU' THEN 1.026
WHEN ${markets.short_name_adj} = 'HRT' THEN 1.029
WHEN ${markets.short_name_adj} = 'SEA' THEN 1.031
WHEN ${markets.short_name_adj} IN ('MOR','NJR') THEN 1.045
ELSE NULL END ;;
value_format: "0.0000"
  }

  dimension: gpci_facility_multiplier {
    type: number
    group_label: "GPCI Multipliers"
    description: "The GPCI facility multiplier for Medicare reimbursement"
    sql: CASE
WHEN ${markets.short_name_adj} = 'OKC' THEN 0.886
WHEN ${markets.short_name_adj} = 'ATL' THEN 0.889
WHEN ${markets.short_name_adj} = 'BOI' THEN 0.890
WHEN ${markets.short_name_adj} = 'KNX' THEN 0.897
WHEN ${markets.short_name_adj} = 'NSH' THEN 0.897
WHEN ${markets.short_name_adj} = 'IND' THEN 0.910
WHEN ${markets.short_name_adj} = 'CLE' THEN 0.915
WHEN ${markets.short_name_adj} = 'RDU' THEN 0.930
WHEN ${markets.short_name_adj} = 'TPA' THEN 0.946
WHEN ${markets.short_name_adj} = 'PHX' THEN 0.961
WHEN ${markets.short_name_adj} = 'RIC' THEN 0.991
WHEN ${markets.short_name_adj} = 'FTW' THEN 0.991
WHEN ${markets.short_name_adj} = 'LAS' THEN 1.000
WHEN ${markets.short_name_adj} = 'RNO' THEN 1.000
WHEN ${markets.short_name_adj} = 'OLY' THEN 1.012
WHEN ${markets.short_name_adj} = 'SPO' THEN 1.012
WHEN ${markets.short_name_adj} = 'TAC' THEN 1.012
WHEN ${markets.short_name_adj} = 'DAL' THEN 1.020
WHEN ${markets.short_name_adj} = 'HOU' THEN 1.020
WHEN ${markets.short_name_adj} = 'MIA' THEN 1.026
WHEN ${markets.short_name_adj} = 'COS' THEN 1.033
WHEN ${markets.short_name_adj} = 'DEN' THEN 1.033
WHEN ${markets.short_name_adj} = 'POR' THEN 1.059
WHEN ${markets.short_name_adj} = 'SPR' THEN 1.064
WHEN ${markets.short_name_adj} = 'HRT' THEN 1.113
WHEN ${markets.short_name_adj} = 'SEA' THEN 1.170
WHEN ${markets.short_name_adj} = 'MOR' THEN 1.190
WHEN ${markets.short_name_adj} = 'NJR' THEN 1.190
ELSE NULL END ;;
value_format: "0.0000"
  }

  dimension: gpci_malpractice_multiplier {
    type: number
    group_label: "GPCI Multipliers"
    description: "The GPCI malpractice multiplier for Medicare reimbursement"
    sql: CASE
WHEN ${markets.short_name_adj} = 'IND' THEN 0.422
WHEN ${markets.short_name_adj} = 'BOI' THEN 0.464
WHEN ${markets.short_name_adj} = 'KNX' THEN 0.509
WHEN ${markets.short_name_adj} = 'NSH' THEN 0.509
WHEN ${markets.short_name_adj} = 'FTW' THEN 0.643
WHEN ${markets.short_name_adj} = 'DAL' THEN 0.657
WHEN ${markets.short_name_adj} = 'POR' THEN 0.659
WHEN ${markets.short_name_adj} = 'RDU' THEN 0.757
WHEN ${markets.short_name_adj} = 'OLY' THEN 0.823
WHEN ${markets.short_name_adj} = 'SPO' THEN 0.823
WHEN ${markets.short_name_adj} = 'TAC' THEN 0.823
WHEN ${markets.short_name_adj} = 'PHX' THEN 0.846
WHEN ${markets.short_name_adj} = 'SEA' THEN 0.854
WHEN ${markets.short_name_adj} = 'OKC' THEN 0.868
WHEN ${markets.short_name_adj} = 'RIC' THEN 0.903
WHEN ${markets.short_name_adj} = 'COS' THEN 0.905
WHEN ${markets.short_name_adj} = 'DEN' THEN 0.905
WHEN ${markets.short_name_adj} = 'HOU' THEN 0.918
WHEN ${markets.short_name_adj} = 'MOR' THEN 0.949
WHEN ${markets.short_name_adj} = 'NJR' THEN 0.949
WHEN ${markets.short_name_adj} = 'SPR' THEN 0.952
WHEN ${markets.short_name_adj} = 'ATL' THEN 0.989
WHEN ${markets.short_name_adj} = 'CLE' THEN 1.049
WHEN ${markets.short_name_adj} = 'HRT' THEN 1.094
WHEN ${markets.short_name_adj} = 'LAS' THEN 1.130
WHEN ${markets.short_name_adj} = 'RNO' THEN 1.130
WHEN ${markets.short_name_adj} = 'TPA' THEN 1.396
WHEN ${markets.short_name_adj} = 'MIA' THEN 2.598
ELSE NULL END ;;
    value_format: "0.0000"
  }

  dimension: is_valid_claim {
    type: yesno
    description: ""
    sql: ${athena_appointment.no_charge_entry_reason} IS NULL AND
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
    hidden: yes
    group_label: "RVUs"
    value_format: "0.00"
    sql: ${TABLE}.work_rvu ;;
  }

  measure: sum_work_rvu {
    type: sum_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${work_rvu} ;;
  }

  dimension: total_rvu {
    type: number
    hidden: yes
    group_label: "RVUs"
    value_format: "0.00"
    sql: ${TABLE}.total_rvu ;;
  }

  measure: sum_total_rvus {
    type: sum_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${total_rvu} ;;
  }

  measure: average_total_rvus {
    type: average_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${total_rvu} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: expected_allowable {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.expected_allowable ;;
  }

  measure: total_expected_allowable {
    type: sum_distinct
    group_label: "Expected Allowable"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${expected_allowable} ;;
  }

  measure: average_expected_allowable {
    type: average_distinct
    group_label: "Expected Allowable"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${expected_allowable} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: patient_responsibility {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility ;;
  }

  measure: total_patient_responsibility {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility} ;;
  }

  measure: average_patient_responsibility {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility} ;;
  }

  dimension: patient_responsibility_copay {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_copay ;;
  }

  measure: total_patient_responsibility_copay {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_copay} ;;
  }

  measure: average_patient_responsibility_copay {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_copay} ;;
  }

  dimension: patient_responsibility_coinsurance {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_coinsurance ;;
  }

  measure: total_patient_responsibility_coinsurance {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  measure: average_patient_responsibility_coinsurance {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  ########## PLACEHOLDER FOR SETTING UP NEW DATA FROM TRANSACTIONS - DE ##########
  dimension: patient_responsibility_deductible {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_deductible ;;
  }
  measure: total_patient_responsibility_deductible {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_deductible} ;;
  }
  measure: average_patient_responsibility_deductible {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_deductible} ;;
  }

  dimension: patient_responsibility_without_secondary {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_without_secondary ;;
  }

  measure: total_patient_responsibility_without_secondary {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_without_secondary} ;;
  }

  measure: average_patient_responsibility_without_secondary {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_without_secondary} ;;
  }

}

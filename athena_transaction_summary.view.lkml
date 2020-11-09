view: athena_transaction_summary {
  derived_table: {
    sql: WITH valid_claims AS (
        SELECT DISTINCT
          claim_id
          FROM athena.transaction
          GROUP BY claim_id
          HAVING COUNT(transaction_id) > COUNT(CASE WHEN voided_date IS NOT NULL THEN transaction_id ELSE NULL END))
    SELECT
    t.claim_id,
    array_agg(DISTINCT procedure_code) AS procedure_codes,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(work_rvu) AS work_rvu,
    SUM(total_rvu) AS total_rvu,
    SUM(CASE
            WHEN voided_date IS NULL AND transaction_transfer_type = 'Primary'
                AND transaction_type = 'CHARGE' THEN expected_allowed_amount::float
            ELSE 0.0
        END) +
    SUM(CASE
            WHEN voided_date IS NULL AND reversal_flag AND transaction_transfer_type = 'Primary'
                AND transaction_type = 'CHARGE' THEN (expected_allowed_amount::float) * -1.0
            ELSE 0.0
        END) AS expected_allowable,
    SUM(CASE
            WHEN transaction_transfer_type = 'Patient' AND transaction_type = 'TRANSFERIN' THEN amount::numeric
            ELSE 0.0
        END) AS patient_responsibility,
    SUM(CASE
            WHEN transaction_transfer_type = 'Patient' AND transaction_type = 'TRANSFERIN'
            AND transaction_reason = 'COPAY' THEN amount::numeric --'DEDUCTIBLE','COINSURANCE'
            ELSE 0.0
        END) AS patient_responsibility_copay,
    SUM(CASE
            WHEN transaction_transfer_type = 'Patient' AND transaction_type = 'TRANSFERIN'
            AND transaction_reason = 'COINSURANCE' THEN amount::numeric
            ELSE 0.0
        END) AS patient_responsibility_coinsurance,
    SUM(CASE
            WHEN transaction_transfer_type = 'Patient' AND transaction_type = 'TRANSFERIN'
            OR (transaction_transfer_type = 'Secondary' AND
            (transaction_type IN ('TRANSFERIN','TRANSFEROUT'))) THEN amount::numeric
            ELSE 0.0
        END) AS patient_responsibility_without_secondary,
    MAX(CASE WHEN transaction_reason = 'COPAY' THEN 1 ELSE 0 END) AS copay_claim,
    MAX(CASE WHEN transaction_reason = 'DEDUCTIBLE' THEN 1 ELSE 0 END) AS deductible_claim,
    MAX(CASE WHEN transaction_reason = 'COINSURANCE' THEN 1 ELSE 0 END) AS coinsurance_claim
    FROM athena.transaction t
    INNER JOIN valid_claims vc
        ON t.claim_id = vc.claim_id
    GROUP BY 1 ;;

    sql_trigger_value: SELECT MAX(id) FROM athena.transaction  where created_at > current_date - interval '2 day';;
    indexes: ["claim_id"]
    }

  dimension: claim_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: total_rvu {
    type: number
    sql: ${TABLE}.total_rvu ;;
  }

  dimension: expected_allowable {
    type: number
    sql: ${TABLE}.expected_allowable ;;
  }

  dimension: patient_responsibility {
    type: number
    sql: ${TABLE}.patient_responsibility ;;
  }

  dimension: patient_responsibility_copay {
    type: number
    sql: ${TABLE}.patient_responsibility_copay ;;
  }

  dimension: patient_responsibility_coinsurance {
    type: number
    sql: ${TABLE}.patient_responsibility_coinsurance ;;
  }

  dimension: patient_responsibility_without_secondary {
    type: number
    sql: ${TABLE}.patient_responsibility_without_secondary ;;
  }





}

view: athena_valid_claims {
  derived_table: {
    sql:
      SELECT DISTINCT
      claim_id
      FROM athena.transaction
      GROUP BY claim_id
      HAVING COUNT(transaction_id) > COUNT(CASE WHEN voided_date IS NOT NULL THEN transaction_id ELSE NULL END) ;;

      sql_trigger_value: SELECT MAX(created_at) FROM athena.claim ;;
      indexes: ["claim_id"]
    }

    dimension: claim_id {
      description: "A valid claim where less than 100% of transactions have been voided"
      type: number
      sql: ${TABLE}.claim_id ;;
    }

  }

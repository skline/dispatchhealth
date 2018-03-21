view: diagnosis_rank { # based on pattern seen here: https://discourse.looker.com/t/dynamic-rankings-filtering-dimensions-by-custom-rank/252
  derived_table: {
    sql: SELECT c_and_d, @curRank := @curRank + 1 as rank FROM (SELECT
        CONCAT(icd_code_dimensions.diagnosis_code,
        icd_code_dimensions.diagnosis_description) AS c_and_d
      FROM jasperdb.visit_facts  AS visit_facts
      LEFT JOIN jasperdb.market_dimensions  AS market_dimensions ON market_dimensions.id = visit_facts.market_dim_id
      LEFT JOIN jasperdb.visit_dimensions  AS visit_dimensions ON visit_dimensions.care_request_id = visit_facts.care_request_id
      LEFT JOIN jasperdb.transaction_facts  AS transaction_facts ON transaction_facts.visit_dim_number = visit_dimensions.visit_number
      LEFT JOIN jasperdb.icd_visit_joins  AS icd_visit_joins ON transaction_facts.visit_dim_number = icd_visit_joins.visit_dim_number
      LEFT JOIN jasperdb.icd_code_dimensions  AS icd_code_dimensions ON icd_visit_joins.icd_dim_id = icd_code_dimensions.id

      WHERE ((icd_code_dimensions.diagnosis_code IS NOT NULL)) AND (market_dimensions.market_name LIKE '%')
      GROUP BY 1
      ORDER BY COUNT(DISTINCT CASE
                WHEN (visit_facts.visit_dim_number IS NOT NULL AND visit_facts.no_charge_entry_reason IS NULL) THEN visit_facts.care_request_id
                ELSE NULL
              END ) DESC
      LIMIT 3000) a, (select @curRank := 0) r
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: c_and_d {
    type: string
    sql: ${TABLE}.c_and_d ;;
    hidden: yes
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  set: detail {
    fields: [c_and_d, rank]
  }
}

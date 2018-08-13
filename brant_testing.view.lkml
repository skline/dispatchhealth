view: brant_testing {
  derived_table: {
    sql: SELECT * FROM (VALUES (75.20359693877552, 400, 2, 'Commercial', 1, 'Colorado Springs'),
          (3.20359693877552, 4, 5, 'Medicaid', 2, 'Houston'),
          (15.20359693877552, 234, 4, 'Medicare', 3, 'Denver'),
          (12.20359693877552, 89, 4, 'Medicare Advantage', 4, 'Las Vegas'))
      AS test_table (avg_patient_responsibility_without_coinsurance,billable_count,insurance_classification_id,
                    insurance_classification_name,market_id,market_name);;
  }

  dimension: insurance_classification_name {
    type: string
    sql: ${TABLE}.insurance_classification_name ;;
  }

  dimension: avg_patient_responsibility_without_coinsurance {
    type: number
    sql: ${TABLE}.avg_patient_responsibility_without_coinsurance ;;
  }

  dimension: billable_count {
    type: number
    sql: ${TABLE}.billable_count ;;
  }

  dimension: insurance_classification_id {
    type: number
    sql: ${TABLE}.insurance_classification_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}.market_name ;;
  }
}

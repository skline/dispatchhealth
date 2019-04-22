view: income_pop_by_zipcode_small {
  sql_table_name: looker_scratch.income_pop_by_zipcode_small ;;

  dimension: mean_income {
    type: number
    sql: ${TABLE}.mean_income ;;
  }

  dimension: median_income {
    type: number
    sql: ${TABLE}.median_income ;;
  }

  dimension: median_income_band_25K {
    type: number
    sql:  round(median_income/25000.00, 0) *25000.00;;
  }


  dimension: population {
    type: number
    sql: ${TABLE}.population ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: cac_costs {
  sql_table_name: looker_scratch.cac_costs ;;

  dimension: cost {
    type: number
    value_format:"$#;($#)"
    sql: ${TABLE}."cost" ;;
  }
  measure: sum_cost {
    label: "Sum Cost (SEM Budget)"
    type: sum_distinct
    value_format:"$#;($#)"
    sql_distinct_key: concat(${market_id}, ${date_month}, ${type}) ;;
    sql: ${cost} ;;
  }

  measure: sum_sem_cost {
    label: "SEM Budget"
    type: sum_distinct
    value_format:"$#;($#)"
    sql_distinct_key: concat(${market_id}, ${date_month}, ${type}) ;;
    sql: ${cost} ;;
    filters: {
      field: type
      value: "SEM Budget"
    }
  }

  measure: sum_cost_sem_actual {
    label: "Sum Cost (SEM Actual)"
    value_format:"$#;($#)"
    type: number
    sql: coalesce(max(${sem_run_rate.ad_cost_monthly_run_rate}),0)+coalesce(${sum_cost},0)-coalesce(${sum_sem_cost},0);;
  }

  measure: cac_actual_sem {
    type: number
    value_format:"$#;($#)"
    sql: ${sum_cost_sem_actual}/${care_request_flat.monthly_new_patients_run_rate} ;;
  }

  measure: cac_budget_sem {
    value_format:"$#;($#)"
    type: number
    sql: ${sum_cost}/${care_request_flat.monthly_new_patients_run_rate} ;;
  }


  dimension_group: date {
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
    sql: ${TABLE}."date" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }




}

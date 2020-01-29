view: mbo_metrics {
  sql_table_name: looker_scratch.mbo_metrics ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: accounts_receivable_days {
    description: "Average of monthly AR days"
    type: number
    sql: ${TABLE}."accounts_receivable_days" ;;
    value_format: "0.0"
  }

  measure: average_accounts_receivable_days {
    description: "Average of monthly AR days"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${accounts_receivable_days} ;;
    value_format: "0.0"

  }

  dimension: advanced_care_revenue {
    type: number
    sql: ${TABLE}."advanced_care_revenue" ;;
    value_format: "$#,##0;($#,##0)"
  }

  measure: sum_advanced_care_revenue {
    description: "sum of monthly advanced care revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${advanced_care_revenue} ;;
    value_format: "$#,##0;($#,##0)"

  }

  dimension: care_team_service_level {
    type: number
    sql: ${TABLE}."care_team_service_level" ;;
    value_format: "0%"
  }

  measure: average_care_team_service_level {
    description: "Average of monthly care team service level"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${care_team_service_level} ;;
    value_format: "0%"
  }

  dimension: clinical_partner_revenue {
    type: number
    sql: ${TABLE}."clinical_partner_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_clinical_partner_revenue {
    description: "Sum of monthly clinical partner revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${clinical_partner_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: coding_audit_score {
    type: number
    sql: ${TABLE}."coding_audit_score" ;;
    value_format: "0.0"
  }

  measure: average_coding_audit_score {
    description: "Average of monthly coding audit score"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${coding_audit_score} ;;
    value_format: "0.0"
  }

  dimension: collectibility {
    type: number
    sql: ${TABLE}."collectibility" ;;
    value_format: "0%"
  }

  measure: average_collectibility {
    description: "Average of monthly RCM collectibility rate"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${collectibility} ;;
    value_format: "0%"
  }

  dimension: contribution_margin {
    type: number
    sql: ${TABLE}."contribution_margin" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_contribution_margin {
    description: "Sum of monthly contribution margin"
    type: sum_distinct
    sql_distinct_key: id ;;
    sql:  ${contribution_margin} ;;
    value_format:  "$#,##0;($#,##0)"
  }



  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

#   Added as calculation below
#     dimension: customer_acquisition_cost {
#     type: number
#     sql: ${TABLE}."customer_acquisition_cost" ;;
#     value_format:  "$#,##0;($#,##0)"
#
#   }

  dimension: ebitda {
    type: number
    sql: ${TABLE}."ebitda" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_ebitda {
    description: "Sum of monthly EBITDA"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${ebitda} ;;
    value_format:  "$#,##0;($#,##0)"

  }

  dimension: extended_care_revenue {
    type: number
    sql: ${TABLE}."extended_care_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_extended_care_revenue {
    description: "Sum of monthly extended care revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${extended_care_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: handle_time {
    type: number
    sql: ${TABLE}."handle_time" ;;
    value_format: "0"
  }

  measure: avearge_handle_time {
    description: "Average of monthly handle time"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${handle_time} ;;
    value_format: "0"
  }

  dimension: high_trust_certification {
    type: string
    sql: ${TABLE}."high_trust_certification" ;;
  }

  measure: report_high_trust_certification {
    type: string
    sql: ${high_trust_certification} ;;
  }

  dimension: managed_care_penetration {
    type: number
    sql: ${TABLE}."managed_care_penetration" ;;
    value_format: "0%"

  }

  measure: average_managed_care_penetration {
    description: "Average of monthly managed care penetration rate"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${managed_care_penetration} ;;
    value_format: "0%"
  }

  dimension: maximum_customer_concentration {
    type: number
    sql: ${TABLE}."maximum_customer_concentration" ;;
    value_format: "0.0%"

  }

  measure: average_maximum_customer_concentration {
    description: "Average of monthly maximum customer concentration rate"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql:  ${maximum_customer_concentration} ;;
    value_format: "0.0%"

  }

  dimension: near_miss_reporting_rate {
    type: number
    sql: ${TABLE}."near_miss_reporting_rate" ;;
    value_format: "0.0%"
  }

  measure: average_near_miss_reporting_rate {
    description: "Average of monthly near miss reporting rate"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${near_miss_reporting_rate} ;;
    value_format: "0.0%"
  }

  dimension: new_clinical_partner_revenue {
    type: number
    sql: ${TABLE}."new_clinical_partner_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_new_clinical_partner_revenue {
    description: "Sum of new clinical partner revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${new_clinical_partner_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: novel_unbudgeted_revenue {
    type: number
    sql: ${TABLE}."novel_unbudgeted_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_novel_unbudgeted_revenue {
    description: "Sum of monthly novel unbudgeted revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${novel_unbudgeted_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: partner_nps {
    type: number
    sql: ${TABLE}."partner_nps" ;;
    value_format: "0"
  }

  measure: average_partner_nps {
    description: "Average of monthly partner NPS"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${partner_nps} ;;
    value_format: "0"
  }

  dimension: rcm_touchless_rate {
    type: number
    sql: ${TABLE}."rcm_touchless_rate" ;;
    value_format: "0%"
  }

  measure: average_rcm_touchless_rate {
    description: "Average of monthly RCM touchless rate"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${rcm_touchless_rate} ;;
    value_format: "0%"
  }

  dimension_group: report {
    type: time
    timeframes: [
      raw,
      date,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."report_date" ;;
  }

  dimension: total_care_team_costs {
    type: number
    sql: ${TABLE}."total_care_team_costs" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_total_care_team_costs {
    description: "Sum of monthly total care team costs"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_care_team_costs} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_direct_costs {
    type: number
    sql: ${TABLE}."total_direct_costs" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_total_direct_costs {
    description: "Sum of total monthly direct costs"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_direct_costs} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_net_revenue {
    type: number
    sql: ${TABLE}."total_net_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_total_net_revenue {
    description: "Sum of total montly net revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_net_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_rcm_costs {
    type: number
    sql: ${TABLE}."total_rcm_costs" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_total_rcm_costs {
    description: "Sum of total RCM costs"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_rcm_costs} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_revenue_run_rate {
    type: number
    sql: ${TABLE}."total_revenue_run_rate" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: average_total_revenue_run_rate {
    description: "Average of total monthly revenue run rate"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_revenue_run_rate} ;;
    value_format:  "$#,##0;($#,##0)"

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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: indirect_marketing_costs {
    type: number
    sql: ${TABLE}."indirect_marketing_costs" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_indirect_marketing_costs {
    description: "Sum of indirect marketing costs"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${indirect_marketing_costs} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: visits_finance {
    type: number
    sql: ${TABLE}."visits_finance" ;;
    value_format:  "#,##0"
  }

  measure: sum_visits_finance {
    description: "Sum of Finance reported patient visits"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${visits_finance} ;;
    value_format:  "#,##0"
  }

  dimension: new_patients_finance {
    type: number
    sql: ${TABLE}."new_patients_finance" ;;
    value_format:  "#,##0"
  }

  measure: sum_new_patients_finance {
    description: "Sum of Finance reported new patients"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${new_patients_finance} ;;
    value_format:  "#,##0"
  }

  dimension: trailing_3_months_new_patients {
    type: number
    sql: ${TABLE}."trailing_3_months_new_patients" ;;
    value_format:  "#,##0"
  }

  dimension: trailing_3_months_indirect_marketing_expense {
    type: number
    sql: ${TABLE}."trailing_3_months_indirect_marketing_expense" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: gross_margin {
    type: number
    sql: ${total_net_revenue} - ${total_direct_costs} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_gross_margin {
    description: "Sum of monthly gross margin"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${gross_margin} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: direct_costs_per_visit {
    type: number
    sql: ${total_direct_costs} / ${visits_finance} ;;
    value_format:  "$#,##0;($#,##0)"
  }

measure: average_direct_costs_per_visit {
  description: "Average of monthly direct costs per visit"
  type: average_distinct
  sql_distinct_key: id ;;
  sql: ${direct_costs_per_visit} ;;
  value_format:  "$#,##0;($#,##0)"
}

  dimension: customer_acquisition_cost {
    type: number
    sql: ${trailing_3_months_indirect_marketing_expense} / ${trailing_3_months_new_patients} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: average_customer_acquisition_cost {
    description: "Average of monthly customer acquisition cost"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${customer_acquisition_cost} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: cost_per_claim {
    type: number
    sql: ${total_rcm_costs} / ${visits_finance} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: average_cost_per_claim {
    description: "Average of monthly cost per claim"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${cost_per_claim} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: call_center_cost_per_visit {
    type: number
    sql: ${total_care_team_costs} / ${visits_finance} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: average_call_center_cost_per_visit {
    description: "Average of monthly call center cost per visit"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${call_center_cost_per_visit} ;;
    value_format:  "$#,##0;($#,##0)"
  }




  measure: count {
    type: count
    drill_fields: [id]
  }
}

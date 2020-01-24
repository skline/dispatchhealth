view: mbo_metrics {
  sql_table_name: looker_scratch.mbo_metrics ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: accounts_receivable_days {
    description: "Average of montly AR days"
    type: number
    sql: ${TABLE}."accounts_receivable_days" ;;
    value_format: "0.0"
  }

  dimension: advanced_care_revenue {
    type: number
    sql: ${TABLE}."advanced_care_revenue" ;;
    value_format: "$#,##0;($#,##0)"
  }

  dimension: care_team_service_level {
    type: number
    sql: ${TABLE}."care_team_service_level" ;;
    value_format: "0%"
  }

  dimension: clinical_partner_revenue {
    type: number
    sql: ${TABLE}."clinical_partner_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: coding_audit_score {
    type: number
    sql: ${TABLE}."coding_audit_score" ;;
    value_format: "0.0"
  }

  dimension: collectibility {
    type: number
    sql: ${TABLE}."collectibility" ;;
    value_format: "0%"
  }

  dimension: contribution_margin {
    type: number
    sql: ${TABLE}."contribution_margin" ;;
    value_format:  "$#,##0;($#,##0)"
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

  dimension: extended_care_revenue {
    type: number
    sql: ${TABLE}."extended_care_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: handle_time {
    type: number
    sql: ${TABLE}."handle_time" ;;
    value_format: "0"
  }

  dimension: high_trust_certification {
    type: string
    sql: ${TABLE}."high_trust_certification" ;;
  }

  dimension: managed_care_penetration {
    type: number
    sql: ${TABLE}."managed_care_penetration" ;;
    value_format: "0%"

  }

  dimension: maximum_customer_concentration {
    type: number
    sql: ${TABLE}."maximum_customer_concentration" ;;
    value_format: "0.0%"

  }

  dimension: near_miss_reporting_rate {
    type: number
    sql: ${TABLE}."near_miss_reporting_rate" ;;
    value_format: "0.0%"
  }

  dimension: new_clinical_partner_revenue {
    type: number
    sql: ${TABLE}."new_clinical_partner_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: novel_unbudgeted_revenue {
    type: number
    sql: ${TABLE}."novel_unbudgeted_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: partner_nps {
    type: number
    sql: ${TABLE}."partner_nps" ;;
    value_format: "0"
  }

  dimension: rcm_touchless_rate {
    type: number
    sql: ${TABLE}."rcm_touchless_rate" ;;
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

  dimension: total_direct_costs {
    type: number
    sql: ${TABLE}."total_direct_costs" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_net_revenue {
    type: number
    sql: ${TABLE}."total_net_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_rcm_costs {
    type: number
    sql: ${TABLE}."total_rcm_costs" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_revenue_run_rate {
    type: number
    sql: ${TABLE}."total_revenue_run_rate" ;;
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

  dimension: visits_finance {
    type: number
    sql: ${TABLE}."visits_finance" ;;
    value_format:  "#,##0"
  }

  dimension: new_patients_finance {
    type: number
    sql: ${TABLE}."new_patients_finance" ;;
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

  dimension: new_patient_percentage_finance {
    type: number
    sql: ${new_patients_finance} / ${visits_finance} ;;
    value_format: "0%"

  }

  dimension: direct_costs_per_visit {
    type: number
    sql: ${total_direct_costs} / ${visits_finance} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: customer_acquisition_cost {
    type: number
    sql: ${trailing_3_months_indirect_marketing_expense} / ${trailing_3_months_new_patients} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: cost_per_claim {
    type: number
    sql: ${total_rcm_costs} / ${visits_finance} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: call_center_cost_per_visit {
    type: number
    sql: ${total_care_team_costs} / ${visits_finance} ;;
    value_format:  "$#,##0;($#,##0)"
  }




  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: mbo_metrics_quarterly_goals {
  sql_table_name: looker_scratch.mbo_metrics_quarterly_goals ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: bounceback_14day_rate_qg {
    type: number
    sql: ${TABLE}."bounceback_14day_rate_qg" ;;
  }

  measure: average_bounceback_14day_rate_qg {
    description: "Average of 14 day bounceback quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${bounceback_14day_rate_qg} ;;
    value_format: "0.0%"
  }

  dimension: call_center_cost_per_billable_visit_qg {
    type: number
    sql: ${TABLE}."call_center_cost_per_billable_visit_qg" ;;
  }

  measure: average_call_center_cost_per_billable_visit_qg {
    description: "Average call center per visit quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${call_center_cost_per_billable_visit_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: care_team_turnover_rate_qg {
    type: number
    sql: ${TABLE}."care_team_turnover_rate_qg" ;;
  }


  measure: average_care_team_turnover_rate_qg {
    description: "Average care team turnover quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${care_team_turnover_rate_qg} ;;
    value_format: "0.0%"
  }

  dimension: clinical_employee_turnover_rate_qg {
    type: number
    sql: ${TABLE}."clinical_employee_turnover_rate_qg" ;;
  }

  measure: average_clinical_employee_turnover_rate_qg {
    description: "Average clinical team turnover quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${clinical_employee_turnover_rate_qg} ;;
    value_format: "0.0%"
  }

  dimension: coding_audit_score_qg {
    type: number
    sql: ${TABLE}."coding_audit_score_qg" ;;
  }

  measure: average_coding_audit_score_qg {
    description: "Average coding audit score quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${coding_audit_score_qg} ;;
    value_format: "0"
  }

  dimension: collectibility_qg {
    type: number
    sql: ${TABLE}."collectibility_qg" ;;
  }

  measure: average_collectibility_qg {
    description: "Average clinical team turnover quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${clinical_employee_turnover_rate_qg} ;;
    value_format: "0.0%"
  }


  dimension: contribution_margin_rate_qg {
    type: number
    sql: ${TABLE}."contribution_margin_rate_qg" ;;
  }

  measure: average_contribution_margin_rate_qg {
    description: "Average contribution rate quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${contribution_margin_rate_qg} ;;
    value_format: "0.0%"
  }

  dimension: cost_per_claim_qg {
    type: number
    sql: ${TABLE}."cost_per_claim_qg" ;;
  }

  measure: average_cost_per_claim_qg {
    description: "Average cost per claim quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${cost_per_claim_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }


  dimension: cost_savings_per_visit_qg {
    type: number
    sql: ${TABLE}."cost_savings_per_visit_qg" ;;
  }

  measure: average_cost_savings_per_visit_qg {
    description: "Average cost savings per visit quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${cost_savings_per_visit_qg} ;;
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

  dimension: customer_acquisition_cost_qg {
    type: number
    sql: ${TABLE}."customer_acquisition_cost_qg" ;;
  }

  measure: average_customer_acquisition_cost_qg {
    description: "Average customer acquisition cost quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${customer_acquisition_cost_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: direct_cost_per_visit_qg {
    type: number
    sql: ${TABLE}."direct_cost_per_visit_qg" ;;
  }

  measure: average_direct_cost_per_visit_qg {
    description: "Average direct costs per visit quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${direct_cost_per_visit_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: ebitda_margin_qg {
    type: number
    sql: ${TABLE}."ebitda_margin_qg" ;;
  }

  measure: average_ebitda_margin_qg {
    description: "Average EBITDA margin quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${ebitda_margin_qg} ;;
    value_format:  "0%;(0%)"
  }

  dimension: employee_turnover_rate_qg {
    type: number
    sql: ${TABLE}."employee_turnover_rate_qg" ;;
  }

  measure: average_employee_turnover_rate_qg {
    description: "Average employee turnover quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${employee_turnover_rate_qg} ;;
    value_format: "0.0%"
  }

  dimension: expected_allowable_qg {
    type: number
    sql: ${TABLE}."expected_allowable_qg" ;;
  }

  measure: average_expected_allowable_qg {
    description: "Average direct costs per visit quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${expected_allowable_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: gross_clinical_partner_revenue_qg {
    type: number
    sql: ${TABLE}."gross_clinical_partner_revenue_qg" ;;
  }

  measure: sum_gross_clinical_partner_revenue_qg {
    description: "Sum gross clinical partner revenue quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${gross_clinical_partner_revenue_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: gross_margin_rate_qg {
    type: number
    sql: ${TABLE}."gross_margin_rate_qg" ;;
  }

  measure: average_gross_margin_rate_qg {
    description: "Average gross margin rate quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${gross_margin_rate_qg} ;;
    value_format:  "0%;(0%)"
  }


  dimension: lwbs_rate_qg {
    type: number
    sql: ${TABLE}."lwbs_rate_qg" ;;
  }

  measure: average_lwbs_rate_qg {
    description: "Average left without being seen (LWBS) rate quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${lwbs_rate_qg} ;;
    value_format:  "0%;(0%)"
  }

  dimension: managed_care_penetration_qg {
    type: number
    sql: ${TABLE}."managed_care_penetration_qg" ;;
  }

  measure: average_managed_care_penetration_qg {
    description: "Average managed care penetration quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${managed_care_penetration_qg} ;;
    value_format:  "0%;(0%)"
  }

  dimension: maximum_customer_concentration_qg {
    type: number
    sql: ${TABLE}."maximum_customer_concentration_qg" ;;
  }

  measure: average_maximum_customer_concentration_qg {
    description: "Average maximum customer concentration quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${maximum_customer_concentration_qg} ;;
    value_format:  "0.0%;(0.0%)"
  }

  dimension: near_miss_reporting_rate_qg {
    type: number
    sql: ${TABLE}."near_miss_reporting_rate_qg" ;;
  }

  measure: average_near_miss_reporting_rate_qg {
    description: "Average near miss reporting rate quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${near_miss_reporting_rate_qg} ;;
    value_format:  "0.0%;(0.0%)"
  }


  dimension: new_gross_clinical_partner_revenue_qg {
    type: number
    sql: ${TABLE}."new_gross_clinical_partner_revenue_qg" ;;
  }

  measure: sum_new_gross_clinical_partner_revenue_qg {
    description: "Sum new gross clinical partner revenue quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${new_gross_clinical_partner_revenue_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }


  dimension: new_markets_qg {
    type: number
    sql: ${TABLE}."new_markets_qg" ;;
  }

  measure: sum_new_markets_qg {
    description: "Sum of new markets quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${new_markets_qg} ;;
    value_format:  "#,##0"
  }

  dimension: new_states_qg {
    type: number
    sql: ${TABLE}."new_states_qg" ;;
  }

  measure: sum_new_states_qg  {
    description: "Sum of new market states quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${new_states_qg} ;;
    value_format: "#,##0"
  }

  dimension: novel_unbudgeted_revenue_qg {
    type: number
    sql: ${TABLE}."novel_unbudgeted_revenue_qg" ;;
  }

  measure: sum_novel_unbudgeted_revenue_qg {
    description: "Sum of novel unbedgeted revenue quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${novel_unbudgeted_revenue_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: partner_nps_qg {
    type: number
    sql: ${TABLE}."partner_nps_qg" ;;
  }

  measure: average_partner_nps_qg {
    description: "Average partner NPS quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${partner_nps_qg} ;;
    value_format:  "0"
  }

  dimension: patient_nps_qg {
    type: number
    sql: ${TABLE}."patient_nps_qg" ;;
  }

  measure: average_patient_nps_qg {
    description: "Average patient NPS quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${patient_nps_qg} ;;
    value_format:  "0"
  }


  dimension: productivity_qg {
    type: number
    sql: ${TABLE}."productivity_qg" ;;
  }

  measure: average_productivity_qg {
    description: "Average productivity quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${productivity_qg} ;;
    value_format:  "0.00;(0.00)"
  }

  dimension_group: quarter_end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."quarter_end_date" ;;
  }

  dimension: quarter_id {
    type: string
    sql: ${TABLE}."quarter_id" ;;
  }

  dimension_group: quarter_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."quarter_start_date" ;;
  }

  dimension: rcm_touchless_rate_qg {
    type: number
    sql: ${TABLE}."rcm_touchless_rate_qg" ;;
  }

  measure: average_rcm_touchless_rate_qg {
    description: "Average RCM touchless rate quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${rcm_touchless_rate_qg} ;;
    value_format:  "0%"
  }

  dimension: total_billable_visits_qg {
    type: number
    sql: ${TABLE}."total_billable_visits_qg" ;;
  }

  measure: sum_total_billable_visits_qg {
    description: "Sum of Finance total billable visit quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_billable_visits_qg} ;;
    value_format:  "#,##0"
  }

  dimension: total_net_advanced_extended_care_revenue_qg {
    type: number
    sql: ${TABLE}."total_net_advanced_extended_care_revenue_qg" ;;
  }

  measure: sum_total_net_advanced_extended_care_revenue_qg {
    description: "Sum of total net advanced and extended care revenue quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_net_advanced_extended_care_revenue_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }


  dimension: total_net_revenue_qg {
    type: number
    sql: ${TABLE}."total_net_revenue_qg" ;;
  }

  measure: sum_total_net_revenue_qg {
    description: "Sum of total net revenue quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_net_revenue_qg} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_revenue_run_rate_qg {
    type: number
    sql: ${TABLE}."total_revenue_run_rate_qg" ;;
  }

  measure: sum_total_revenue_run_rate_qg {
    description: "Sum of total revenue run rate quarterly goal"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_revenue_run_rate_qg} ;;
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

  dimension: yield_exp_allowable_cac_cost_per_call_qg {
    type: number
    sql: ${TABLE}."yield_exp_allowable_cac_cost_per_call_qg" ;;
  }

  measure: average_yield_exp_allowable_cac_cost_per_call_qg {
    description: "Average RCM touchless rate quarterly goal"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${yield_exp_allowable_cac_cost_per_call_qg} ;;
    value_format:  "0.0"
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

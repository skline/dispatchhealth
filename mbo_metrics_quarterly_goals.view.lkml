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

  dimension: call_center_cost_per_billable_visit_qg {
    type: number
    sql: ${TABLE}."call_center_cost_per_billable_visit_qg" ;;
  }

  dimension: care_team_turnover_rate_qg {
    type: number
    sql: ${TABLE}."care_team_turnover_rate_qg" ;;
  }

  dimension: clinical_employee_turnover_rate_qg {
    type: number
    sql: ${TABLE}."clinical_employee_turnover_rate_qg" ;;
  }

  dimension: coding_audit_score_qg {
    type: number
    sql: ${TABLE}."coding_audit_score_qg" ;;
  }

  dimension: collectibility_qg {
    type: number
    sql: ${TABLE}."collectibility_qg" ;;
  }

  dimension: contribution_margin_rate_qg {
    type: number
    sql: ${TABLE}."contribution_margin_rate_qg" ;;
  }

  dimension: cost_per_claim_qg {
    type: number
    sql: ${TABLE}."cost_per_claim_qg" ;;
  }

  dimension: cost_savings_per_visit_qg {
    type: number
    sql: ${TABLE}."cost_savings_per_visit_qg" ;;
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

  dimension: direct_cost_per_visit_qg {
    type: number
    sql: ${TABLE}."direct_cost_per_visit_qg" ;;
  }

  dimension: ebitda_margin_qg {
    type: number
    sql: ${TABLE}."ebitda_margin_qg" ;;
  }

  dimension: employee_turnover_rate_qg {
    type: number
    sql: ${TABLE}."employee_turnover_rate_qg" ;;
  }

  dimension: expected_allowable_qg {
    type: number
    sql: ${TABLE}."expected_allowable_qg" ;;
  }

  dimension: gross_clinical_partner_revenue_qg {
    type: number
    sql: ${TABLE}."gross_clinical_partner_revenue_qg" ;;
  }

  dimension: gross_margin_rate_qg {
    type: number
    sql: ${TABLE}."gross_margin_rate_qg" ;;
  }

  dimension: lwbs_rate_qg {
    type: number
    sql: ${TABLE}."lwbs_rate_qg" ;;
  }

  dimension: managed_care_penetration_qg {
    type: number
    sql: ${TABLE}."managed_care_penetration_qg" ;;
  }

  dimension: maximum_customer_concentration_qg {
    type: number
    sql: ${TABLE}."maximum_customer_concentration_qg" ;;
  }

  dimension: near_miss_reporting_rate_qg {
    type: number
    sql: ${TABLE}."near_miss_reporting_rate_qg" ;;
  }

  dimension: new_gross_clinical_partner_revenue_qg {
    type: number
    sql: ${TABLE}."new_gross_clinical_partner_revenue_qg" ;;
  }

  dimension: new_markets_qg {
    type: number
    sql: ${TABLE}."new_markets_qg" ;;
  }

  dimension: new_states_qg {
    type: number
    sql: ${TABLE}."new_states_qg" ;;
  }

  dimension: novel_unbudgeted_revenue_qg {
    type: number
    sql: ${TABLE}."novel_unbudgeted_revenue_qg" ;;
  }

  dimension: partner_nps_qg {
    type: number
    sql: ${TABLE}."partner_nps_qg" ;;
  }

  dimension: patient_nps_qg {
    type: number
    sql: ${TABLE}."patient_nps_qg" ;;
  }

  dimension: productivity_qg {
    type: number
    sql: ${TABLE}."productivity_qg" ;;
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

  dimension: total_billable_visits_qg {
    type: number
    sql: ${TABLE}."total_billable_visits_qg" ;;
  }

  dimension: total_net_advanced_extended_care_revenue_qg {
    type: number
    sql: ${TABLE}."total_net_advanced_extended_care_revenue_qg" ;;
  }

  dimension: total_net_revenue_qg {
    type: number
    sql: ${TABLE}."total_net_revenue_qg" ;;
  }

  dimension: total_revenue_run_rate_qg {
    type: number
    sql: ${TABLE}."total_revenue_run_rate_qg" ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}

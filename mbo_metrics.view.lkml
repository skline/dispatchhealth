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

  dimension: customer_acquisition_cost {
    type: number
    sql: ${TABLE}."customer_acquisition_cost" ;;
    value_format:  "$#,##0;($#,##0)"

  }

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

  measure: count {
    type: count
    drill_fields: [id]
  }
}

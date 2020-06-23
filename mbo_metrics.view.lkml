view: mbo_metrics {
  sql_table_name: looker_scratch.mbo_metrics ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: coding_audit_score {
    type: number
    sql: ${TABLE}."coding_audit_score" ;;
    value_format: "0.0"
  }

  dimension: clinical_safety_jira_tickets {
    type: number
    sql: ${TABLE}.clinical_safety_jira_tickets ;;
  }

  measure: average_coding_audit_score {
    description: "Average of monthly coding audit score"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${coding_audit_score} ;;
    value_format: "0.0"
  }

  measure: sum_clinical_safety_tickets {
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${clinical_safety_jira_tickets} ;;
    value_format: "0"
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

  dimension: count_adverse_events {
    type: number
    sql: ${TABLE}."count_adverse_events" ;;
    value_format: "0"
  }

  measure: sum_count_adverse_events {
    description: "Sum of adverse events"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${count_adverse_events} ;;
    value_format: "0"
  }

  dimension: count_near_misses {
    type: number
    sql: ${TABLE}."count_near_misses" ;;
  }

  measure: sum_count_near_misses {
    description: "Sum of the count of near misses in reporting"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${count_near_misses} ;;
    value_format: "0"
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

  dimension: days_in_ar {
    type: number
    sql: ${TABLE}."days_in_ar" ;;
    value_format: "0.0"
  }

  measure: average_days_in_ar {
    description: "Average of monthly AR days"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${days_in_ar} ;;
    value_format: "0.0"

  }

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

  dimension: gross_clinical_partner_revenue {
    type: number
    sql: ${TABLE}."gross_clinical_partner_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_gross_clinical_partner_revenue {
    description: "Sum of goss clinical partner revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${gross_clinical_partner_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: high_trust_certification {
    type: string
    sql: ${TABLE}."high_trust_certification" ;;
  }

  measure: report_high_trust_certification {
    type: string
    sql: ${high_trust_certification} ;;
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

  dimension: indirect_marketing_costs_ttm {
    type: number
    sql: ${TABLE}."indirect_marketing_costs_ttm" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: customer_acquisition_cost {
    type: number
    sql: ${indirect_marketing_costs_ttm} / ${new_patients_ttm} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: average_customer_acquisition_cost {
    description: "Average of monthly customer acquisition cost"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${customer_acquisition_cost} ;;
    value_format:  "$#,##0;($#,##0)"
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


  dimension: net_advanced_care_revenue {
    type: number
    sql: ${TABLE}."net_advanced_care_revenue" ;;
    value_format: "$#,##0;($#,##0)"
  }

  measure: sum_net_advanced_care_revenue {
    description: "Sum of monthly net advanced care revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${net_advanced_care_revenue} ;;
    value_format: "$#,##0;($#,##0)"
  }

  dimension: net_extended_care_revenue {
    type: number
    sql: ${TABLE}."net_extended_care_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_net_extended_care_revenue {
    description: "Sum of monthly net extended care revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${net_extended_care_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: new_gross_clinical_partner_revenue {
    type: number
    sql: ${TABLE}."new_gross_clinical_partner_revenue" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_new_gross_clinical_partner_revenue {
    description: "Sum of new gross clinical partner revenue"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${new_gross_clinical_partner_revenue} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: new_patients_ttm {
    type: number
    sql: ${TABLE}."new_patients_ttm" ;;
    value_format:  "#,##0"
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

  dimension: partner_detractors {
    type: number
    sql: ${TABLE}."partner_detractors" ;;
    value_format: "#,##0"
  }

  measure: sum_partner_detractors {
    description: "Sum of partner detractors"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${partner_detractors} ;;
    value_format: "#,##0"
  }

  dimension: partner_promoters {
    type: number
    sql: ${TABLE}."partner_promoters" ;;
  }

  measure: sum_partner_promoters {
    description: "Sum of partner promoters"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${partner_promoters} ;;
    value_format: "#,##0"
  }

  dimension: partner_survey_respondents {
    type: number
    sql: ${TABLE}."partner_survey_respondents" ;;
  }

  measure: sum_partner_survey_respondents {
    description: "Sum of partner survey respondents"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${partner_survey_respondents} ;;
    value_format: "#,##0"
  }

  dimension_group: report {
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
    sql: ${TABLE}."report_date" ;;
  }

  dimension: total_billable_visits {
    type: number
    sql: ${TABLE}."total_billable_visits" ;;
    value_format:  "#,##0"
  }

  measure: sum_total_billable_visits {
    description: "Sum of Finance reported patient visits"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_billable_visits} ;;
    value_format:  "#,##0"
  }

  dimension: total_care_team_expense {
    type: number
    sql: ${TABLE}."total_care_team_expense" ;;
    value_format:  "$#,##0;($#,##0)"
  }

  measure: sum_total_care_team_expense {
    description: "Sum of monthly total care team expenses"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_care_team_expense} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: total_direct_costs {
    type: number
    sql: ${TABLE}."total_direct_costs";;
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

  dimension: total_new_patients {
    type: number
    sql: ${TABLE}."total_new_patients" ;;
    value_format:  "#,##0"
  }

  measure: sum_total_new_patients {
    description: "Sum of Finance reported new patients"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${total_new_patients} ;;
    value_format:  "#,##0"
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

  dimension: gross_margin {
    description: "Total net revenue minus direct costs"
    type: number
    sql: ${total_net_revenue} - ${total_direct_costs} ;;
    value_format: "$#,##0;($#,##0)"
  }

  measure: sum_gross_margin {
    description: "Sum of total RCM costs"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${gross_margin} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: contribution_margin {
    type: number
    sql: ${TABLE}.contribution_margin ;;
    value_format: "$#,##0;($#,##0)"
  }

  measure: sum_contribution_margin {
    description: "Sum of contribution margin"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${contribution_margin} ;;
    value_format:  "$#,##0;($#,##0)"
  }

  dimension: quarter_id {
    description: "Foriegn key linked to mbo_metrics_quarterly_goals"
    type: string
    sql: ${TABLE}.quarter_id ;;
  }


  measure: count {
    type: count
    drill_fields: [id]
  }
}

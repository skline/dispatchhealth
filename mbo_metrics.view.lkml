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
  }

  dimension: collectibility {
    type: number
    sql: ${TABLE}."collectibility" ;;
  }

  dimension: count_adverse_events {
    type: number
    sql: ${TABLE}."count_adverse_events" ;;
  }

  dimension: count_near_misses {
    type: number
    sql: ${TABLE}."count_near_misses" ;;
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
  }

  dimension: ebitda {
    type: number
    sql: ${TABLE}."ebitda" ;;
  }

  dimension: gross_clinical_partner_revenue {
    type: number
    sql: ${TABLE}."gross_clinical_partner_revenue" ;;
  }

  dimension: high_trust_certification {
    type: string
    sql: ${TABLE}."high_trust_certification" ;;
  }

  dimension: indirect_marketing_costs {
    type: number
    sql: ${TABLE}."indirect_marketing_costs" ;;
  }

  dimension: indirect_marketing_costs_ttm {
    type: number
    sql: ${TABLE}."indirect_marketing_costs_ttm" ;;
  }

  dimension: managed_care_penetration {
    type: number
    sql: ${TABLE}."managed_care_penetration" ;;
  }

  dimension: maximum_customer_concentration {
    type: number
    sql: ${TABLE}."maximum_customer_concentration" ;;
  }

  dimension: net_advanced_care_revenue {
    type: number
    sql: ${TABLE}."net_advanced_care_revenue" ;;
  }

  dimension: net_extended_care_revenue {
    type: number
    sql: ${TABLE}."net_extended_care_revenue" ;;
  }

  dimension: new_gross_clinical_partner_revenue {
    type: number
    sql: ${TABLE}."new_gross_clinical_partner_revenue" ;;
  }

  dimension: new_patients_ttm {
    type: number
    sql: ${TABLE}."new_patients_ttm" ;;
  }

  dimension: novel_unbudgeted_revenue {
    type: number
    sql: ${TABLE}."novel_unbudgeted_revenue" ;;
  }

  dimension: partner_detractors {
    type: number
    sql: ${TABLE}."partner_detractors" ;;
  }

  dimension: partner_promoters {
    type: number
    sql: ${TABLE}."partner_promoters" ;;
  }

  dimension: partner_survey_respondents {
    type: number
    sql: ${TABLE}."partner_survey_respondents" ;;
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
  }

  dimension: total_care_team_expense {
    type: number
    sql: ${TABLE}."total_care_team_expense" ;;
  }

  dimension: total_direct_costs {
    type: number
    sql: ${TABLE}."total_direct_costs" ;;
  }

  dimension: total_net_revenue {
    type: number
    sql: ${TABLE}."total_net_revenue" ;;
  }

  dimension: total_new_patients {
    type: number
    sql: ${TABLE}."total_new_patients" ;;
  }

  dimension: total_rcm_costs {
    type: number
    sql: ${TABLE}."total_rcm_costs" ;;
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

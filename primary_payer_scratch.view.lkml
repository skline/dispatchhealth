view: primary_payer_scratch {
  sql_table_name: looker_scratch.primary_payer_scratch ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
  }

  dimension: dashboard_patient_id {
    type: number
    sql: ${TABLE}.dashboard_patient_id ;;
  }

  dimension: insurance_package_id {
    type: string
    sql: ${TABLE}.insurance_package_id ;;
  }

  dimension: insurance_package_name {
    type: string
    sql: ${TABLE}.insurance_package_name ;;
  }

  dimension: insurance_package_type {
    type: string
    sql: ${TABLE}.insurance_package_type ;;
  }

  dimension: insurance_reporting_category {
    type: string
    sql: ${TABLE}.insurance_reporting_category ;;
  }

  dimension: irc_group {
    type: string
    sql: ${TABLE}.irc_group ;;
  }

  measure: count {
    type: count
    drill_fields: [id, insurance_package_name]
  }
}

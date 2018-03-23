view: primary_payer_packages {
  sql_table_name: looker_scratch.primary_payer_packages ;;

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
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

  dimension: primary_payer_dim_id {
    type: number
    sql: ${TABLE}.primary_payer_dim_id ;;
  }

  measure: count {
    type: count
    drill_fields: [insurance_package_name]
  }
}

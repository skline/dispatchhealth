view: department {
  sql_table_name: athena.department ;;
  drill_fields: [department_id]

  dimension: department_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."department_id" ;;
  }

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: billing_name {
    type: string
    sql: ${TABLE}."billing_name" ;;
  }

  dimension: campus_location {
    type: string
    sql: ${TABLE}."campus_location" ;;
  }

  dimension: chart_sharing_group_id {
    type: number
    sql: ${TABLE}."chart_sharing_group_id" ;;
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

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: department_address {
    type: string
    sql: ${TABLE}."department_address" ;;
  }

  dimension: department_address_2 {
    type: string
    sql: ${TABLE}."department_address_2" ;;
  }

  dimension: department_city {
    type: string
    sql: ${TABLE}."department_city" ;;
  }

  dimension: department_fax {
    type: string
    sql: ${TABLE}."department_fax" ;;
  }

  dimension: department_group {
    type: string
    sql: ${TABLE}."department_group" ;;
  }

  dimension: department_medical_provider_id {
    type: string
    sql: ${TABLE}."department_medical_provider_id" ;;
  }

  dimension: department_name {
    type: string
    sql: ${TABLE}."department_name" ;;
  }

  dimension: department_phone {
    type: string
    sql: ${TABLE}."department_phone" ;;
  }

  dimension: department_specialty {
    type: string
    sql: ${TABLE}."department_specialty" ;;
  }

  dimension: department_state {
    type: string
    sql: ${TABLE}."department_state" ;;
  }

  dimension: department_zip {
    type: string
    sql: ${TABLE}."department_zip" ;;
  }

  dimension: gpci_location_id {
    type: number
    sql: ${TABLE}."gpci_location_id" ;;
  }

  dimension: gpci_location_name {
    type: string
    sql: ${TABLE}."gpci_location_name" ;;
  }

  dimension: place_of_service_code {
    type: string
    sql: ${TABLE}."place_of_service_code" ;;
  }

  dimension: place_of_service_type {
    type: string
    sql: ${TABLE}."place_of_service_type" ;;
  }

  dimension: provider_group_id {
    type: number
    sql: ${TABLE}."provider_group_id" ;;
  }

  dimension: specialty_code {
    type: string
    sql: ${TABLE}."specialty_code" ;;
  }

  dimension: type_of_bill {
    type: string
    sql: ${TABLE}."type_of_bill" ;;
  }

  dimension: type_of_bill_code {
    type: string
    sql: ${TABLE}."type_of_bill_code" ;;
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
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      department_id,
      department_name,
      billing_name,
      gpci_location_name,
      document_letters.count,
      document_orders.count,
      document_others.count,
      document_prescriptions.count,
      document_results.count
    ]
  }
}

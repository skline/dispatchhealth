view: athena_department {
  sql_table_name: athena.department ;;
  drill_fields: [department_id]
  view_label: "Athena Department"

  dimension: department_id {
    primary_key: yes
    type: number
    group_label: "IDs"
    sql: ${TABLE}."department_id" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: billing_name {
    type: string
    hidden: yes
    sql: ${TABLE}."billing_name" ;;
  }

  dimension: campus_location {
    type: string
    hidden: yes
    sql: ${TABLE}."campus_location" ;;
  }

  dimension: chart_sharing_group_id {
    type: number
    hidden: yes
    sql: ${TABLE}."chart_sharing_group_id" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
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
    group_label: "User Actions"
    sql: ${TABLE}."created_by" ;;
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted {
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
    group_label: "Contact Information"
    sql: ${TABLE}."department_address" ;;
  }

  dimension: department_address_2 {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_address_2" ;;
  }

  dimension: department_city {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_city" ;;
  }

  dimension: department_fax {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_fax" ;;
  }

  dimension: department_group {
    type: string
    group_label: "Contact Information"
    hidden: no
    sql: ${TABLE}."department_group" ;;
  }

  dimension: department_medical_provider_id {
    type: string
    hidden: yes
    sql: ${TABLE}."department_medical_provider_id" ;;
  }

  dimension: department_name {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_name" ;;
  }

  dimension: department_phone {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_phone" ;;
  }

  dimension: department_specialty {
    type: string
    hidden: yes
    sql: ${TABLE}."department_specialty" ;;
  }

  dimension: department_state {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_state" ;;
  }

  dimension: department_zip {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."department_zip" ;;
  }

  dimension: gpci_location_id {
    type: number
    group_label: "Contact Information"
    sql: ${TABLE}."gpci_location_id" ;;
  }

  dimension: gpci_location_name {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."gpci_location_name" ;;
  }

  dimension: place_of_service_code {
    type: string
    hidden: yes
    sql: ${TABLE}."place_of_service_code" ;;
  }

  dimension: place_of_service_type {
    type: string
    description: "HOME, ASSISTED LIVING, etc."
    sql: ${TABLE}."place_of_service_type" ;;
  }

  dimension: provider_group_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."provider_group_id" ;;
  }

  dimension: specialty_code {
    type: string
    hidden: yes
    sql: ${TABLE}."specialty_code" ;;
  }

  dimension: type_of_bill {
    type: string
    hidden: yes
    sql: ${TABLE}."type_of_bill" ;;
  }

  dimension: type_of_bill_code {
    type: string
    hidden: yes
    sql: ${TABLE}."type_of_bill_code" ;;
  }

  dimension_group: updated_at {
    type: time
    hidden: yes
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

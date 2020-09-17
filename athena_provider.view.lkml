view: athena_provider {
  sql_table_name: athena.provider ;;
  drill_fields: [supervising_provider_id]
  # view_label: "Athena Provider"


  dimension: supervising_provider_id {
    primary_key: no
    type: number
    sql: ${TABLE}."supervising_provider_id" ;;
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

  dimension: billable_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."billable_yn" ;;
  }

  dimension: billed_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."billed_name" ;;
  }

  dimension: communicator_home_dept_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."communicator_home_dept_id" ;;
  }

  dimension: create_encounter_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."create_encounter_yn" ;;
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
    hidden: no
    group_label: "Record Audit"
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created_datetime {
    type: time
    group_label: "Record Audit"
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
    group_label: "Record Audit"
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted_datetime {
    type: time
    group_label: "Record Audit"
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

  dimension: direct_address {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."direct_address" ;;
  }

  dimension: entity_type {
    type: string
    hidden: yes
    sql: ${TABLE}."entity_type" ;;
  }

  dimension: hide_in_portal_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."hide_in_portal_yn" ;;
  }

  dimension: patient_facing_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."patient_facing_name" ;;
  }

  dimension: provider_first_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}.provider_first_name ;;
  }

  dimension: provider_group_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."provider_group_id" ;;
  }

  dimension: provider_id {
    type: number
    primary_key: yes
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."provider_id" ;;
  }

  dimension: provider_last_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_last_name" ;;
  }

  dimension: provider_last_first_name {
    type: string
    group_label: "Provider Details"
    sql: CONCAT(INITCAP(${provider_last_name}), ', ', INITCAP(${provider_first_name})) ;;
  }

  dimension: provider_medical_group_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."provider_medical_group_id" ;;
  }

  dimension: provider_middle_initial {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_middle_initial" ;;
  }

  dimension: provider_ndc_tat_number {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_ndc_tat_number" ;;
  }

  dimension: provider_npi_number {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_npi_number" ;;
  }

  dimension: provider_type {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_type" ;;
  }

  dimension: provider_type_category {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_type_category" ;;
  }

  dimension: provider_type_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_type_name" ;;
  }

  dimension: provider_user_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."provider_user_name" ;;
  }

  dimension: referring_provider_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."referring_provider_yn" ;;
  }

  dimension: reporting_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."reporting_name" ;;
  }

  dimension: schedule_resource_type {
    type: string
    hidden: yes
    sql: ${TABLE}."schedule_resource_type" ;;
  }

  dimension: scheduling_name {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."scheduling_name" ;;
  }

  dimension: signature_on_file_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."signature_on_file_yn" ;;
  }

  dimension: specialty {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."specialty" ;;
  }

  dimension: specialty_code {
    type: string
    hidden: yes
    sql: ${TABLE}."specialty_code" ;;
  }

  dimension: staff_bucket_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."staff_bucket_yn" ;;
  }

  dimension: taxonomy {
    type: string
    group_label: "Provider Details"
    sql: ${TABLE}."taxonomy" ;;
  }

  dimension: taxonomy_ansi_code {
    type: string
    hidden: yes
    sql: ${TABLE}."taxonomy_ansi_code" ;;
  }

  dimension: track_missing_slips_yn {
    type: string
    group_label: "Provider Flags"
    sql: ${TABLE}."track_missing_slips_yn" ;;
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

  # ----- Sets of fields for drilling ------
  # set: detail {
  #   fields: [
  #     provider.scheduling_name,
  #     provider.reporting_name,
  #     provider.billed_name,
  #     provider.provider_first_name,
  #     provider.provider_last_name,
  #     provider.provider_user_name,
  #     provider.provider_type_name,
  #     provider.supervising_provider_id,
  #     provider.patient_facing_name,
  #     provider.count,
  #     providernumber.count
  #   ]
  # }
}

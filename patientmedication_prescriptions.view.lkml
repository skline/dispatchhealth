view: patientmedication_prescriptions {
  sql_table_name: athena.patientmedication_prescriptions ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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

  dimension_group: administered_expiration {
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
    sql: ${TABLE}."administered_expiration_date" ;;
  }

  dimension: administered_yn {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."administered_yn" ;;
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
    group_label: "User Actions"
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

  dimension: deactivation_reason {
    type: string
    sql: ${TABLE}."deactivation_reason" ;;
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

  dimension: dispensed_yn {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."dispensed_yn" ;;
  }

  dimension: display_dosage_units {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."display_dosage_units" ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}."document_id" ;;
  }

  dimension: dosage_action {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_action" ;;
  }

  dimension: dosage_form {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_form" ;;
  }

  dimension: dosage_quantity {
    type: number
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_quantity" ;;
  }

  dimension: dosage_route {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_route" ;;
  }

  dimension: frequency {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."frequency" ;;
  }

  dimension_group: med_administered_datetime {
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
    sql: ${TABLE}."med_administered_datetime" ;;
  }

  dimension: medication_type {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."medication_type" ;;
  }

  dimension: patient_medication_id {
    type: number
    sql: ${TABLE}."patient_medication_id" ;;
  }

  dimension: prescribed_yn {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."prescribed_yn" ;;
  }

  dimension: prescription_fill_quantity {
    type: number
    group_label: "Prescription Details"
    sql: ${TABLE}."prescription_fill_quantity" ;;
  }

  dimension: sig {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."sig" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."start_date" ;;
  }

  dimension_group: stop {
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
    sql: ${TABLE}."stop_date" ;;
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

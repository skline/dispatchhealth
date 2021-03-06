view: athena_patient_current_medications {
  sql_table_name: athena.patientmedication_medicationlisting ;;
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

  dimension: compound_primary_key {
#     primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.patient_id::varchar, ' ', ${TABLE}.medication_id::varchar) ;;
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

  dimension: chart_id {
    type: number
    sql: ${TABLE}."chart_id" ;;
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

  dimension: deactivated_by {
    type: string
    sql: ${TABLE}."deactivated_by" ;;
  }

  dimension_group: deactivation_datetime {
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
    sql: ${TABLE}."deactivation_datetime" ;;
  }

  dimension: deactivation_reason {
    type: string
    sql: ${TABLE}."deactivation_reason" ;;
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

  dimension: display_dosage_units {
    type: string
    sql: ${TABLE}."display_dosage_units" ;;
  }

  dimension: dosage_action {
    type: string
    sql: ${TABLE}."dosage_action" ;;
  }

  dimension: dosage_form {
    type: string
    sql: ${TABLE}."dosage_form" ;;
  }

  dimension: dosage_quantity {
    type: number
    sql: ${TABLE}."dosage_quantity" ;;
  }

  dimension: dosage_route {
    type: string
    sql: ${TABLE}."dosage_route" ;;
  }

  dimension_group: fill {
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
    sql: ${TABLE}."fill_date" ;;
  }

  dimension: frequency {
    type: string
    sql: ${TABLE}."frequency" ;;
  }

  dimension: length_of_course {
    type: number
    sql: ${TABLE}."length_of_course" ;;
  }

  dimension: medication_id {
    type: number
    sql: ${TABLE}."medication_id" ;;
  }

  dimension: medication_name {
    type: string
    sql: ${TABLE}."medication_name" ;;
  }

  dimension: medication_type {
    type: string
    sql: ${TABLE}."medication_type" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_medication_id {
    type: number
    sql: ${TABLE}."patient_medication_id" ;;
  }

  dimension: pharmacy_name {
    type: string
    sql: ${TABLE}."pharmacy_name" ;;
  }

  dimension: prescriber {
    type: string
    sql: ${TABLE}."prescriber" ;;
  }

  dimension: prescription_fill_quantity {
    type: number
    sql: ${TABLE}."prescription_fill_quantity" ;;
  }

  dimension: source_code {
    type: string
    sql: ${TABLE}."source_code" ;;
  }

  dimension: source_code_type {
    type: string
    sql: ${TABLE}."source_code_type" ;;
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
    drill_fields: [id, medication_name, pharmacy_name]
  }

  measure: count_medications {
    type: count_distinct
    sql: ${compound_primary_key} ;;
    filters: {
      field: deactivation_datetime_date
      value: "NULL"
    }
  }

}

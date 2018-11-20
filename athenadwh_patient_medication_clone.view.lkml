view: athenadwh_patient_medication_clone {
  sql_table_name: looker_scratch.athenadwh_patient_medication_clone ;;

  dimension: administered_yn {
    type: string
    sql: ${TABLE}.administered_yn ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: deactivated_by {
    type: string
    sql: ${TABLE}.deactivated_by ;;
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
    sql: ${TABLE}.deactivation_datetime ;;
  }

  dimension: dispensed_yn {
    type: string
    sql: ${TABLE}.dispensed_yn ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: dosage_action {
    type: string
    sql: ${TABLE}.dosage_action ;;
  }

  dimension: dosage_form {
    type: string
    sql: ${TABLE}.dosage_form ;;
  }

  dimension: dosage_quantity {
    type: number
    sql: ${TABLE}.dosage_quantity ;;
  }

  dimension: dosage_route {
    type: string
    sql: ${TABLE}.dosage_route ;;
  }

  dimension: dosage_strength {
    type: string
    sql: ${TABLE}.dosage_strength ;;
  }

  dimension: dosage_strength_units {
    type: string
    sql: ${TABLE}.dosage_strength_units ;;
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
    sql: ${TABLE}.fill_date ;;
  }

  dimension: frequency {
    type: string
    sql: ${TABLE}.frequency ;;
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
    sql: ${TABLE}.med_administered_datetime ;;
  }

  dimension: medication_id {
    type: number
    sql: ${TABLE}.medication_id ;;
  }

  dimension: medication_name {
    type: string
    sql: ${TABLE}.medication_name ;;
  }

  measure: medications_list {
    label: "List of all medications"
    type: string
    sql: string_agg(DISTINCT ${medication_name}, ' | ') ;;
  }

  dimension: medication_type {
    type: string
    sql: ${TABLE}.medication_type ;;
  }

  dimension: number_of_refills_prescribed {
    type: number
    sql: ${TABLE}.number_of_refills_prescribed ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_medication_id {
    type: number
    sql: ${TABLE}.patient_medication_id ;;
  }

  dimension: pharmacy_name {
    type: string
    sql: ${TABLE}.pharmacy_name ;;
  }

  dimension: prescribed_yn {
    type: string
    sql: ${TABLE}.prescribed_yn ;;
  }

  dimension: prescription_fill_quantity {
    type: number
    sql: ${TABLE}.prescription_fill_quantity ;;
  }

  dimension: sig {
    type: string
    sql: ${TABLE}.sig ;;
  }

  measure: count {
    type: count
    drill_fields: [medication_name, pharmacy_name]
  }
}
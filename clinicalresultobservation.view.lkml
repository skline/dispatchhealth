view: clinicalresultobservation {
  sql_table_name: athena.clinicalresultobservation ;;

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension: __file_date {
    type: string
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: clinical_observation_id {
    type: number
    sql: ${TABLE}."clinical_observation_id" ;;
  }

  dimension: clinical_result_id {
    type: number
    sql: ${TABLE}."clinical_result_id" ;;
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

  dimension: loinc_id {
    type: number
    sql: ${TABLE}."loinc_id" ;;
  }

  dimension: observation_abnormal_flag_id {
    type: string
    sql: ${TABLE}."observation_abnormal_flag_id" ;;
  }

  dimension: observation_identifier {
    type: string
    sql: ${TABLE}."observation_identifier" ;;
  }

  dimension: observation_identifier_text {
    type: string
    sql: ${TABLE}."observation_identifier_text" ;;
  }

  dimension: observation_units {
    type: string
    sql: ${TABLE}."observation_units" ;;
  }

  dimension: observation_value_type {
    type: string
    sql: ${TABLE}."observation_value_type" ;;
  }

  dimension: performing_lab_key {
    type: string
    sql: ${TABLE}."performing_lab_key" ;;
  }

  dimension: reference_range {
    type: string
    sql: ${TABLE}."reference_range" ;;
  }

  dimension: result {
    type: string
    sql: ${TABLE}."result" ;;
  }

  dimension: template_analyte_name {
    type: string
    sql: ${TABLE}."template_analyte_name" ;;
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
    drill_fields: [template_analyte_name]
  }
}

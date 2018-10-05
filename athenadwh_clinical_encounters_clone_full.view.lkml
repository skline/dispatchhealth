view: athenadwh_clinical_encounters_clone_full {
  sql_table_name: looker_scratch.athenadwh_clinical_encounters_clone_full ;;

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: closed_by {
    type: string
    sql: ${TABLE}.closed_by ;;
  }

  dimension: closed_by_supervisor {
    type: yesno
    sql: ${closed_by} IS NOT NULL AND ${closed_by} = ${athenadwh_supervising_provider_clone.provider_user_name} ;;
  }

  dimension_group: closed_datetime {
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
    sql: ${TABLE}.closed_datetime ;;
  }

  measure: last_closed_datetime {
    type: date
    sql: MAX(${closed_datetime_raw}) ;;
    convert_tz: no
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

  dimension_group: encounter {
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
    sql: ${TABLE}.encounter_date ;;
  }

  dimension: encounter_status {
    type: string
    sql: ${TABLE}.encounter_status ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

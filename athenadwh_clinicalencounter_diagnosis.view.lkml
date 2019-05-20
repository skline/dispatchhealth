view: athenadwh_clinicalencounter_diagnosis {
  view_label: "Clinical Encounter Diagnoses"
  sql_table_name: looker_scratch.athenadwh_clinicalencounter_diagnosis ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_dx_id {
    type: number
    sql: ${TABLE}.clinical_encounter_dx_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
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
    sql: ${TABLE}.created_at ;;
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
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: ordering {
    type: number
    hidden: yes
    sql: ${TABLE}.ordering ;;
  }

  measure: more_than_one_diagnosis {
    type: yesno
    description: "A flag indicating that more than one ICD diagnosis code exists"
    sql: MAX(${ordering}) > 0 ;;
  }

  dimension: sequence_number {
    type: number
    description: "The priority number of the diagnosis code"
    hidden: no
    sql: ${ordering} + 1 ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

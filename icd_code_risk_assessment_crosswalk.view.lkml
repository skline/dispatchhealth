view: icd_code_risk_assessment_crosswalk {
  sql_table_name: looker_scratch.icd_code_risk_assessment_crosswalk ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}."diagnosis_code" ;;
  }

  dimension: match_type {
    type: string
    sql: ${TABLE}."match_type" ;;
  }

  dimension: relibable_match {
    type: yesno
    sql: ${match_type} = '1 - Reliable' ;;
  }

  dimension: neutral_match {
    type: yesno
    sql: ${match_type} = '2 - Neutral' ;;
  }

  dimension: Mismatch_match {
    type: yesno
    sql: ${match_type} = '3 - Mismatch' ;;
  }

  dimension: risk_assessments_protocol_name {
    type: string
    sql: ${TABLE}."risk_assessments_protocol_name" ;;
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
    drill_fields: [id, risk_assessments_protocol_name]
  }

}

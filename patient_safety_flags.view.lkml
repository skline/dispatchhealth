view: patient_safety_flags {
  sql_table_name: public.patient_safety_flags ;;
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

  dimension: flag_reason {
    type: string
    sql: ${TABLE}."flag_reason" ;;
  }

  dimension: flag_type {
    type: string
    sql: ${TABLE}."flag_type" ;;
  }

  dimension: flagger_id {
    type: number
    sql: ${TABLE}."flagger_id" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
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

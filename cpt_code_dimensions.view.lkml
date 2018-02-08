view: cpt_code_dimensions {
  sql_table_name: jasperdb.cpt_code_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: code_suffix {
    type: string
    sql: ${TABLE}.code_suffix ;;
  }

  dimension: cpt_code {
    type: string
    sql: ${TABLE}.cpt_code ;;
  }

  dimension: cpt_edition {
    type: string
    sql: ${TABLE}.cpt_edition ;;
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

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: e_and_m_code {
    type: yesno
    sql: ${TABLE}.e_and_m_code ;;
  }

  dimension: em_care_level {
    type: string
    sql: ${TABLE}.em_care_level ;;
  }

  dimension: em_patient_type {
    type: string
    sql: ${TABLE}.em_patient_type ;;
  }

  dimension: facility_type {
    type: string
    sql: ${TABLE}.facility_type ;;
  }

  dimension: modifiers {
    type: string
    sql: ${TABLE}.modifiers ;;
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

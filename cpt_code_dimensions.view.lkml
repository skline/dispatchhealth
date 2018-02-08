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
    label: "CPT code"
    type: string
    sql: ${TABLE}.cpt_code ;;
  }

  dimension: cpt_edition {
    label: "CPT edition"
    type: string
    sql: ${TABLE}.cpt_edition ;;
  }

  dimension_group: created {
    hidden: yes
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
    label: "E&M CPT code flag"
    type: yesno
    sql: ${TABLE}.e_and_m_code ;;
  }

  dimension: em_care_level {
    label: "E&M Code Care Level"
    type: string
    sql: ${TABLE}.em_care_level ;;
  }

  dimension: em_patient_type {
    label: "E&M Code Patient Type"
    type: string
    sql: ${TABLE}.em_patient_type ;;
  }

  dimension: facility_type {
    type: string
    sql: ${TABLE}.facility_type ;;
  }

  dimension: modifiers {
    label: "CPT code modifiers"
    type: string
    sql: ${TABLE}.modifiers ;;
  }

  dimension_group: updated {
    hidden: yes
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

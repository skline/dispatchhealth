view: power_of_attorneys {
  sql_table_name: public.power_of_attorneys ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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


  dimension: patient_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.patient_id ;;
  }

  dimension: name {
    type: string
    description: "Name of person designated as power of attorney"
    sql: ${TABLE}.name ;;
  }

  dimension: patient_has_poa {
    type: yesno
    description: "A flag indicating that the patient has a power of attorney"
    sql: ${patient_id} IS NOT NULL ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: realtionship {
    type: string
    description: "Power of attorney relationship to patient"
    sql: ${TABLE}.relationship ;;
  }


  dimension_group: updated {
    type: time
    hidden: yes
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
    drill_fields: [detail*]
  }

  measure: count_distinct_patients {
    type: count_distinct
    sql: ${patient_id} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      patients.ehr_name
    ]
  }
}

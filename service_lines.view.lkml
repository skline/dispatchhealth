view: service_lines {
  sql_table_name: public.service_lines ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: existing_pt_appointment_type {
    type: string
    sql: ${TABLE}.existing_patient_appointment_type ->> 'name';;
  }

  dimension: followup_14_30_day {
    type: yesno
    sql: ${TABLE}.followup_14_30_day ;;
  }

  dimension: followup_3_day {
    type: yesno
    sql: ${TABLE}.followup_3_day ;;
  }

  dimension: is_911 {
    type: yesno
    sql: ${TABLE}.is_911 ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: new_pt_appointment_type {
    type: string
    sql: ${TABLE}.new_patient_appointment_type ->> 'name';;
  }

  dimension: out_of_network_insurance {
    type: yesno
    sql: ${TABLE}.out_of_network_insurance ;;
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
    drill_fields: [id, name]
  }
}

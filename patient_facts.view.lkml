view: patient_facts {
  sql_table_name: jasperdb.patient_facts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: athena_patient_id {
    label: "Athena Patient ID"
    type: string
    sql: ${TABLE}.athena_patient_id ;;
  }

  dimension: chrono_patient_id {
    label: "DrChrono Patient ID"
    type: string
    sql: ${TABLE}.chrono_patient_id ;;
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

  dimension: dashboard_account_id {
    hidden: yes
    type: number
    sql: ${TABLE}.dashboard_account_id ;;
  }

  dimension: dashboard_patient_id {
    hidden: yes
    type: number
    sql: ${TABLE}.dashboard_patient_id ;;
  }

  dimension: dashboard_user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.dashboard_user_id ;;
  }

  dimension: dob {
    label: "Date of Birth"
    type: string
    sql: ${TABLE}.dob ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: patient_is_user_flag {
    type: yesno
    sql: ${TABLE}.patient_is_user_flag ;;
  }

  dimension: pcp_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.pcp_dim_id ;;
  }

  dimension: ssn {
    type: string
    sql: ${TABLE}.ssn ;;
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
    drill_fields: [id, first_name, last_name]
  }
}

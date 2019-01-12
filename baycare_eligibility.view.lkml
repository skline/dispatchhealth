view: baycare_eligibility {
  sql_table_name: looker_scratch.baycare_eligibility ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}.address1 ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}.address2 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: insurance_number {
    type: string
    sql: ${TABLE}.insurance_number ;;
  }

  dimension: insurer {
    type: string
    sql: ${TABLE}.insurer ;;
  }

  dimension: match {
    type: string
    sql: ${TABLE}.match ;;
  }

  dimension: mi {
    type: string
    sql: ${TABLE}.mi ;;
  }

  dimension_group: patient_dob {
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
    sql: ${TABLE}.patient_dob ;;
  }

  dimension: patient_first_name {
    type: string
    sql: ${TABLE}.patient_first_name ;;
  }

  dimension: patient_id {
    type: string
    sql: ${TABLE}.patient_id ;;
  }

  dimension: baycare_eligible {
    type: yesno
    sql: ${patient_id} IS NOT NULL ;;
  }

  dimension: patient_last_name {
    type: string
    sql: ${TABLE}.patient_last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, patient_first_name, patient_last_name]
  }
}

view: patients {
  sql_table_name: public.patients ;;

  dimension: chrono_patient_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.chrono_patient_id ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: dob {
    type: date
    sql: ${TABLE}.dob ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: female {
   type: yesno
   sql: ${gender} = 'Female' ;;
  }


  measure: distinct_females {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: female
      value: "yes"
    }

  }


  measure: percent_female {
    type: number
    value_format: "0%"
    sql: ${distinct_females}::float/${count_distinct}::float ;;

  }

  dimension: age {
    type: number
    sql: CAST(EXTRACT(YEAR from AGE(${care_request_requested.created_date}, ${dob})) AS INT) ;;
  }

  measure: average_age {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql:  ${age} ;;

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

  dimension_group: created_mountain {
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
    sql: ${TABLE}.created_at - interval '7 hour' ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }




  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: is_user {
    type: yesno
    sql: ${TABLE}.is_user ;;
  }



  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }


  dimension: patient_salesforce_id {
    type: string
    sql: ${TABLE}.patient_salesforce_id ;;
  }

  dimension: pcp_name {
    type: string
    sql: ${TABLE}.pcp_name ;;
  }


  dimension_group: pulled {
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
    sql: ${TABLE}.pulled_at ;;
  }

  dimension_group: pushed {
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
    sql: ${TABLE}.pushed_at ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: ${id} ;;
    sql: ${id};;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      chrono_patient_id,
      ehr_name,
      power_of_attorneys.count
    ]
  }
}

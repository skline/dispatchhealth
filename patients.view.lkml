include: "patients_user.view.lkml"

view: patients {
  extends: [patients_user]

  dimension: chrono_patient_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.chrono_patient_id ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
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

  dimension: pediatric_patient {
    description: "A flag indicating patients age < 13"
    type: yesno
    sql: ${age} < 13 AND NOT ${bad_age_filter} ;;
  }

  dimension: age_band_wide {
    type: string
    description: "Age bands, grouped into wider buckets"
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 24 THEN 'age_0_to_24'
          WHEN ${age} >= 25 AND ${age} <= 39 THEN 'age_25_to_39'
          WHEN ${age} >= 40 AND ${age} <= 54 THEN 'age_40_to_54'
          WHEN ${age} >= 55 AND ${age} <= 64 THEN 'age_55_to_64'
          WHEN ${age} >= 65 AND ${age} <= 74 THEN 'age_65_to_74'
          WHEN ${age} >= 75 AND ${age} <= 84 THEN 'age_75_to_84'
          WHEN ${age} >= 85 AND ${age} <= 94 THEN 'age_85_to_94'
          WHEN ${age} >= 95 AND ${age} <= 110 THEN 'age_95_plus'
          ELSE NULL
         END ;;
  }


  measure: median_age {
    type: median_distinct
    sql_distinct_key: ${care_requests.id} ;;
    value_format: "0.0"
    sql:  ${age} ;;
    filters: {
      field: bad_age_filter
      value: "no"
    }

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
    sql: ${TABLE}.created_at  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain'  ;;
  }

  dimension_group: created_local {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at  AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz}  ;;
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

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      chrono_patient_id,
      ehr_name,
      power_of_attorneys.count
    ]
  }
}

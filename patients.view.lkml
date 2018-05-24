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

  dimension: bad_age_filter {
    type: yesno
    hidden: yes
    sql: ${age} >= 110 ;;
  }

  dimension: age_band_sort {
    type: string
    hidden: yes
    alpha_sort: yes
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 5 THEN 'a'
          WHEN ${age} >= 6 AND ${age} <= 9 THEN 'b'
          WHEN ${age} >= 10 AND ${age} <= 19 THEN 'c'
          WHEN ${age} >= 20 AND ${age} <= 29 THEN 'd'
          WHEN ${age} >= 30 AND ${age} <= 39 THEN 'e'
          WHEN ${age} >= 40 AND ${age} <= 49 THEN 'f'
          WHEN ${age} >= 50 AND ${age} <= 59 THEN 'g'
          WHEN ${age} >= 60 AND ${age} <= 69 THEN 'h'
          WHEN ${age} >= 70 AND ${age} <= 79 THEN 'i'
          WHEN ${age} >= 80 AND ${age} <= 89 THEN 'j'
          WHEN ${age} >= 90 AND ${age} <= 110 THEN 'k'
          ELSE 'z'
         END ;;
  }

  dimension: age_band {
    type: string
    order_by_field: age_band_sort
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 5 THEN 'age_0_to_5'
          WHEN ${age} >= 6 AND ${age} <= 9 THEN 'age_6_to_9'
          WHEN ${age} >= 10 AND ${age} <= 19 THEN 'age_10_to_19'
          WHEN ${age} >= 20 AND ${age} <= 29 THEN 'age_20_to_29'
          WHEN ${age} >= 30 AND ${age} <= 39 THEN 'age_30_to_39'
          WHEN ${age} >= 40 AND ${age} <= 49 THEN 'age_40_to_49'
          WHEN ${age} >= 50 AND ${age} <= 59 THEN 'age_50_to_59'
          WHEN ${age} >= 60 AND ${age} <= 69 THEN 'age_60_to_69'
          WHEN ${age} >= 70 AND ${age} <= 79 THEN 'age_70_to_79'
          WHEN ${age} >= 80 AND ${age} <= 89 THEN 'age_80_to_89'
          WHEN ${age} >= 90 AND ${age} <= 110 THEN 'age_90_plus'
          ELSE NULL
         END ;;
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
    type: median
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

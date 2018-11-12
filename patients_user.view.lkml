view: patients_user {
  sql_table_name: public.patients ;;

  dimension: id {
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: gender {
    type: string
    sql: CASE
          WHEN ${TABLE}.gender = 'f' THEN 'Female'
          WHEN ${TABLE}.gender = 'm' THEN 'Male'
          ELSE ${TABLE}.gender
        END ;;
  }

  dimension: dob {
    type: date
    sql: ${TABLE}.dob ;;
  }

  dimension: age {
    type: number
    sql: CAST(EXTRACT(YEAR from AGE(${care_request_flat_user.created_date}, ${dob})) AS INT) ;;
  }

  dimension: bad_age_filter {
    type: yesno
    hidden: yes
    sql: ${age} >= 110 or ${age}<0;;
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

  measure: average_age {
    type: average_distinct
    sql_distinct_key: ${care_requests_user.id} ;;
    value_format: "0.0"
    sql: ${age} ;;
    filters: {
      field: bad_age_filter
      value: "no"
    }
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: ${id} ;;
    sql: ${id};;
  }

}

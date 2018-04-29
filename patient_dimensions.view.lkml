view: patient_dimensions {
  sql_table_name: jasperdb.patient_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }
  measure: average_age {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: ${visit_facts.care_request_id} ;;
    sql: ${age} ;;
  }

  dimension: age_0_to_5 {
    type: yesno
    sql: ${TABLE}.age_0_to_5 ;;
  }

  dimension: age_10_to_19 {
    type: yesno
    sql: ${TABLE}.age_10_to_19 ;;
  }

  dimension: age_20_to_29 {
    type: yesno
    sql: ${TABLE}.age_20_to_29 ;;
  }

  dimension: age_30_to_39 {
    type: yesno
    sql: ${TABLE}.age_30_to_39 ;;
  }

  dimension: age_40_to_49 {
    type: yesno
    sql: ${TABLE}.age_40_to_49 ;;
  }

  dimension: age_50_to_59 {
    type: yesno
    sql: ${TABLE}.age_50_to_59 ;;
  }

  dimension: age_60_to_69 {
    type: yesno
    sql: ${TABLE}.age_60_to_69 ;;
  }

  dimension: age_6_to_9 {
    type: yesno
    sql: ${TABLE}.age_6_to_9 ;;
  }

  dimension: age_70_to_79 {
    type: yesno
    sql: ${TABLE}.age_70_to_79 ;;
  }

  dimension: age_80_to_89 {
    type: yesno
    sql: ${TABLE}.age_80_to_89 ;;
  }

  dimension: age_90_plus {
    type: yesno
    sql: ${TABLE}.age_90_plus ;;
  }

  dimension: age_band_sort {
    type: number
    label: "Age Band Sorting Value"
    hidden: yes
    sql: CASE
          WHEN ${age_band} = 'age_0_to_5' THEN 1
          WHEN ${age_band} = 'age_6_to_9' THEN 2
          WHEN ${age_band} = 'age_10_to_19' THEN 3
          WHEN ${age_band} = 'age_20_to_29' THEN 4
          WHEN ${age_band} = 'age_30_to_39' THEN 5
          WHEN ${age_band} = 'age_40_to_49' THEN 6
          WHEN ${age_band} = 'age_50_to_59' THEN 7
          WHEN ${age_band} = 'age_60_to_69' THEN 8
          WHEN ${age_band} = 'age_70_to_79' THEN 9
          WHEN ${age_band} = 'age_80_to_89' THEN 10
          WHEN ${age_band} = 'age_90_plus' THEN 11
          ELSE 12
        END
          ;;
  }

  dimension: age_band {
    type: string
    order_by_field: age_band_sort
    sql: ${TABLE}.age_band ;;
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

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
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

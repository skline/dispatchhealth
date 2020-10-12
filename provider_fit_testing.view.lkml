view: provider_fit_testing {
  sql_table_name: looker_scratch.provider_fit_testing ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension_group: fit_test {
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
    sql: ${TABLE}."fit_test_date" ;;
  }

  dimension: fit_tested {
    type: yesno
    sql: ${TABLE}."fit_tested" ;;
  }

  measure: count_fit_tested {
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field: fit_tested
      value: "yes"
    }
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: mask_type {
    type: string
    sql: ${TABLE}."mask_type" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name]
  }
}

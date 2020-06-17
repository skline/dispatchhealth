view: covid_testing_results {
  sql_table_name: looker_scratch.covid_testing_results ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: concat_distinct_patient_id {
    type: string
    sql: ${covid_testing_results.patient_name}||'_'||${covid_testing_results.date_of_birth_date}::DATE ;;
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

  dimension_group: date_of_birth {
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
    sql: ${TABLE}."date_of_birth" ;;
  }

  dimension: facility_state {
    type: string
    sql: ${TABLE}."facility_state" ;;
  }

  dimension: outcome {
    type: string
    sql: UPPER(${TABLE}.outcome) ;;
  }

  dimension: patient_name {
    type: string
    sql: ${TABLE}."patient_name" ;;
  }

  dimension: sample_id {
    type: number
    sql: ${TABLE}."sample_id" ;;
  }

  dimension_group: test_collection {
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
    sql: ${TABLE}."test_collection_date" ;;
  }

  dimension: test_description {
    type: string
    sql: ${TABLE}."test_description" ;;
  }

  dimension: test_status {
    type: string
    sql: ${TABLE}."test_status" ;;
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

  measure: count_positive_tests {
    description: "Count number of positive tests, a given patient may have mutliple positives"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: outcome
      value: "DETECTED"
    }
    }

  measure: count_test_positive_patients {
    description: "Count number of distinct patients with one or more positive test results"
    type: count_distinct
    sql: ${concat_distinct_patient_id} ;;
    filters: {
      field: outcome
      value: "DETECTED"
    }
  }

  measure: count {
    type: count
    drill_fields: [id, patient_name]
  }
}

view: expected_allowable_corporate {
  sql_table_name: looker_scratch.expected_allowable_corporate ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: claim_end {
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
    sql: ${TABLE}."claim_end_date" ;;
  }

  dimension_group: claim_month {
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
    sql: ${TABLE}."claim_month" ;;
  }

  dimension_group: claim_start {
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
    sql: ${TABLE}."claim_start_date" ;;
  }

  dimension: claims_total {
    type: number
    sql: ${TABLE}."claims_total" ;;
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

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}."custom_insurance_grouping" ;;
  }

  dimension: expected_allowable_total {
    type: number
    sql: ${TABLE}."expected_allowable_total" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
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

  measure: sum_expected_allowable {
    description: "The sum of all expected allowable amounts"
    type: sum
    sql: ${expected_allowable_total} ;;
  }

  measure: sum_claims {
    description: "The sum of all claim counts"
    type: sum
    sql: ${claims_total} ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

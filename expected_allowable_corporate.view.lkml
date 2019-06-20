view: expected_allowable_corporate {
  sql_table_name: looker_scratch.expected_allowable_corporate ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: claim_end {
    type: time
    hidden: yes
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
    hidden: yes
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
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}."market_id" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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
    value_format: "$#,##0.00"
  }

  measure: sum_claims {
    description: "The sum of all claim counts"
    type: sum
    sql: ${claims_total} ;;
  }

  measure: avg_expected_allowable {
    type: number
    description: "The average expected allowable from month end corporate finance"
    sql: ${sum_expected_allowable} / ${sum_claims} ;;
    value_format: "$0.00"
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [id]
  }
}

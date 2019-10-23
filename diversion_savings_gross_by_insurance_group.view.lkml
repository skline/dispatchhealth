view: diversion_savings_gross_by_insurance_group {
  sql_table_name: looker_scratch.diversion_savings_gross_by_insurance_group ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: activated {
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
    sql: ${TABLE}."activated" ;;
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

  dimension_group: deactivated {
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
    sql: ${TABLE}."deactivated" ;;
  }

  dimension: diversion_savings_gross_amount {
    type: number
    sql: ${TABLE}."diversion_savings_gross_amount" ;;
  }

  dimension: diversion_type_id {
    type: number
    sql: ${TABLE}."diversion_type_id" ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}

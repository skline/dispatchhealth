view: zizzl_detailed_shift_hours {
  sql_table_name: looker_scratch.zizzl_detailed_shift_hours ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: activities {
    type: string
    description: "Description for non-standard shift activities e.g. solo shift, ambassador, etc."
    sql: ${TABLE}."activities" ;;
  }

  dimension: clinical_non_clinical {
    type: string
    sql: ${TABLE}."clinical_non_clinical" ;;
  }

  dimension_group: counter {
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
    sql: ${TABLE}."counter_date" ;;
  }

  dimension: counter_hours {
    type: number
    sql: ${TABLE}."counter_hours" ;;
  }

  dimension: counter_name {
    type: string
    sql: ${TABLE}."counter_name" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."department" ;;
  }

  dimension: employee_ein {
    type: string
    sql: ${TABLE}."employee_ein" ;;
  }

  dimension: employee_id {
    type: number
    description: "The Zizzl employee ID, which matches the ID in the public.users table"
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: employee_job_title {
    type: string
    sql: ${TABLE}."employee_job_title" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: gross_pay {
    type: number
    description: "For BI staff, keep this hidden and only show aggregated amounts for employee privacy"
    hidden: yes
    sql: ${TABLE}."gross_pay" ;;
  }

  dimension: hourly_rate {
    type: number
    hidden: yes
    description: "For BI staff, keep this hidden and only use in calculations that are aggregated"
    sql: ${TABLE}."hourly_rate" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."location" ;;
  }

  dimension: partner {
    type: string
    sql: ${TABLE}."partner" ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}."position" ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}."provider_type" ;;
  }

  dimension: time_off {
    type: string
    description: "The description when the shift is for paid time off"
    sql: ${TABLE}."time_off" ;;
  }

  dimension_group: updated {
    type: time
    convert_tz: no
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

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, counter_name]
  }
}

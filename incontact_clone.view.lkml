view: incontact_clone {
  sql_table_name: looker_scratch.incontact_clone ;;

  dimension: contact_id {
    type: number
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_time_sec {
    type: number
    sql: ${TABLE}.contact_time_sec ;;
  }

  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
  }

  dimension: duration {
    type: number
    sql: coalesce(${TABLE}.duration,0) ;;
  }

  dimension_group: end {
    convert_tz: no
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
    sql: ${TABLE}.end_time ;;
  }

  dimension: end_time_raw {
    type: string
    sql: ${TABLE}.end_time ;;
  }

  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }

  dimension: from_number {
    type: string
    sql: ${TABLE}.from_number ;;
  }

  dimension: skll_name {
    type: string
    sql: ${TABLE}.skll_name ;;
  }

  dimension_group: start {
    convert_tz: no
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
    sql: ${TABLE}.start_time ;;
  }

  dimension: talk_time_sec {
    type: number
    sql: coalesce(${TABLE}.talk_time_sec,0) ;;
  }

  dimension: to_number {
    type: string
    sql: ${TABLE}.to_number ;;
  }

  measure: count {
    type: count
    drill_fields: [skll_name]
  }
  measure: count_distinct {
    label: "distinct calls pressed IVR"
    type: number
    sql:count(distinct ${contact_id}) ;;
  }

  measure: count_distinct_answers {
    type: number
    sql:count(distinct case when ${talk_time_sec}>0  then ${contact_id} else null end) ;;
  }
  measure:  wait_time{
    type: number
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }
  measure:  average_wait_time{
    type: average_distinct
    sql_distinct_key: concat(${contact_id}, ${start_time}, ${skll_name}) ;;
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }

  measure:  average_wait_time_r{
    type: number
    sql: round(${average_wait_time}) ;;
    }
}

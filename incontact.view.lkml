view: incontact {
  sql_table_name: looker_scratch.incontact ;;

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
    type: number
    sql: ${TABLE}.to_number ;;
  }

  measure: count {
    type: count
    drill_fields: [skll_name]
  }
  measure:  wait_time{
    type: number
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }
  measure:  average_wait_time{
    type: number
    sql: round(avg(${wait_time}),1) ;;
  }
}

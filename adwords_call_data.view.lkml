view: adwords_call_data {
  sql_table_name: looker_scratch.adwords_call_data ;;

  dimension: area_code {
    type: number
    sql: ${TABLE}.area_code ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
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

  dimension: end_time_plus_one {
    type: string
    sql: ${TABLE}.end_time+1 ;;
  }

  dimension: end_time_minus_one {
    type: string
    sql: ${TABLE}.end_time-1 ;;
  }

  dimension: seconds {
    type: number
    sql: ${TABLE}.seconds ;;
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

  measure: average_call_time{
    type: number
    sql: round(avg(${seconds}),1);;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}

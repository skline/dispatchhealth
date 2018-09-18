view: last_patient_seen {
  sql_table_name: looker_scratch.last_patient_seen ;;

  dimension: car_name {
    type: string
    sql: ${TABLE}.car_name ;;
  }

  dimension: complete_count {
    type: number
    sql: ${TABLE}.complete_count ;;
  }

  dimension: hours_between_last_patient_end_shift {
    type: number
    sql: ${TABLE}.hours_between_last_patient_end_shift ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension_group: shift_end {
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
    sql: ${TABLE}.shift_end_time ;;
  }

  dimension: shift_hours {
    type: number
    sql: ${TABLE}.shift_hours ;;
  }

  dimension_group: shift_start {
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
    sql: ${TABLE}.shift_start_time ;;
  }
  measure: average_hours_between_last_patient_end_shift {
    type: average
    sql: ${hours_between_last_patient_end_shift} ;;
  }

  measure: sum_shift_hours {
    type: sum
    sql: ${shift_hours} ;;
  }

  measure: sum_complete_counts {
    type: sum
    sql: ${complete_count} ;;
  }


  measure: count {
    type: count
    drill_fields: [car_name]
  }
}

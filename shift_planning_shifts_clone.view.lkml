view: shift_planning_shifts_clone {
  sql_table_name: looker_scratch.shift_planning_shifts_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: confirmed {
    type: string
    sql: ${TABLE}.confirmed ;;
  }

  dimension: cost_dollars {
    type: string
    sql: ${TABLE}.cost_dollars ;;
  }

  dimension: cost_hours {
    type: string
    sql: ${TABLE}.cost_hours ;;
  }

  dimension: cost_staff {
    type: string
    sql: ${TABLE}.cost_staff ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: employee_name {
    type: string
    sql: ${TABLE}.employee_name ;;
  }

  dimension: employee_rate {
    type: string
    sql: ${TABLE}.employee_rate ;;
  }

  dimension: employee_wage {
    type: string
    sql: ${TABLE}.employee_wage ;;
  }

  dimension: imported_after_shift {
    type: number
    sql: ${TABLE}.imported_after_shift ;;
  }

  dimension_group: local_shift_start {
    type: time
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
    sql: ${TABLE}.local_shift_start_time ;;
  }

  dimension_group: local_shift_end {
    type: time
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
    sql: ${TABLE}.local_shift_end_time ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: schedule_location_id {
    type: string
    sql: ${TABLE}.schedule_location_id ;;
  }

  dimension: schedule_name {
    type: string
    sql: ${TABLE}.schedule_name ;;
  }

  dimension: shift_id {
    type: string
    sql: ${TABLE}.shift_id ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, schedule_name, employee_name]
  }

  measure: shift_hours {
    type: number
    sql: (EXTRACT(EPOCH FROM ${local_shift_end_raw}) - EXTRACT(EPOCH FROM ${local_shift_start_raw})) / 3600 ;;
  }

  measure: total_shift_hours {
    type: sum
    sql:  ${shift_hours} ;;
  }

}

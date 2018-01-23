view: shift_planning_shifts {
  sql_table_name: jasperdb.shift_planning_shifts ;;

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
    type: yesno
    sql: ${TABLE}.imported_after_shift ;;
  }

  dimension_group: local_shift_end {
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
    sql: ${TABLE}.local_shift_end_time ;;
  }

  dimension_group: local_shift_start {
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
    sql: ${TABLE}.local_shift_start_time ;;
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
    drill_fields: [id, employee_name, schedule_name]
  }
}

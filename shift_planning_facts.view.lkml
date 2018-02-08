view: shift_planning_facts {
  label: "APP Shift Planning Facts"
  sql_table_name: jasperdb.shift_planning_facts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: car_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.car_dim_id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension_group: local_actual_end {
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
    sql: ${TABLE}.local_actual_end_time ;;
  }

  dimension_group: local_actual_start {
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
    sql: ${TABLE}.local_actual_start_time ;;
  }

  dimension_group: local_expected_end {
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
    sql: ${TABLE}.local_expected_end_time ;;
  }

  dimension_group: local_expected_start {
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
    sql: ${TABLE}.local_expected_start_time ;;
  }

  dimension: schedule_location_id {
    type: string
    sql: ${TABLE}.schedule_location_id ;;
  }

  dimension: schedule_role {
    type: string
    sql: ${TABLE}.schedule_role ;;
  }

  dimension_group: shift {
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
    sql: ${TABLE}.shift_date ;;
  }

  dimension: shift_id {
    type: string
    sql: ${TABLE}.shift_id ;;
  }

  dimension: total_actual_seconds {
    type: number
    sql: ${TABLE}.total_actual_seconds ;;
  }

  dimension: total_billable_visits {
    type: number
    sql: ${TABLE}.total_billable_visits ;;
  }

  dimension: total_complete_visits {
    type: number
    sql: ${TABLE}.total_complete_visits ;;
  }

  dimension: total_expected_seconds {
    type: number
    sql: ${TABLE}.total_expected_seconds ;;
  }

  dimension: total_resolved_on_scene_visits {
    type: number
    sql: ${TABLE}.total_resolved_on_scene_visits ;;
  }

  dimension_group: updated {
    hidden: yes
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

  dimension: visit_count {
    type: number
    sql: ${TABLE}.visit_count ;;
  }

  measure: count {
    type: count
    drill_fields: [id, employee_name]
  }
  measure: worked_hours {
    type: number
    sql:  total_actual_seconds / 3600  ;;
  }

}

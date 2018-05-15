view: shift_planning_facts_clone {
  sql_table_name: looker_scratch.shift_planning_facts_clone ;;

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

  dimension: car_date_id {
    hidden: yes
    type: string
    sql: CONCAT(${car_dim_id}, DATE_FORMAT(${local_actual_start_date}, "%Y-%m-%d"));;
  }

  measure: count_distinct_car_date {
    label: "Count of Distinct Cars by Date"
    type: count_distinct
    sql: ${car_date_id} ;;
  }

  measure: count_distinct_cars {
    label: "Count of Distinct Cars"
    type: count_distinct
    sql: ${car_dim_id} ;;
  }

  measure: average_cars {
    label: "Average Number of Cars"
    type: number
    sql: ${count_distinct_car_date} / COUNT(DISTINCT ${dates_hours_reference.datehour_date}) ;;
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

  dimension_group: shift_date_final  {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: COALESCE(${local_actual_start_raw}, ${care_request_flat.on_scene_raw}) ;;
  }

  dimension: employee_name {
    type: string
    sql: ${TABLE}.employee_name ;;
  }

  dimension: clean_employee_name {
    type: string
    hidden: yes
    sql: CASE
          WHEN ${employee_name} LIKE '%MoralesJr%' THEN 'Armando Morales'
          WHEN ${employee_name} LIKE '%Vander Leest%' THEN 'Rob VanderLeest'
          WHEN ${employee_name} LIKE '%Gavin Pickard%' THEN 'Binky Pickard'
          WHEN ${employee_name} LIKE '%Dave Mackey%' THEN 'David Mackey'
          WHEN ${employee_name} LIKE '%Heather Rahim%' THEN 'Heather Houston Rahim'
          WHEN ${employee_name} LIKE '%Deevaw Artis%' THEN 'Ndeevaw Artis'
          ELSE ${employee_name}
        END
          ;;
  }

  dimension_group: local_actual_end {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
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
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
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

  dimension: expected_seconds {
    type: number
    sql: EXTRACT(EPOCH FROM ${local_expected_end_raw}) -  EXTRACT(EPOCH FROM ${local_expected_start_raw}) ;;
  }

  measure: sum_hours_scheduled {
    type: sum
    sql: ${expected_seconds} / 3600 ;;
  }

  dimension: schedule_location_id {
    type: string
    sql: ${TABLE}.schedule_location_id ;;
  }

  dimension: schedule_role {
    type: string
    sql: ${TABLE}.schedule_role ;;
  }

  dimension: app_role {
    type: yesno
    sql: ${schedule_role} = 'NP/PA' ;;
  }

  dimension: dhmt_role {
    type: yesno
    sql: ${schedule_role} = 'EMT' OR ${schedule_role} = 'DHMT' ;;
  }

  dimension: app_schedule {
    type: yesno
    sql: ${shift_planning_shifts_clone.schedule_name} LIKE '%NP/PA%' ;;
  }

  dimension: dhmt_schedule {
    type: yesno
    sql: ${shift_planning_shifts_clone.schedule_name} SIMILAR TO '%(EMT:|DHMT:)%' ;;
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

  # dimension: total_billable_visits {
  #   type: number
  #   sql: ${TABLE}.total_billable_visits ;;
  # }

  # dimension: total_complete_visits {
  #   type: number
  #   sql: ${TABLE}.total_complete_visits ;;
  # }
#
#   dimension: total_expected_seconds {
#     type: number
#     sql: ${TABLE}.total_expected_seconds ;;
#   }
#
#   dimension: total_resolved_on_scene_visits {
#     type: number
#     sql: ${TABLE}.total_resolved_on_scene_visits ;;
#   }
#
#   dimension_group: updated {
#     hidden: yes
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}.updated_at ;;
#   }
#
#   dimension: visit_count {
#     type: number
#     sql: ${TABLE}.visit_count ;;
#   }
#
#   measure: count {
#     type: count
#     drill_fields: [id, employee_name]
#   }

  # measure: -_hours_worked {
  #   type: sum_distinct
  #   sql_distinct_key: ${id} ;;
  #   sql:  ${total_actual_seconds} / 3600  ;;
  # }

  measure: sum_all_hours_worked {
    type: sum
    description: "The sum of all hours worked, regardless of role or schedule"
    sql:  CAST(${total_actual_seconds} AS FLOAT) / 3600  ;;
  }

  measure: sum_app_role_hours_worked {
    type: sum
    description: "The sum of hours worked where role is NP/PA (Excludes training)"
    sql:  CAST(${total_actual_seconds} AS FLOAT) / 3600  ;;
    filters: {
      field: app_role
      value: "yes"
    }
  }

  measure: sum_app_schedule_hours_worked {
    type: sum
    description: "The sum of all hours worked where schedule is NP/PA (May include training)"
    sql:  CAST(${total_actual_seconds} AS FLOAT) / 3600  ;;
    filters: {
      field: app_schedule
      value: "yes"
    }
  }

  measure: sum_dhmt_role_hours_worked {
    type: sum
    description: "The sum of hours worked where role is EMT or DHMT (Excludes training)"
    sql:  CAST(${total_actual_seconds} AS FLOAT) / 3600  ;;
    filters: {
      field: dhmt_role
      value: "yes"
    }
  }

  measure: sum_dhmt_schedule_hours_worked {
    type: sum
    description: "The sum of all hours worked where schedule is EMT or DHMT (May include training)"
    sql:  CAST(${total_actual_seconds} AS FLOAT) / 3600  ;;
    filters: {
      field: dhmt_schedule
      value: "yes"
    }
  }

}

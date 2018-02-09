view: app_shift_summary_facts {
  label: "APP Shift Summary Facts"
  sql_table_name: jasperdb.app_shift_summary_facts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: avg_actual_shift_hours {
    description: "The average number of hours for all shifts for the month"
    type: number
    sql: ${TABLE}.avg_actual_shift_hours ;;
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

  dimension: expected_allowed_per_shift {
    description: "The average expected allowed amount per shift for the month"
    type: number
    sql: ${TABLE}.expected_allowed_per_shift ;;
  }

  dimension: provider_efficiency {
    description: "The count of the number of completed and resolved visits as a ratio of the number of shifts for the month"
    type: number
    sql: ${TABLE}.provider_efficiency ;;
  }

  dimension: provider_efficiency_financial {
    description: "The count of the number of billable visits as a ratio of the number of shifts for the month"
    type: number
    sql: ${TABLE}.provider_efficiency_financial ;;
  }

  dimension_group: start_of_month {
    description: "The first Date & Time for the month"
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
    sql: ${TABLE}.start_of_month ;;
  }

  dimension: total_actual_hours {
    description: "The sum of the number of actual shift hours for all shifts for the month"
    type: number
    sql: ${TABLE}.total_actual_hours ;;
  }

  dimension: total_billable_visits {
    description: "Count of the number of billable visits for all shifts for the month"
    type: number
    sql: ${TABLE}.total_billable_visits ;;
  }

  dimension: total_complete_visits {
    description: "Count of the number of completed visits by the provider for all shifts for the month"
    type: number
    sql: ${TABLE}.total_complete_visits ;;
  }

  dimension: total_expected_allowed {
    description: "The sum of the expected allowed amount for all the billable visits for all shifts for the month"
    type: number
    sql: ${TABLE}.total_expected_allowed ;;
  }

  dimension: total_expected_hours {
    description: "The sum of the number of planned shifts hours for all the shifts for the month"
    type: number
    sql: ${TABLE}.total_expected_hours ;;
  }

  dimension: total_overtime_hours {
    description: "The sum of the number of overtime hours for all shifts for the month"
    type: number
    sql: ${TABLE}.total_overtime_hours ;;
  }

  dimension: total_resolved_on_scene_visits {
    description: "Count of the number of visits referred at point of care for all shifts for the month"
    type: number
    sql: ${TABLE}.total_resolved_on_scene_visits ;;
  }

  dimension: total_shifts {
    description: "Count of the number of shifts in the month for the Advanced Practice Provider"
    type: number
    sql: ${TABLE}.total_shifts ;;
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

  measure: count_total_actual_hours {
    type: sum
    sql: ${TABLE}.total_actual_hours ;;
    drill_fields: [id]
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

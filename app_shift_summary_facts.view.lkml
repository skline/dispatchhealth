view: app_shift_summary_facts {
  sql_table_name: jasperdb.app_shift_summary_facts ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: avg_actual_shift_hours {
    type: number
    sql: ${TABLE}.avg_actual_shift_hours ;;
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

  dimension: expected_allowed_per_shift {
    type: number
    sql: ${TABLE}.expected_allowed_per_shift ;;
  }

  dimension: provider_efficiency {
    type: number
    sql: ${TABLE}.provider_efficiency ;;
  }

  dimension: provider_efficiency_financial {
    type: number
    sql: ${TABLE}.provider_efficiency_financial ;;
  }

  dimension_group: start_of_month {
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
    type: number
    sql: ${TABLE}.total_actual_hours ;;
  }

  dimension: total_billable_visits {
    type: number
    sql: ${TABLE}.total_billable_visits ;;
  }

  dimension: total_complete_visits {
    type: number
    sql: ${TABLE}.total_complete_visits ;;
  }

  dimension: total_expected_allowed {
    type: number
    sql: ${TABLE}.total_expected_allowed ;;
  }

  dimension: total_expected_hours {
    type: number
    sql: ${TABLE}.total_expected_hours ;;
  }

  dimension: total_overtime_hours {
    type: number
    sql: ${TABLE}.total_overtime_hours ;;
  }

  dimension: total_resolved_on_scene_visits {
    type: number
    sql: ${TABLE}.total_resolved_on_scene_visits ;;
  }

  dimension: total_shifts {
    type: number
    sql: ${TABLE}.total_shifts ;;
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

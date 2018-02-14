view: shift_planning_facts_by_hour {
  derived_table: {
    sql: SELECT *
      FROM
        (select CAST('2020-01-01 00:00:00' - INTERVAL (a.a + (10 * b.a) + (100 * c.a) + (1000 * d.a) + (10000 * e.a)) HOUR AS DATETIME) as datehour
            from (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as a
            cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as b
            cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as c
            cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as d
            cross join (select 0 as a union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) as e) datehour
      INNER JOIN
        jasperdb.shift_planning_facts s ON datehour.datehour >= s.local_actual_start_time
        AND datehour.datehour <= s.local_actual_end_time
       ;;
    sql_trigger_value: SELECT CURDATE() ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: datehour {
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
    sql: ${TABLE}.datehour ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: local_expected_start_time {
    type: string
    sql: ${TABLE}.local_expected_start_time ;;
  }

  dimension: local_expected_end_time {
    type: string
    sql: ${TABLE}.local_expected_end_time ;;
  }

  dimension: local_actual_start_time {
    type: string
    sql: ${TABLE}.local_actual_start_time ;;
  }

  dimension: local_actual_end_time {
    type: string
    sql: ${TABLE}.local_actual_end_time ;;
  }

  dimension: total_expected_seconds {
    type: string
    sql: ${TABLE}.total_expected_seconds ;;
  }

  dimension: total_actual_seconds {
    type: string
    sql: ${TABLE}.total_actual_seconds ;;
  }

  dimension: shift_id {
    type: string
    sql: ${TABLE}.shift_id ;;
  }

  dimension: schedule_role {
    type: string
    sql: ${TABLE}.schedule_role ;;
  }

  dimension: car_dim_id {
    type: string
    sql: ${TABLE}.car_dim_id ;;
  }

  dimension: employee_name {
    type: string
    sql: ${TABLE}.employee_name ;;
  }

  dimension: visit_count {
    type: string
    sql: ${TABLE}.visit_count ;;
  }

  dimension: created_at {
    type: string
    sql: ${TABLE}.created_at ;;
  }

  dimension: updated_at {
    type: string
    sql: ${TABLE}.updated_at ;;
  }

  dimension: shift_date {
    type: string
    sql: ${TABLE}.shift_date ;;
  }

  dimension: total_complete_visits {
    type: string
    sql: ${TABLE}.total_complete_visits ;;
  }

  dimension: total_resolved_on_scene_visits {
    type: string
    sql: ${TABLE}.total_resolved_on_scene_visits ;;
  }

  dimension: total_billable_visits {
    type: string
    sql: ${TABLE}.total_billable_visits ;;
  }

  dimension: schedule_location_id {
    type: string
    sql: ${TABLE}.schedule_location_id ;;
  }

  set: detail {
    fields: [
      datehour,
      id,
      local_expected_start_time,
      local_expected_end_time,
      local_actual_start_time,
      local_actual_end_time,
      total_expected_seconds,
      total_actual_seconds,
      shift_id,
      schedule_role,
      car_dim_id,
      employee_name,
      visit_count,
      created_at,
      updated_at,
      shift_date,
      total_complete_visits,
      total_resolved_on_scene_visits,
      total_billable_visits,
      schedule_location_id
    ]
  }
}

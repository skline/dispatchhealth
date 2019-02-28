view: shift_planning_hourly_capacity {
  derived_table: {
    sql: SELECT
  spf.shift_date,
  spf.schedule_role,
  spf.schedule_location_id,
  t.start_hour,
  t.end_hour,
  SUM(spf.shift_hours) AS capacity_hrs
  FROM
(SELECT start_hour, end_hour
  FROM generate_series(0, 23) AS start_hour
  JOIN generate_series(1, 24) AS end_hour
  ON end_hour = start_hour + 1) AS t

  LEFT JOIN (
SELECT
 shift_date,
 schedule_role,
 schedule_location_id,
 EXTRACT(HOUR FROM local_actual_start_time) AS shift_start,
 EXTRACT(HOUR FROM local_actual_end_time) AS shift_end,
 SUM(total_actual_seconds / (EXTRACT(EPOCH FROM local_actual_end_time) - EXTRACT(EPOCH FROM local_actual_start_time))) AS shift_hours
 FROM shift_planning_facts_clone
 WHERE schedule_role SIMILAR TO '%(EMT|NP/PA|CSC)%'
 GROUP BY 1,2,3,4,5) AS spf
 ON spf.shift_start <= t.start_hour AND spf.shift_end >= t.end_hour
 WHERE spf.shift_date IS NOT NULL
 GROUP BY 1,2,3,4,5
 ORDER BY 1,2,3,4,5 ;;

    sql_trigger_value: SELECT MAX(shift_date) FROM shift_planning_facts_clone ;;
  }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.shift_date, ' ', ${TABLE}.schedule_role) ;;
  }

  dimension: shift_date {
    type: date
    sql: ${TABLE}.shift_date ;;
  }

  dimension: schedule_role {
    type: string
    sql: ${TABLE}.schedule_role ;;
  }

  dimension: schedule_location_id {
    type: number
    sql: ${TABLE}.schedule_location_id ;;
  }

  dimension: start_hour {
    type: number
    sql: ${TABLE}.start_hour ;;
  }

  dimension: end_hour {
    type: number
    sql: ${TABLE}.end_hour ;;
  }

  dimension: capacity_hrs {
    type: number
    sql: ${TABLE}.capacity_hrs ;;
  }

  measure: sum_capacity_hrs {
    type: count
    sql: ${capacity_hrs} ;;
    sql_distinct_key: ${compound_primary_key} ;;
  }

  measure: distinct_days {
    type: count_distinct
    sql: ${shift_date} ;;
  }


}

view: shift_teams {
  sql_table_name: public.shift_teams ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: compound_primary_key {
    primary_key: no
    hidden: no
    sql: CONCAT(${start_date}::varchar, ${goals_by_day_of_week.market_id}::varchar) ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
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

  dimension_group: end {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.end_time AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz}  ;;
  }

  dimension_group: end_mountain {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.end_time  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      day_of_month,
      week,
      month,
      quarter,
      day_of_week,
      day_of_week_index,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.start_time AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: goal_volume {
    type: number
    sql: case when ${start_day_of_week_index} = 5 then ${goals_by_day_of_week.sat_goal}
    when ${start_day_of_week_index} = 6  then ${goals_by_day_of_week.sun_goal}
    else ${goals_by_day_of_week.weekday_goal} end;;
  }

  measure: sum_goal_volume {
    type: sum_distinct
    sql: ${goal_volume} ;;
    sql_distinct_key: ${compound_primary_key} ;;
  }

  dimension_group: start_mountain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      hour_of_day
    ]
    sql:  ${TABLE}.start_time  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: shift_hours {
    type: number
    sql: (EXTRACT(EPOCH FROM ${end_raw}) - EXTRACT(EPOCH FROM ${start_raw})) / 3600 ;;
  }

  measure: sum_shift_hours {
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
  }

  measure: sum_shift_hours_no_arm_advanced {
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters:  {
      field: cars.mfr_flex_car
      value: "no"
    }
    filters:  {
      field: cars.advanced_care_car
      value: "no"
    }
  }

  measure: productivity {
    type: number
    value_format: "0.00"
    sql: case when ${sum_shift_hours_no_arm_advanced}>0 then ${care_request_flat.complete_count_no_arm_advanced}/${sum_shift_hours_no_arm_advanced} else 0 end ;;
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

  dimension: car_date_id {
    type: string
    sql: CONCAT(${cars.name}, ${start_mountain_date});;
  }

  dimension: car_hour_id {
    type: string
    sql: CONCAT(${cars.name}, ${start_mountain_date}, ${dates_hours_reference_clone.datehour_timezone_hour_of_day});;
  }

  measure: count_distinct_shifts {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: count_distinct_car_date_shift {
    label: "Count of Distinct Cars by Date (Shift Teams)"
    type: count_distinct
    sql_distinct_key: ${car_date_id} ;;
    sql: ${car_date_id} ;;
  }


  measure: count_distinct_car_hour_shift {
    label: "Count of Distinct Cars by Hour (Shift Teams)"
    type: count_distinct
    sql_distinct_key: ${car_hour_id} ;;
    sql: ${car_hour_id} ;;
  }

  measure: hourly_productivity {
    value_format: "0.00"
    type: number
    sql: ${care_request_flat.complete_count}::float / ${count_distinct_car_date_shift}::float ;;
  }

  measure: daily_productivity {
    value_format: "0.00"
    type: number
    sql: ${care_request_flat.complete_count}::float / ${count_distinct_car_hour_shift}::float ;;
  }


  measure: count {
    type: count
    drill_fields: [id, shift_team_members.count]
  }
}

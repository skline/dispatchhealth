view: shift_details {
  sql_table_name: looker_scratch.shift_details ;;

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    # Mod SG
    hidden: yes
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: deleted {
    type: time
    # Mod SG
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}.employee_id ;;
  }

  dimension: employee_name {
    type: string
    sql: ${TABLE}.employee_name ;;
  }

  dimension_group: local_actual_end {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour,
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
      time,
      hour,
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
    sql: ${TABLE}.local_expected_end_time ;;
  }

  dimension_group: local_expected_start {
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
    sql: ${TABLE}.local_expected_start_time ;;

  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: schedule_location_id {
    type: number
    sql: ${TABLE}.schedule_location_id ;;
  }

  dimension: schedule_name {
    type: string
    sql: ${TABLE}.schedule_name ;;
  }

  dimension: shift_role {
    type: string
    description: "Shift parsed from schedule_name"
        sql: split_part(${TABLE}.schedule_name,':',1) ;;
  }

  dimension: app_shift {
    type: yesno
    description: "NP/PA in schedule_name"
    # sql: position('NP/PA' in ${TABLE}.schedule_name) > 0 ;;
    sql: ${schedule_name} LIKE '%NP/PA:%';;
  }

  dimension: valid_shift {
    type: yesno
    description: "Employee is assinged to shift"
    sql: ${employee_name} IS NOT NULL ;;
  }

  dimension: holiday_shift {
    type: yesno
    description: "Shift occurred on a holiday"
    sql: ${schedule_name} LIKE '%(H)' ;;
  }

  dimension: shift_id {
    type: number
    hidden: yes
    sql: ${TABLE}.shift_id ;;
  }

  dimension_group: updated {
    type: time
    # Mod SG
    hidden: yes
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, schedule_name, employee_name]
  }

  measure: shift_count {
    type: count_distinct
    sql: ${TABLE}.shift_id;;
  }

  measure: count_validate_app_shifts {
    type: count_distinct
    sql: ${TABLE}.shift_id;;

    filters: {
      field: app_shift
      value: "yes"
    }

    filters: {
      field: valid_shift
      value: "yes"
    }


  }

}

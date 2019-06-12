view: breaks {
  sql_table_name: public.breaks ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension_group: end {
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
    sql: ${TABLE}."end_time" ;;
  }

  dimension: market_break_config_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."market_break_config_id" ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}."shift_team_id" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."start_time" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, market_break_configs.id]
  }


  dimension: shift_included_break {
    type: yesno
    description: "A break was taken duirng the duration of the shift"
    sql: ${start_date} IS NOT NULL;;
  }

  dimension: break_time_minutes {
    type: number
    description: "number of minutes between break start time and break end time"
    sql:  (EXTRACT(EPOCH FROM ${end_raw})-EXTRACT(EPOCH FROM ${start_raw}))::float / 60 ;;
    value_format: "0.00"
  }

  measure: count_distinct_shifts_with_break {
    type: count_distinct
    description: "Count of the distinct number of shifts where a break occurred"
    sql: ${shift_team_id} ;;
    filters: {
      field: shift_included_break
      value: "yes"
    }
  }

  measure: sum_break_time_minutes {
    type:  sum
    description: "Sum of the total number of break minutes"
    sql:  ${break_time_minutes} ;;
    value_format: "0.00"
  }

  measure: average_break_time_minutes {
    type:  average
    description: "Average of the total number of break minutes"
    sql: ${break_time_minutes} ;;
    value_format: "0.00"

  }

 }

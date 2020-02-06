view: zizzl_employee_roster {
  sql_table_name: looker_scratch.zizzl_employee_roster ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: count_active_employees {
    type: number
    sql: ${TABLE}."count_active_employees" ;;
  }

  measure: avg_active_employees {
    type: average
    description: "The average number of active employees."
    sql: ${count_active_employees} ;;
  }

  dimension: count_involuntary_terminations {
    type: number
    sql: ${TABLE}."count_involuntary_terminations" ;;
  }

  measure: sum_involuntary_terminations {
    type: sum
    sql: ${count_involuntary_terminations} ;;
  }

  dimension: count_voluntary_terminations {
    type: number
    sql: ${TABLE}."count_voluntary_terminations" ;;
  }

  measure: sum_voluntary_terminations {
    type: sum
    sql: ${count_voluntary_terminations} ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: employee_category {
    type: string
    sql: ${TABLE}."employee_category" ;;
  }

  dimension: employee_location {
    type: string
    sql: CASE
          WHEN ${TABLE}."employee_location" LIKE 'Advanced Care%' THEN 'Headquarters/Corporate'
          ELSE ${TABLE}."employee_location"
        END;;
  }

  dimension_group: report {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."report_date" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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
    drill_fields: [id]
  }
}

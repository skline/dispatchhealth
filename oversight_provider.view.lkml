view: oversight_provider {
  sql_table_name: looker_scratch.oversight_provider ;;

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: oversight_first_name {
    type: string
    sql: ${TABLE}.oversight_first_name ;;
  }

  dimension: oversight_last_name {
    type: string
    sql: ${TABLE}.oversight_last_name ;;
  }

  dimension: oversight_position {
    type: string
    sql: ${TABLE}.oversight_position ;;
  }

  dimension: oversight_user_name {
    type: string
    sql: ${TABLE}.oversight_user_name ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}.user_name ;;
  }

  dimension: active {
    type: string
    sql: ${TABLE}.active ;;
  }

  dimension_group: activated_date {
    type: time
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."activated_date" ;;
  }

  dimension_group: deactivated_date {
    type: time
    hidden: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."deactivated_date" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      user_name,
      first_name,
      last_name,
      oversight_user_name,
      oversight_first_name,
      oversight_last_name
    ]
  }
}

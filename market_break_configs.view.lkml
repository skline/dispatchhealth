view: market_break_configs {
  sql_table_name: public.market_break_configs ;;

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

  dimension: duration {
    type: number
    sql: ${TABLE}."duration" ;;
  }

  dimension: hours_into_shift {
    type: number
    sql: ${TABLE}."hours_into_shift" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: threshold_in_minutes {
    type: number
    sql: ${TABLE}."threshold_in_minutes" ;;
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
    drill_fields: [id, breaks.count]
  }
}

view: bi_events {
  sql_table_name: public.bi_events ;;
  drill_fields: [id]

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
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: details {
    type: string
    sql: ${TABLE}."details" ;;
  }

  dimension: market_capacity {
    type: string
    sql:${TABLE}."details"::json->>'availability' ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}."event_type" ;;
  }

  dimension: subject_id {
    type: number
    sql: ${TABLE}."subject_id" ;;
  }

  dimension: subject_type {
    type: string
    sql: ${TABLE}."subject_type" ;;
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
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

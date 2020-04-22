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
    description: "The created timestamp, converted to local market time"
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: created_decimal {
    description: "created time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    value_format: "0.00"
    sql: (CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT)) / 60) ;;
  }

  measure: average_hour_of_day {
    type: average
    value_format: "0.0"
    sql: ${created_decimal} ;;
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
    description: "The updated timestamp, converted to local market time"
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_week,
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

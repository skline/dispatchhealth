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

  measure: min_booked {
    type: time
    sql: min(case when ${market_capacity} = 'full' then ${created_raw} else null end) ;;
  }

  measure: max_booked {
    type: time
    sql: max(case when ${market_capacity} = 'full' then ${created_raw} else null end) ;;
  }

  measure: min_open {
    type: time
    sql: min(case when ${market_capacity} != 'full' then ${created_raw} else null end) ;;
  }

  measure: max_open {
    type: time
    sql: max(case when ${market_capacity} != 'full' then ${created_raw} else null end) ;;
  }

  measure: diff_min_booked_max_open {
    value_format: "0"
    type: number
    sql: EXTRACT(epoch FROM (${max_open_raw})-(${min_booked_raw}))/60.0  ;;
  }
  measure: count_booked {
    type: count_distinct
    sql: ${id} ;;
    sql_distinct_key: ${id} ;;
    filters: {
      field: market_capacity
      value: "full"
    }

  }

  measure: count_distinct {
    type: count_distinct
    sql: ${id} ;;
    sql_distinct_key: ${id} ;;

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

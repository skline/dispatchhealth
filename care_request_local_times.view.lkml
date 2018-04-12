view: care_request_local_times {
  derived_table: {
    sql:
      WITH timezone(id, tz_desc) AS (VALUES
      (159, 'US/Mountain'),
      (160, 'US/Mountain'),
      (161, 'US/Arizona'),
      (162, 'US/Pacific'),
      (164, 'US/Eastern'),
      (165, 'US/Central'),
      (166, 'US/Central'))

SELECT
    markets.id AS market_id,
    cr.id as care_request_id,
    timezone.tz_desc,
    max(request.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS requested_date,
    max(accept.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS accept_date,
    max(onroute.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS on_route_date,
    max(onscene.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS on_scene_date,
    MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS complete_date
  FROM care_requests cr
  LEFT JOIN care_request_statuses AS request
  ON cr.id = request.care_request_id AND request.name = 'requested'
  LEFT JOIN care_request_statuses AS accept
  ON cr.id = accept.care_request_id AND accept.name = 'accepted'
  LEFT JOIN care_request_statuses AS onroute
  ON cr.id = onroute.care_request_id AND onroute.name = 'on_route'
  LEFT JOIN care_request_statuses onscene
  ON cr.id = onscene.care_request_id AND onscene.name = 'on_scene'
  LEFT JOIN care_request_statuses comp
  ON cr.id = comp.care_request_id AND comp.name = 'complete'
  JOIN markets
  ON cr.market_id = markets.id
  JOIN timezone
  ON markets.id = timezone.id
  GROUP BY 1, 2, 3; ;;
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension_group: on_route {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month
      ]
    sql: ${TABLE}.on_route_date ;;
  }

  dimension: on_route_decimal {
    description: "On Route Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_route_raw}) AS INT)) +
        ((CAST(EXTRACT(MINUTE FROM ${on_route_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension_group: on_scene {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month
      ]
    sql: ${TABLE}.on_scene_date ;;
  }

  dimension_group: accept {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month
    ]
    sql: ${TABLE}.accept_date ;;
  }

  dimension_group: request {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month
    ]
    sql: ${TABLE}.request_date ;;
  }

  dimension: on_scene_decimal {
    description: "On Scene Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension_group: complete {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month
      ]
    sql: ${TABLE}.complete_date ;;
  }

  measure: max_complete_time {
    label: "Last Care Request Completion Time"
    type: date_time
    sql:  MAX(${complete_raw}) ;;
  }

  dimension: complete_decimal {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: complete_decimal_after_midnight {
    description: "Complete Time of Day as Decimal Accounting for Time After Midnight"
    type: number
    sql: CASE
          WHEN (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) <=3 THEN 24
          ELSE 0
        END +
        (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) +
        ((CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT)) / 60) ;;
  }

}

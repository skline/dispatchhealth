view: care_request_local_times {
  derived_table: {
    sql:
      WITH timezone(id, tz_desc) AS (VALUES
      (159, 'US/Mountain'),
      (160, 'US/Arizona'),
      (161, 'US/Pacific'),
      (162, 'US/Eastern'),
      (164, 'US/Central'),
      (165, 'US/Central'))

  SELECT
    markets.id AS market_id,
    onroute.care_request_id,
    timezone.tz_desc,
    onroute.started_at AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS on_route_date,
    onscene.started_at AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS on_scene_date,
    MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS complete_date
  FROM care_request_statuses AS onroute
  JOIN care_request_statuses onscene
  ON onroute.care_request_id = onscene.care_request_id AND onroute.name = 'on_route' AND onscene.name = 'on_scene'
  JOIN care_request_statuses comp
  ON onscene.care_request_id = comp.care_request_id AND onscene.name = 'on_scene' AND comp.name = 'complete'
  JOIN care_requests cr
  ON cr.id = onroute.care_request_id
  JOIN markets
  ON cr.market_id = markets.id
  JOIN timezone
  ON markets.id = timezone.id
  GROUP BY 1, 2, 3, 4, 5 ;;
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
    timeframes: [date, time, week, month]
    sql: ${TABLE}.on_route_date ;;
  }

  dimension_group: on_scene {
    type: time
    timeframes: [date, time, week, month]
    sql: ${TABLE}.on_scene_date ;;
  }

  dimension_group: complete {
    type: time
    timeframes: [date, time, week, month]
    sql: ${TABLE}.complete_date ;;
  }

}

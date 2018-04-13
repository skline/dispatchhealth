view: care_request_flat {
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
    MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE timezone.tz_desc AS complete_date,
    case when array_to_string(array_agg(distinct comp.comment), ':') = '' then null
    else array_to_string(array_agg(distinct comp.comment), ':')end
    as complete_comment,
    case when array_to_string(array_agg(distinct archive.comment), ':') = '' then null
    else array_to_string(array_agg(distinct archive.comment), ':') end
    as archive_comment
  FROM care_requests cr
  LEFT JOIN care_request_statuses AS request
  ON cr.id = request.care_request_id AND request.name = 'requested' and request.deleted_at is null
  LEFT JOIN care_request_statuses AS accept
  ON cr.id = accept.care_request_id AND accept.name = 'accepted' and accept.deleted_at is null
  LEFT JOIN care_request_statuses AS onroute
  ON cr.id = onroute.care_request_id AND onroute.name = 'on_route' and onroute.deleted_at is null
  LEFT JOIN care_request_statuses onscene
  ON cr.id = onscene.care_request_id AND onscene.name = 'on_scene' and onscene.deleted_at is null
  LEFT JOIN care_request_statuses comp
  ON cr.id = comp.care_request_id AND comp.name = 'complete' and comp.deleted_at is null
  LEFT JOIN care_request_statuses schedule
  ON cr.id = schedule.care_request_id AND schedule.name = 'scheduled'  and schedule.deleted_at is null
  LEFT JOIN care_request_statuses archive
  ON cr.id = archive.care_request_id AND archive.name = 'archived' and archive.deleted_at is null
  JOIN markets
  ON cr.market_id = markets.id
  JOIN timezone
  ON markets.id = timezone.id
  GROUP BY 1, 2, 3 ;;
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

  dimension: archive_comment {
    type: number
    sql: ${TABLE}.archive_comment ;;
  }

  dimension: complete_comment {
    type: number
    sql: ${TABLE}.complete_comment ;;
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
      month,
      day_of_week_index,
      day_of_month
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
      month,
      day_of_week_index,
      day_of_month
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
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.accept_date ;;
  }

  dimension_group: requested {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.requested_date ;;
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
      month,
      day_of_week_index,
      day_of_month
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

  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  dimension:  same_day_of_week_on_scene {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${on_scene_day_of_week_index};;
  }

  dimension: until_today_on_scene {
    type: yesno
    sql: ${on_scene_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${on_scene_day_of_week_index} >= 0 ;;
  }

  dimension: this_week_on_scene {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${on_scene_week};;

  }
  dimension: this_month_on_scene {
    type:  yesno
    sql: ${yesterday_mountain_month} =  ${on_scene_month};;
  }

  dimension: month_to_date_on_scene  {
    type:  yesno
    sql: ${on_scene_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  measure: distinct_months_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_month}) ;;
  }


  measure: distinct_days_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_date}) ;;
  }

  measure: distinct_weeks_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_week}) ;;
  }

  measure: daily_average_complete {
    type: number
    sql: ${complete_count}/(nullif(${distinct_days_on_scene},0))  ;;
  }

  measure: weekly_average_complete {
    type: number
    sql: ${complete_count}/(nullif(${distinct_weeks_on_scene},0)) ;;
  }

  measure: monthly_average_complete {
    type: number
    sql: ${complete_count}/(nullif(${distinct_months_on_scene},0)) ;;
  }


  measure: min_day_on_scene {
    type: date
    sql: min(${on_scene_date}) ;;
  }

  measure: max_day_on_scene {
    type: date
    sql:max(${on_scene_date}) ;;
  }

  measure: min_week_on_scene {
    type: string
    sql: min(${on_scene_week}) ;;
  }

  measure: max_week_on_scene {
    type: string
    sql:max(${on_scene_week}) ;;
  }
  measure: min_month_on_scene {
    type: string
    sql: min(${on_scene_month}) ;;
  }

  measure: max_month_on_scene {
    type: string
    sql:max(${on_scene_month}) ;;
  }

  measure: min_max_range_day_on_scene {
    type: string
    sql:
      case when ${min_week_on_scene} =  ${yesterday_mountain_week} then ${min_day_on_scene}::text
      else concat(trim(to_char(current_date - interval '1 day', 'day')), 's ', ${min_day_on_scene}, ' thru ', ${max_day_on_scene}) end ;;

    }

    measure: min_max_range_week {
      type: string
      sql:
      case when ${min_week_on_scene} =  ${yesterday_mountain_week} then concat(${min_day_on_scene}, ' thru ', ${max_day_on_scene})
      else concat('Week to date for weeks ', ${min_week_on_scene}, ' thru ', ${max_week_on_scene}) end ;;

      }

      measure: min_max_range {
        type: string
        sql: concat(${min_day_on_scene}, ' thru ', ${max_day_on_scene});;

      }

  measure: projections_diff {
    label: "Diff to budget"
    type: number
    sql: round(${monthly_visits_run_rate}-${budget_projections_by_market_clone.projected_visits}) ;;
  }

  measure: projections_diff_target {
    label: "Diff to productivity target"
    type: number
    sql: round(${monthly_visits_run_rate}-${shift_hours_by_day_market_clone.productivity_target}) ;;
  }

  measure: productivity {
    type: number
    sql: round(${complete_count}/NULLIF(${shift_hours_by_day_market_clone.sum_total_hours}::DECIMAL,0), 2) ;;
  }

  measure: resolved_reason {
    type: string
    sql:array_agg(distinct concat(${complete_comment}, ${archive_comment}))::text ;;
  }

  dimension: resolved_reason_full {
    type: string
    sql: coalesce(${complete_comment}, ${archive_comment}) ;;
  }

  dimension: primary_resolved_reason {
    type:  string
    sql: split_part(${resolved_reason_full}, ':', 1) ;;
  }

  dimension: secondary_resolved_reason {
    type:  string
    sql: split_part(${resolved_reason_full}, ':', 2) ;;
  }

  dimension: primary_and_secondary_resolved_reason {
    type: string
    sql: concat(${primary_resolved_reason},': ', ${secondary_resolved_reason}) ;;
  }


  dimension: other_resolved_reason {
    type:  string
    sql: split_part(${resolved_reason_full}, ':', 3) ;;
  }


  dimension: escalated_on_scene {
    type: yesno
    sql: UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE%' ;;
  }

  dimension: lwbs_going_to_ed {
    type: yesno
    sql: ${archive_comment} = 'Cancelled by Patient: Going to an Emergency Department' ;;
  }

  dimension: lwbs_going_to_urgent_care {
    type: yesno
    sql: ${archive_comment} = 'Cancelled by Patient: Going to an Urgent Care' ;;
  }

  dimension: lwbs_wait_time_too_long {
    type: yesno
    sql: ${archive_comment} = 'Cancelled by Patient: Wait time too long' ;;
  }

  dimension: lwbs_no_show {
    type: yesno
    sql: ${archive_comment} = 'No Show' ;;
  }

  dimension: lwbs {
    type: yesno
    description: "Going to ED/Urgent Care, Wait Time Too Long, or No Show"
    sql: ${lwbs_going_to_ed} OR ${lwbs_going_to_urgent_care} OR ${lwbs_wait_time_too_long} OR ${lwbs_no_show} ;;
  }

  measure: lwbs_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
  }

  measure: escalated_on_scene_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_scene
      value: "yes"
    }
  }

  dimension: escalated_on_scene_ed {
    type: yesno
    sql: ${complete_comment} = 'Referred - Point of Care: ED'
      OR ${complete_comment} = 'Referred - Point of care: ED';;
  }

  dimension: escalated_on_phone {
    type: yesno
    sql: ${complete_comment} LIKE '%Referred - Phone Triage%' ;;
  }

  dimension: escalated_on_phone_reason {
    type: string
    sql: CASE
          WHEN ${escalated_on_phone} THEN split_part(${complete_comment}, ':', 2)
          ELSE NULL
        END ;;
  }

  dimension: complete {
    type: yesno
    sql: ${complete_date} is not null ;;
  }


  measure: complete_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
  }
  measure: month_percent {
    type: number
    sql:    extract(day from ${max_day_on_scene})
          /    DATE_PART('days',
              DATE_TRUNC('month', current_date)
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          );;
  }

  measure: monthly_visits_run_rate {
    type: number
    sql: round(${complete_count}/${month_percent});;
  }

  dimension: rolling_30_day {
    type: string
    sql:
    case when ${on_scene_date} >= current_date - interval '30 day' then 'past 30 days'
    when  ${on_scene_date} between current_date - interval '60 day' and  current_date - interval '30 day' then 'previous 30 days'
    else null end;;
  }



}
view: care_request_flat {
  derived_table: {
    sql:
    SELECT
        markets.id AS market_id,
        cr.id as care_request_id,
        t.pg_tz,
        cr.created_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS created_date,
        max(shift_teams.start_time) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS shift_start_time,
        max(shift_teams.end_time) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS shift_end_time,
        max(request.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS requested_date,
        max(accept.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date,
        max(schedule.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS scheduled_date,
        max(onroute.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_route_date,
        max(onscene.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_scene_date,
        MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS complete_date,
        MIN(archive.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS archive_date,
        fu3.comment AS followup_3day_result,
        fu14.comment AS followup_14day_result,
        fu30.comment AS followup_30day_result,
        case when array_to_string(array_agg(distinct comp.comment), ':') = '' then null
        else array_to_string(array_agg(distinct comp.comment), ':')end
        as complete_comment,
        case when array_to_string(array_agg(distinct archive.comment), ':') = '' then null
        else array_to_string(array_agg(distinct archive.comment), ':') end
        as archive_comment,
        cr.shift_team_id
      FROM care_requests cr
      LEFT JOIN care_request_statuses AS request
      ON cr.id = request.care_request_id AND request.name = 'requested' and request.deleted_at is null
      LEFT JOIN care_request_statuses schedule
      ON cr.id = schedule.care_request_id AND schedule.name = 'scheduled'  and schedule.deleted_at is null
      LEFT JOIN care_request_statuses AS accept
      ON cr.id = accept.care_request_id AND accept.name = 'accepted' and accept.deleted_at is null
      LEFT JOIN care_request_statuses AS onroute
      ON cr.id = onroute.care_request_id AND onroute.name = 'on_route' and onroute.deleted_at is null
      LEFT JOIN care_request_statuses onscene
      ON cr.id = onscene.care_request_id AND onscene.name = 'on_scene' and onscene.deleted_at is null
      LEFT JOIN care_request_statuses comp
      ON cr.id = comp.care_request_id AND comp.name = 'complete' and comp.deleted_at is null
      LEFT JOIN care_request_statuses archive
      ON cr.id = archive.care_request_id AND archive.name = 'archived' and archive.deleted_at is null
      LEFT JOIN care_request_statuses fu3
      ON cr.id = fu3.care_request_id AND fu3.name = 'followup_3'
      LEFT JOIN care_request_statuses fu14
      ON cr.id = fu14.care_request_id AND fu14.name = 'followup_14'
      LEFT JOIN care_request_statuses fu30
      ON cr.id = fu30.care_request_id AND fu30.name = 'followup_30'
      LEFT JOIN public.shift_teams
      ON shift_teams.id = cr.shift_team_id
      JOIN markets
      ON cr.market_id = markets.id
      JOIN looker_scratch.timezones AS t
      ON markets.sa_time_zone = t.rails_tz
      GROUP BY 1,2,3,14,15,16 ;;

    sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
    indexes: ["care_request_id"]
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: on_scene_time_seconds {
    type: number
    description: "The number of seconds between complete time and on scene time"
    sql: EXTRACT(EPOCH FROM ${complete_raw})-EXTRACT(EPOCH FROM ${on_scene_raw}) ;;
  }

  dimension: drive_time_seconds {
    type: number
    description: "The number of seconds between on route time and on scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw})-EXTRACT(EPOCH FROM ${on_route_raw}) ;;
  }

  dimension: in_queue_time_seconds {
    type: number
    description: "The number of seconds between requested time and accepted time"
    sql: EXTRACT(EPOCH FROM ${accept_raw})-EXTRACT(EPOCH FROM ${requested_raw}) ;;
  }

  dimension: assigned_time_seconds {
    type: number
    description: "The number of seconds between accepted time and on-route time"
    sql: EXTRACT(EPOCH FROM ${on_route_raw})-EXTRACT(EPOCH FROM ${accept_raw}) ;;
  }

  dimension: on_scene_time_minutes {
    type: number
    description: "The number of minutes between complete time and on scene time"
    sql: CASE
          WHEN ABS((EXTRACT(EPOCH FROM ${complete_raw})-EXTRACT(EPOCH FROM ${on_scene_raw}))::float/60.0) < 241
          THEN (EXTRACT(EPOCH FROM ${complete_raw})-EXTRACT(EPOCH FROM ${on_scene_raw}))::float/60.0
          ELSE NULL
        END ;;
  }

  dimension: drive_time_minutes {
    type: number
    description: "The number of minutes between on-route time and on-scene time"
    sql: (EXTRACT(EPOCH FROM ${on_scene_raw})-EXTRACT(EPOCH FROM ${on_route_raw}))::float/60.0 ;;
  }

  dimension: is_reasonable_drive_time {
    type: yesno
    hidden: yes
    sql: ${drive_time_seconds} > 299 AND ${drive_time_seconds} < 14401;;
  }

  dimension: in_queue_time_minutes {
    type: number
    description: "The number of minutes between requested time and accepted time"
    sql: (EXTRACT(EPOCH FROM ${accept_raw})-EXTRACT(EPOCH FROM ${requested_raw}))::float/60.0 ;;
  }

  dimension: assigned_time_minutes {
    type: number
    description: "The number of minutes between accepted time and on-route time"
    sql: (EXTRACT(EPOCH FROM ${on_route_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0;;
  }

  measure:  average_drive_time_seconds{
    type: average_distinct
    description: "The average seconds between on-route time and on-scene time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_seconds} ;;
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
  }

  measure:  average_in_queue_time_seconds{
    type: average_distinct
    description: "The average seconds between requested time and accepted time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_seconds} ;;
  }

  measure:  average_assigned_time_seconds{
    type: average_distinct
    description: "The average seconds between between accepted time and on-route time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${assigned_time_seconds} ;;
  }

  measure:  average_drive_time_minutes{
    type: average_distinct
    description: "The average minutes between on-route time and on-scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes} ;;
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
  }

  measure:  average_in_queue_time_minutes{
    type: average_distinct
    description: "The average minutes between requested time and accepted time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_minutes} ;;
  }

  measure:  average_assigned_time_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and on-route time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${assigned_time_minutes} ;;
  }

  measure:  average_on_scene_time_minutes{
    type: average_distinct
    description: "The average minutes between complete time and on scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${on_scene_time_minutes} ;;

  }
#   Need to get this working for histograms
   parameter: bucket_size {
     default_value: "10"
     type: number
   }

   dimension: assigned_time_dynamic_sort_field {
     sql:
       ${assigned_time_minutes} - mod(CAST(${assigned_time_minutes} AS INT),{% parameter bucket_size %});;
     type: number
     hidden: yes
   }

   dimension: assigned_time_dynamic_bucket  {
     sql:
         concat(${assigned_time_minutes} - mod(CAST(${assigned_time_minutes} AS INT),{% parameter bucket_size %}),
           '-', ${assigned_time_minutes} - mod(CAST(${assigned_time_minutes} AS INT),{% parameter bucket_size %} + {% parameter bucket_size %})
       ;;
     order_by_field: assigned_time_dynamic_sort_field
   }

  measure: average_wait_time_total {
    description: "Total patient wait time: the average minutes between requested time and on-scene time"
    type: number
    value_format: "0"
    sql: ${average_in_queue_time_seconds} + ${average_assigned_time_seconds} + ${average_drive_time_seconds} ;;
  }

  dimension: last_care_request {
    type: yesno
    sql: MAX(${complete_raw}) ;;
  }

  dimension: pre_post {
    type: yesno
    description: "A flag indicating the Denver shift-ladder experiment (4/2/2018 - 4/13/2018)"
    sql: (DATE(${requested_raw}) BETWEEN '2018-04-02' AND '2018-04-13') ;;
  }

  dimension: cc_pre_post {
    type: yesno
    description: "A flag indicating the credit card fix was put into production"
    sql: (DATE(${on_scene_raw}) > '2018-04-13') ;;
  }

  dimension: market_id {
    type: number
    hidden: yes
    sql: ${TABLE}.market_id ;;
  }

  dimension: archive_comment {
    type: string
    description: "The CSC comment provided when a care request is archived"
    sql: ${TABLE}.archive_comment ;;
  }

  dimension: complete_comment {
    type: string
    sql: ${TABLE}.complete_comment ;;
  }

  dimension: followup_3day_result {
    type: string
    description: "The 3-day follow-up call result"
    sql: ${TABLE}.followup_3day_result ;;
  }

  dimension: followup_3day {
    type: yesno
    description: "A flag indicating the 3-day follow-up call was completed"
    sql: ${complete_date} IS NOT NULL AND
    ${followup_3day_result} is NOT NULL AND ${followup_3day_result} != 'patient_called_but_did_not_answer' ;;
  }

  dimension: bounceback_3day {
    type: yesno
    sql: ${followup_3day_result} LIKE '%same_complaint%' ;;
  }

  dimension: followup_14day_result {
    type: string
    description: "The 14-day follow-up result"
    sql: ${TABLE}.followup_14day_result ;;
  }

  dimension: bounceback_14day {
    type: yesno
    sql: ${followup_14day_result} LIKE '%same_complaint%' OR ${bounceback_3day} ;;
  }

  dimension: followup_30day_result {
    type: string
    description: "The 30-day follow-up result"
    sql: ${TABLE}.followup_30day_result ;;
  }

  dimension: followup_30day {
    type: yesno
    description: "A flag indicating the 14/30-day follow-up was completed"
    sql: ${complete_date} IS NOT NULL AND
    ${followup_30day_result} IS NOT NULL AND ${followup_30day_result} != 'no_hie_data' ;;
  }

  dimension: no_hie_data {
    type: yesno
    sql: ${followup_14day_result} != 'no_hie_data' OR ${followup_30day_result} != 'no_hie_data' ;;
  }

  measure: count_no_hie_data {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: no_hie_data
      value: "yes"
    }
  }

  dimension: bounceback_30day {
    type: yesno
    sql: ${followup_30day_result} LIKE '%same_complaint%' OR ${bounceback_3day} OR ${bounceback_14day} ;;
  }

  measure: count_3day_bb {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bounceback_3day
      value: "yes"
    }
  }

  measure: count_3day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_3day
      value: "yes"
    }
  }

  measure: count_14day_bb {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bounceback_14day
      value: "yes"
    }
  }

  measure: count_30day_bb {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bounceback_30day
      value: "yes"
    }
  }

  measure: count_30day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_30day
      value: "yes"
    }
  }

  dimension_group: on_route {
    type: time
    description: "The local date and time when the care request team is on-route"
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

  dimension_group: created {
    type: time
    description: "The local date/time that the care request was created."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.created_date ;;
  }

  dimension: time_group_sort {
    type: number
    hidden: yes
    sql: CASE
          WHEN ${created_hour_of_day} BETWEEN 0 AND 8 THEN 1
          WHEN ${created_hour_of_day} BETWEEN 9 AND 10 THEN 2
          WHEN ${created_hour_of_day} BETWEEN 11 AND 12 THEN 3
          WHEN ${created_hour_of_day} BETWEEN 13 AND 14 THEN 4
          WHEN ${created_hour_of_day} BETWEEN 15 AND 16 THEN 5
          WHEN ${created_hour_of_day} BETWEEN 17 AND 18 THEN 6
          WHEN ${created_hour_of_day} BETWEEN 19 AND 24 THEN 7
    ELSE NULL
    END
    ;;
  }

  dimension: created_time_group {
    type: string
    order_by_field: time_group_sort
    description: "Created time of day split into 4 broad groups"
    sql: CASE
          WHEN ${created_hour_of_day} BETWEEN 0 AND 8 THEN '8:59 or Earlier'
          WHEN ${created_hour_of_day} BETWEEN 9 AND 10 THEN '9:00 - 10:59'
          WHEN ${created_hour_of_day} BETWEEN 11 AND 12 THEN '11:00 - 12:59'
          WHEN ${created_hour_of_day} BETWEEN 13 AND 14 THEN '13:00 - 14:59'
          WHEN ${created_hour_of_day} BETWEEN 15 AND 16 THEN '15:00 - 16:59'
          WHEN ${created_hour_of_day} BETWEEN 17 AND 18 THEN '17:00 - 18:59'
          WHEN ${created_hour_of_day} BETWEEN 19 AND 24 THEN '19:00 or Later'
          ELSE NULL
        END
          ;;
  }

  dimension: etc_model_in_place {
    type: yesno
    sql: ${created_raw} >= '2018-03-29'::TIMESTAMP ;;
  }

  measure: distinct_day_of_week {
    type: count_distinct
    sql: ${complete_date};;
  }

  dimension: requested_after_6_pm  {
    type: yesno
    sql: ${created_hour_of_day} >= 18 ;;
  }

  dimension_group: scheduled {
    type: time
    description: "The local date/time that the care request was scheduled."
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
    sql: ${TABLE}.scheduled_date ;;
  }

  dimension: on_route_decimal {
    description: "The local on-route time of day, represented as a decimal (e.g. 10:15 AM = 10.25"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_route_raw}) AS INT)) +
        ((CAST(EXTRACT(MINUTE FROM ${on_route_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension_group: on_scene {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week_index,
      day_of_month,quarter,
      hour
      ]
    sql: ${TABLE}.on_scene_date ;;
  }

  dimension_group: accept {
    type: time
    description: "The local date/time that the care request was accepted.
                  This is also used as a surrogate for when the care team is assigned."
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
    description: "The date/time that the care request was requested.
                  If scheduled for the next day, this will be the next day date/time
                  stamp of when the office opens.  In these cases, use 'created' date instead"
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
    description: "The on-scene time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension_group: complete {
    type: time
    description: "The local date/time that the care request was completed or
                  resolved/escalated on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_week_index,
      day_of_month,
      quarter
      ]
    sql: ${TABLE}.complete_date ;;
  }

  dimension_group: archive {
    type: time
    description: "The local date/time that the care request was archived or resolved"
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
    sql: ${TABLE}.archive_date ;;
  }

  dimension: scheduled_visit {
    type: yesno
    sql: ${scheduled_date} IS NOT NULL ;;
  }

  measure: scheduled_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: scheduled_visit
      value: "yes"
    }
  }

  dimension_group: complete_resolved {
    type: time
    description: "The complete date or archive date, depending on whether the request was complete or resolved"
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
    sql: CASE
          WHEN ${archive_comment} IS NOT NULL THEN ${archive_raw}
          ELSE ${complete_raw}
         END ;;
  }

  dimension: days_to_complete {
    type: number
    description: "The number of days required to complete or resolve the care request.
                  If null, the request may be scheduled for a day in the future"
    sql: CASE
    WHEN ${complete_raw} IS NOT NULL THEN DATE_PART('day', ${complete_raw}::timestamp) - DATE_PART('day', ${created_raw}::timestamp)
    WHEN ${complete_raw} IS NULL AND ${archive_raw} IS NOT NULL THEN DATE_PART('day', ${archive_raw}::timestamp) - DATE_PART('day', ${created_raw}::timestamp)
    ELSE NULL
    END ;;
  }

  dimension: different_day_complete {
    description: "A flag indicating that the request date was different than completed or resolved date"
    type: yesno
    sql: ${days_to_complete} >= 1 ;;
  }

  dimension_group: shift_start {
    type: time
    description: "The local date/time of a shift start"
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
    sql: ${TABLE}.shift_start_time ;;
  }

  dimension_group: shift_end {
    type: time
    description: "The local date/time of a shift end"
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
    sql: ${TABLE}.shift_end_time ;;
  }

  dimension: shift_hours  {
    type: number
    sql: EXTRACT(EPOCH FROM ${shift_end_raw} - ${shift_start_raw})/3600 ;;
  }

  measure: sum_shift_hours {
    type: sum
    description: "The sum of all scheduled shift hours"
    sql: ${shift_hours} ;;
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
    description: "Today's date/time, given in Mountain time"
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  dimension:  same_day_of_week_on_scene {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${on_scene_day_of_week_index};;
  }

  dimension:  same_day_of_week_created {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${created_day_of_week_index};;
  }

  dimension: until_today_on_scene {
    type: yesno
    sql: ${on_scene_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${on_scene_day_of_week_index} >= 0 ;;
  }

  dimension: until_today_created {
    type: yesno
    sql: ${created_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${created_day_of_week_index} >= 0 ;;
  }

  dimension: this_week_on_scene {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${on_scene_week};;

  }

  dimension: this_week_created {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${created_week};;

  }
  dimension: this_month_on_scene {
    type:  yesno
    sql: ${yesterday_mountain_month} =  ${on_scene_month};;
  }

  dimension: month_to_date_on_scene  {
    type:  yesno
    sql: ${on_scene_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension: month_to_date_created {
    type:  yesno
    sql: ${created_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  measure: distinct_months_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_month}) ;;
  }


  measure: distinct_days_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_date}) ;;
  }

  measure: distinct_days_created {
    type: number
    sql: count(DISTINCT ${created_date}) ;;
  }


  measure: distinct_weeks_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_week}) ;;
  }

  measure: daily_average_complete {
    type: number
    value_format: "0.0"
    sql: ${complete_count}::float/(nullif(${distinct_days_on_scene},0))::float  ;;
  }

  measure: daily_average_created {
    type: number
    value_format: "0.0"
    sql: ${care_request_count}::float/(nullif(${distinct_days_created},0))::float  ;;
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
    sql: round(${monthly_visits_run_rate}-${budget_projections_by_market_clone.sum_projected_visits}) ;;
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
    sql: ${archive_comment} LIKE '%Cancelled by Patient: Going to an Emergency Department%' ;;
  }

  dimension: lwbs_going_to_urgent_care {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: Going to an Urgent Care%' ;;
  }

  dimension: lwbs_wait_time_too_long {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: Wait time too long%' ;;
  }

  dimension: lwbs_no_show {
    type: yesno
    sql: ${archive_comment} LIKE '%No Show%' ;;
  }

  dimension: lwbs_no_longer_need_care {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: No longer need care%' ;;
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

  measure: lwbs_no_longer_need_count {
    type: count_distinct
    description: "Count of care requests where resolve reason is 'No longer need care'"
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs_no_longer_need_care
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

  dimension: escalated_on_phone {
    type: yesno
    sql: ${archive_comment} LIKE '%Referred - Phone Triage%' ;;
  }

  measure: escalated_on_phone_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
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

  dimension: resolved {
    type: yesno
    sql: ${archive_comment} is not null or ${complete_comment} is not null  ;;
  }

  dimension: esclated {
    type: yesno
    sql: ${complete_comment} is not null ;;
  }


  measure: complete_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
  }



  dimension: new_care_request_complete_bool {
    type:  yesno
    sql:  (${care_requests.care_request_patient_create_diff}< (60*60) or ${visit_facts_clone.new_patient}=1)  and  ${complete_date} is not null;;
  }



  measure: complete_count_new {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: new_care_request_complete_bool
      value: "yes"
    }
  }

  measure: care_request_count {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: resolved_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved
      value: "yes"
    }
  }

  measure: complete_rate {
    type: number
    value_format: "0%"
    sql: ${complete_count}::float/nullif(${care_request_count}::float,0) ;;
  }

  measure: month_percent {
    type: number
    sql:

        case when to_char(${max_day_on_scene} , 'YYYY-MM') != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
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

  dimension: complete_month_number {
    type:  number
    sql: EXTRACT(MONTH from ${complete_raw}) ;;
  }

  dimension: days_in_month {
    type: number
    sql:
     case when to_char(${requested_date} , 'YYYY-MM') = ${yesterday_mountain_month} then ${yesterday_mountain_day_of_month}
    else
      DATE_PART('days',
        DATE_TRUNC('month', ${requested_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) end ;;
  }

  dimension: first_half_month {
    type: yesno
    sql: ${complete_day_of_month} <= 15 ;;
  }

  dimension: ga_high_level_category {
    type: string
    label: "Direct to Consumer Category"
    sql: coalesce((case when ${ga_pageviews_clone.high_level_category} = 'Other' then null else ${ga_pageviews_clone.high_level_category} end), ${web_ga_pageviews_clone.high_level_category}) ;;
  }


  dimension: ga_projections_category {
    type: string
    label: "Projections Direct to Consumer Category"
    sql: coalesce((case when ${ga_pageviews_clone.projection_category} = 'Other' then null else ${ga_pageviews_clone.projection_category} end), ${web_ga_pageviews_clone.projection_category}) ;;
  }

  dimension: ga_intent {
    type: string
    label: "High/Low Intent"
    sql: coalesce(${ga_pageviews_clone.high_low_intent}, ${web_ga_pageviews_clone.high_low_intent}) ;;
  }

  dimension: diversion_category {
    type: string
    sql: CASE
      WHEN ${complete_time} IS NULL THEN 'not completed'
      WHEN ${visit_facts_clone.day_30_followup_outcome} IN ( 'ed_same_complaint', 'hospitalization_same_complaint' )
        OR
        ${visit_facts_clone.day_14_followup_outcome} IN( 'ed_same_complaint', 'hospitalization_same_complaint' )
        OR
        ${visit_facts_clone.day_3_followup_outcome} IN( 'ed_same_complaint', 'hospitalization_same_complaint') THEN 'ed_same_complaint'
      WHEN lower(${cars.name}) = lower('SMFR_Car') THEN
        'smfr'
      WHEN lower(${channel_items.type_name}) IN( 'home health',
                          'snf',
                          'provider group' ) THEN lower(${channel_items.type_name})
      WHEN lower(${channel_items.type_name}) = 'senior care'
        AND
        ${on_scene_hour_of_day} < 15
        AND
       ${on_scene_day_of_week_index} NOT IN ( 1,
                                               7 ) THEN 'senior care - weekdays before 3pm'
      WHEN lower(${channel_items.type_name})  = 'senior care'
        AND
        (
          ${on_scene_hour_of_day} > 15
          OR
            ${on_scene_day_of_week_index} IN ( 1,7 )
        )
        THEN 'senior care - weekdays after 3pm and weekends'
      WHEN ${ed_diversion_survey_response_clone.answer_selection_value} = 'Emergency Room' THEN 'survey responded emergency room'
      WHEN ${ed_diversion_survey_response_clone.answer_selection_value} != 'Emergency Room'
        AND
        ${ed_diversion_survey_response_clone.answer_selection_value} IS NOT NULL THEN 'survey responded not emergency room'
      WHEN ${ed_diversion_survey_response_clone.answer_selection_value} IS NULL THEN
        'no survey'
      ELSE 'other'
      END;;
  }

  dimension: ed_diversion {
    label: "ED Diversion"
    type: number
    sql:  CASE
      WHEN ${diversion_category} = 'ed_same_complaint' THEN  0.0
      WHEN ${diversion_category} = 'not completed' THEN 0.0
      WHEN ${diversion_category} = 'smfr' THEN  1.0
      WHEN ${diversion_category} = 'home health' THEN  .9
      WHEN ${diversion_category} = 'snf' THEN 1.0
      WHEN ${diversion_category} = 'provider group' THEN .5
      WHEN ${diversion_category} = 'senior care - weekdays before 3pm' THEN .5
      WHEN ${diversion_category} = 'senior care - weekdays after 3pm and weekends' THEN  1.0
      WHEN ${diversion_category} = 'survey responded emergency room' THEN   1.0
      WHEN ${diversion_category} = 'survey responded not emergency room' THEN  0.0
      WHEN ${diversion_category} = 'no survey' THEN ${ed_diversion_survey_response_rate_clone.er_percent}
        ELSE 0.0
      END ;;
  }

  dimension: 911_diversion {
    type: number
    sql:  CASE
      WHEN ${diversion_category} = 'smfr' THEN 1.0
      WHEN ${diversion_category} = 'home health' THEN .5
      WHEN ${diversion_category} = 'snf' THEN 1.0
      WHEN ${diversion_category} = 'senior care - weekdays before 3pm' THEN  .5
      WHEN ${diversion_category} = 'senior care - weekdays after 3pm and weekends' THEN  1.0
        ELSE 0.0
      END;;
  }


  measure: est_vol_ed_diversion {
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    value_format: "#,##0"
    sql: ${ed_diversion};;

  }


  measure: est_vol_911_diversion {
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    value_format: "#,##0"
    sql: ${911_diversion};;

  }

  measure: est_ed_diversion_savings {
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    sql: ${ed_diversion} * 2000;;

  }

  measure: est_911_diversion_savings {
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    sql: ${911_diversion} * 750;;

  }

  measure: est_diversion_savings {
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    value_format: "$#,##0"
    sql: ${911_diversion} * 750 + ${ed_diversion} * 2000;;

  }





}

view: care_request_flat_user {
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
        min(accept1.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date_initial,
        max(accept.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date,
        max(schedule.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS scheduled_date,
        max(onroute.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_route_date,
        max(onscene.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_scene_date,
        MIN(comp.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS complete_date,
        MIN(archive.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS archive_date,
        fu3.comment AS followup_3day_result,
        fu14.comment AS followup_14day_result,
        fu30.comment AS followup_30day_result,
        accept1.auto_assigned AS auto_assigned_initial,
        accept1.reassignment_reason AS reassignment_reason_initial,
        accept1.reassignment_reason_other AS reassignment_reason_other_initial,
        accept.auto_assigned AS auto_assigned_final,
        accept.reassignment_reason AS reassignment_reason_final,
        accept.reassignment_reason_other AS reassignment_reason_other_final,
        accept.drive_time_seconds,
        accept.first_name AS accept_employee_first_name,
        accept.last_name AS accept_employee_last_name,
        case when array_to_string(array_agg(distinct comp.comment), ':') = '' then null
        else array_to_string(array_agg(distinct comp.comment), ':')end
        as complete_comment,
        case when array_to_string(array_agg(distinct archive.comment), ':') = '' then null
        else array_to_string(array_agg(distinct archive.comment), ':') end
        as archive_comment,
        case when array_to_string(array_agg(distinct notes.note), ':') = '' then null
        else array_to_string(array_agg(distinct notes.note), ':')end
        as reorder_reason,
        cr.shift_team_id,
        min(to_date(schedule.comment, 'DD Mon YYYY')) as scheduled_care_date,
        insurances.package_id
      FROM care_requests cr
      LEFT JOIN care_request_statuses AS request
      ON cr.id = request.care_request_id AND request.name = 'requested' and request.deleted_at is null
      LEFT JOIN care_request_statuses schedule
      ON cr.id = schedule.care_request_id AND schedule.name = 'scheduled'  and schedule.deleted_at is null

      LEFT JOIN
        (SELECT care_request_id,
        name,
        started_at,
        meta_data::json->> 'auto_assigned' AS auto_assigned,
        reassignment_reason,
        reassignment_reason_other,
        ROW_NUMBER() OVER(PARTITION BY care_request_id
                                ORDER BY started_at) AS rn
        FROM care_request_statuses

        WHERE name = 'accepted' AND deleted_at IS NULL) AS accept1
      ON cr.id = accept1.care_request_id AND accept1.rn = 1
      LEFT JOIN public.notes
      ON notes.care_request_id = cr.id
      AND notes.note_type = 'reorder_reason'

      LEFT JOIN (SELECT care_request_id,
        name,
        crs.started_at,
        meta_data::json->> 'auto_assigned' AS auto_assigned,
        meta_data::json->> 'drive_time' AS drive_time_seconds,
        reassignment_reason,
        reassignment_reason_other,
        ROW_NUMBER() OVER(PARTITION BY care_request_id
                                ORDER BY crs.started_at DESC) AS rn,
        first_name,
        last_name
        FROM care_request_statuses crs
        LEFT JOIN users
        ON crs.user_id = users.id
        WHERE name = 'accepted' AND crs.deleted_at IS NULL) AS accept
      ON cr.id = accept.care_request_id AND accept.rn = 1

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
      left join(select  care_requests.id as care_request_id, package_id,  ROW_NUMBER() OVER(PARTITION BY care_requests.id
                                ORDER BY insurances.created_at desc) as rn
        FROM care_requests
        join public.patients
        on patients.id=care_requests.patient_id
        join public.insurances
        on care_requests.patient_id = insurances.patient_id AND insurances.priority = '1'
        AND insurances.patient_id IS NOT NULL
        and care_requests.created_at + interval '1' day >= insurances.created_at
        and insurances.package_id is not null
        and trim(insurances.package_id)!='') as insurances
        ON cr.id = insurances.care_request_id AND insurances.rn = 1


      GROUP BY 1,2,3,15,16,17,18,19,20,21,22,23,24,25,26, insurances.package_id ;;

      sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
      indexes: ["care_request_id"]
    }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
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
      year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      month_num,
      quarter
    ]
    sql: ${TABLE}.created_date ;;
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
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour
    ]
    sql: ${TABLE}.on_scene_date ;;
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
      quarter,
      month_num,
      year
    ]
    sql: ${TABLE}.complete_date ;;
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

  dimension: market_id {
    type: number
    hidden: yes
    sql: ${TABLE}.market_id ;;
  }

  dimension: archive_comment {
    type: string
    hidden: yes
    description: "The CSC comment provided when a care request is archived"
    sql: ${TABLE}.archive_comment ;;
  }

  dimension: complete_comment {
    type: string
    hidden: yes
    sql: ${TABLE}.complete_comment ;;
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
    sql: trim(split_part(${resolved_reason_full}, ':', 1)) ;;
    drill_fields: [secondary_resolved_reason]
  }

  dimension: secondary_resolved_reason {
    type:  string
    sql: CASE
          WHEN ${resolved_reason_full} LIKE '%Spoke to my family doctor%'
          THEN 'Spoke to my Family Doctor'
          ELSE trim(split_part(${resolved_reason_full}, ':', 2))
        END ;;
  }

  dimension: primary_and_secondary_resolved_reason {
    type: string
    sql: concat(${primary_resolved_reason},': ', ${secondary_resolved_reason}) ;;
  }


  dimension: other_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 3)) ;;
  }


  dimension: escalated_on_scene {
    type: yesno
    sql: UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
      ${primary_resolved_reason} = 'Referred - Point of Care';;
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
    value_format: "0.00"
  }

  dimension: is_reasonable_drive_time {
    type: yesno
    hidden: yes
    sql: ${drive_time_seconds} > 299 AND ${drive_time_seconds} < 14401;;
  }

  dimension: is_reasonable_in_queue_time {
    type: yesno
    hidden: yes
    sql: ${in_queue_time_minutes} < 720  ;;
  }

  dimension: is_reasonable_assigned_time {
    type: yesno
    hidden: yes
    sql: ${assigned_time_minutes} < 720  ;;
  }

  dimension: is_reasonable_on_scene_time {
    type: yesno
    hidden: yes
    sql: ${on_scene_time_seconds} > 299 AND ${on_scene_time_seconds} < 14401 ;;
  }

  dimension: in_queue_time_minutes {
    type: number
    description: "The number of minutes between requested time and accepted time"
    sql: (EXTRACT(EPOCH FROM ${accept_raw})-EXTRACT(EPOCH FROM ${created_raw}))::float/60.0 ;;
    value_format: "0.00"
  }

  dimension: drive_time_minutes {
    type: number
    description: "The number of minutes between on-route time and on-scene time"
    sql: (EXTRACT(EPOCH FROM ${on_scene_raw})-EXTRACT(EPOCH FROM ${on_route_raw}))::float/60.0 ;;
  }

  dimension: drive_time_minutes_google {
    type: number
    sql: ${TABLE}.drive_time_seconds::float / 60.0 ;;
    value_format: "0.00"
  }

  measure:  average_drive_time_minutes_google {
    type: average_distinct
    description: "The average drive time from Google in minutes"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes_google} ;;
  }

  dimension: assigned_time_minutes {
    type: number
    description: "The number of minutes between accepted time and on-route time"
    sql: (EXTRACT(EPOCH FROM ${on_route_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0;;
    value_format: "0.00"
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
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
  }

  measure:  average_assigned_time_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and on-route time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${assigned_time_minutes} ;;
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
  }

  measure:  average_on_scene_time_minutes{
    type: average_distinct
    description: "The average minutes between complete time and on scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${on_scene_time_minutes} ;;
    filters: {
      field: is_reasonable_on_scene_time
      value: "yes"
    }
  }

  measure:  total_on_scene_time_minutes{
    type: sum_distinct
    description: "The sum of minutes between complete time and on scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${on_scene_time_minutes} ;;
    filters: {
      field: is_reasonable_on_scene_time
      value: "yes"
    }
  }


}

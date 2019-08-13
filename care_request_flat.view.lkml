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
        min(accept1.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date_initial,
        max(accept.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date,
        max(schedule.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS scheduled_date,
        max(onroute.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_route_date,
        max(onscene.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_scene_date,
        MIN(coalesce(comp.started_at, esc.started_at)) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS complete_date,
        MIN(archive.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS archive_date,
        fu3.comment AS followup_3day_result,
        fu3.commentor_id AS followup_3day_id,
        fu3.updated_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS day3_followup_date,
        fu14.comment AS followup_14day_result,
        fu30.comment AS followup_30day_result,
        accept1.auto_assigned AS auto_assigned_initial,
        accept1.reassignment_reason AS reassignment_reason_initial,
        accept1.reassignment_reason_other AS reassignment_reason_other_initial,
        accept1.drive_time_seconds AS drive_time_seconds_initial,
        accept1.shift_team_id_initial,
        cars.name AS shift_team_initial,
        accept.auto_assigned AS auto_assigned_final,
        accept.reassignment_reason AS reassignment_reason_final,
        accept.reassignment_reason_other AS reassignment_reason_other_final,
        accept.drive_time_seconds,
        accept.first_name AS accept_employee_first_name,
        accept.last_name AS accept_employee_last_name,
        accept.eta_time::timestamp AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS eta_date,
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
        insurances.package_id,
        callers.origin_phone,
        callers.contact_id,
        cr.patient_id as patient_id,
        foc.first_on_scene_time
      FROM care_requests cr
      LEFT JOIN care_request_statuses AS request
      ON cr.id = request.care_request_id AND request.name = 'requested' and request.deleted_at is null
      LEFT JOIN care_request_statuses schedule
      ON cr.id = schedule.care_request_id AND schedule.name = 'scheduled'  and schedule.deleted_at is null
      LEFT JOIN
      (SELECT
       cr.patient_id,
       MIN(crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz) AS first_on_scene_time
       FROM
         care_requests cr
         JOIN care_request_statuses crs
           ON cr.id = crs.care_request_id
         LEFT JOIN markets m
           ON cr.market_id = m.id
         LEFT JOIN looker_scratch.timezones t
           ON m.sa_time_zone = t.rails_tz
         WHERE crs.name = 'on_scene'
         GROUP BY cr.patient_id) foc
    ON cr.patient_id = foc.patient_id
      LEFT JOIN
        (SELECT care_request_id,
        name,
        started_at,
        meta_data::json->> 'auto_assigned' AS auto_assigned,
        meta_data::json->> 'drive_time' AS drive_time_seconds,
        meta_data::json->> 'shift_team_id' AS shift_team_id_initial,
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
        meta_data::json->> 'eta' AS eta_time,
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
      LEFT JOIN care_request_statuses esc
      ON cr.id = esc.care_request_id AND esc.name = 'archived' and esc.deleted_at is null
      and lower(esc.comment) like '%referred - point of care%'
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
      LEFT JOIN public.shift_teams st_init
      ON st_init.id::int = accept1.shift_team_id_initial::int
      LEFT JOIN cars
      ON st_init.car_id = cars.id
      JOIN markets
      ON cr.market_id = markets.id
      JOIN looker_scratch.timezones AS t
      ON markets.sa_time_zone = t.rails_tz
      LEFT join callers
      on callers.id = cr.caller_id
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
      GROUP BY 1,2,3,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,
               insurances.package_id, callers.origin_phone, callers.contact_id,cr.patient_id, foc.first_on_scene_time;;

    sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
    indexes: ["care_request_id", "patient_id", "origin_phone", "created_date", "on_scene_date", "complete_date"]
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: self_report_primary_package_id {
    type: number
    sql: ${TABLE}.package_id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: origin_phone {
    type: string
    sql: ${TABLE}.origin_phone ;;
  }

  dimension: contact_id {
    type: string
    sql:
    case
          when ${TABLE}.contact_id  ='' then null
          else ${TABLE}.contact_id
         end;;
  }

  measure: complete_count_seasonal_adj {
    type: number
    value_format: "#,##0"
    sql: (${complete_count}/${seasonal_adj.seasonal_adj})/${days_in_month_adj.days_in_month_adj} ;;
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

  dimension: created_to_resolved_minutes {
    type: number
    description: "The number of minutes between created time and archived time"
    sql: (EXTRACT(EPOCH FROM ${archive_raw})-EXTRACT(EPOCH FROM ${created_raw}))::float/60.0 ;;
    value_format: "0.00"
  }

  dimension: accepted_to_resolved_minutes {
    type: number
    description: "The number of minutes between accepted time and archived time"
    sql: CASE
          WHEN ABS((EXTRACT(EPOCH FROM ${archive_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0) < 241
          THEN (EXTRACT(EPOCH FROM ${archive_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0
          ELSE NULL
        END ;;
    value_format: "0.00"
  }

  dimension: created_to_on_scene_minutes {
    type: number
    description: "The number of minutes between care request created time and on scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw})/60 -EXTRACT(EPOCH FROM ${created_raw})/60 ;;
  }

  dimension: on_scene_time_tier {
    type: tier
    tiers: [10,20,30,40,50,60,70,80,90,100]
    style: integer
    sql: ${on_scene_time_minutes} ;;
  }

  dimension: shift_team_id_initial {
    type: number
    description: "The shift team ID of the team initially assigned to the care request"
    sql: ${TABLE}.shift_team_id_initial ;;
  }

  dimension: shift_team_initial {
    type: string
    description: "The name of the shift initially assigned to the care request"
    sql: ${TABLE}.shift_team_initial ;;
  }

  measure: app_months_of_experience {
    type: number
    sql: date_part('year', age(${app_shift_planning_facts_clone.first_shift_date}::date))*12 +
         date_part('month', age(${app_shift_planning_facts_clone.first_shift_date}::date)) ;;
    #date_part('month',age('2010-04-01', '2012-03-05'))
  }

  dimension: on_scene_time_30min_or_less {
    type: yesno
    description: "A flag indicating the on scene time was less than 30 minutes"
    sql: ${on_scene_time_minutes} < 30.0 ;;
  }

  dimension: post_logistics_flag {
    type: yesno
    description: "A flag indicating the logistics platform was put into production"
    sql: (${market_id} IN (160, 162, 165, 166) AND ${created_date} >= '2018-06-27') OR
         (${market_id} = 161 AND ${created_date} >= '2018-07-30') OR
         (${market_id} = 159 AND ${created_date} >= '2018-07-31') OR
         (${created_date} >= '2018-08-07') ;;
  }

  dimension: post_cc_fix_date {
    type: yesno
    description: "A flag indicating a credit card fix was put into production (06/22/2018)"
    sql: ${complete_date} >= '2018-06-22' ;;
  }

  dimension: auto_assigned_initial {
    type: string
    description: "A flag indicating the care request was initially auto-assigned"
    sql: ${TABLE}.auto_assigned_initial ;;
  }

  dimension: reassignment_reason_initial {
    type: string
    description: "The initial reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_initial ;;
  }

  dimension: auto_assignment_overridden {
    type: yesno
    sql: ${auto_assigned_initial} = 'true' AND ${auto_assigned_final} = 'false' ;;
  }

  dimension: reassignment_reason_other_initial {
    type: string
    description: "The secondary initial reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_other_initial ;;
  }

  dimension: auto_assigned_final {
    type: string
    description: "A flag indicating the care request was auto-assigned (String)"
    sql: ${TABLE}.auto_assigned_final ;;
  }

  dimension: auto_assigned_flag {
    type: yesno
    description: "A flag indicating the care request was auto-assigned (Boolean)"
    sql: ${TABLE}.auto_assigned_final = 'true' ;;
  }

  dimension: reassignment_reason_final {
    type: string
    description: "The reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_final ;;
  }

  dimension: reassignment_reason_other_final {
    type: string
    description: "The reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_other_final ;;
  }

  dimension: drive_time_minutes {
    type: number
    description: "The number of minutes between on-route time and on-scene time"
    sql: (EXTRACT(EPOCH FROM ${on_scene_raw})-EXTRACT(EPOCH FROM ${on_route_raw}))::float/60.0 ;;
  }

  dimension: drive_time_seconds_google {
    type: number
    sql: ${TABLE}.drive_time_seconds ;;
  }

  dimension: drive_time_minutes_google {
    type: number
    sql: ${TABLE}.drive_time_seconds::float / 60.0 ;;
    value_format: "0.00"
  }

  dimension: initial_drive_time_minutes_google {
    description: "The Google drive time of the care team that was initially assigned"
    type: number
    sql: ${TABLE}.drive_time_seconds_initial::float / 60.0 ;;
    value_format: "0.00"
  }

  dimension: google_drive_time_tier {
  type: tier
  tiers: [0,5,10,15,20,25,30,35,40,45,50]
  style: integer
  sql: ${drive_time_minutes_google} ;;
  }

  measure:  average_drive_time_minutes_google {
    type: average_distinct
    description: "The average drive time from Google in minutes"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes_google} ;;
  }

  measure: total_drive_time_minutes_google {
    type: sum_distinct
    description: "The sum of drive time from Google in minutes"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes_google} ;;
  }

  dimension: under_20_minute_drive_time {
    type: yesno
    sql: ${drive_time_minutes_google} <= 20.0 ;;
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
    value_format: "0.00"
  }

  dimension: is_reasonable_in_queue_time {
    type: yesno
    hidden: yes
    sql: ${in_queue_time_minutes} < 240  ;;
  }

  dimension: assigned_time_minutes {
    type: number
    description: "The number of minutes between accepted time and on-route time"
    sql: (EXTRACT(EPOCH FROM ${on_route_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0;;
    value_format: "0.00"
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

  dimension: accept_employee_first_name {
    description: "The first name of the user who accepted the patient"
    type: string
    sql: ${TABLE}.accept_employee_first_name ;;
  }

  dimension: accept_employee_last_name {
    description: "The last name of the user who accepted the patient"
    type: string
    sql: ${TABLE}.accept_employee_last_name ;;
  }

  dimension: accepted_patient {
    type: yesno
    hidden: yes
    sql: ${accept_date} IS NOT NULL ;;
  }

  measure: count_accepted_patients {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: accepted_patient
      value: "yes"
    }
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
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
  }

  measure:  average_assigned_time_seconds{
    type: average_distinct
    description: "The average seconds between between accepted time and on-route time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${assigned_time_seconds} ;;
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
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

  measure:  median_drive_time_minutes{
    type: median_distinct
    description: "The median number of minutes between on-route time and on-scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes} ;;
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

  measure:  average_created_to_resolved_minutes{
    type: average_distinct
    description: "The average minutes between created time and archive time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${created_to_resolved_minutes} ;;
  }

  measure:  average_accepted_to_initial_eta_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and initial ETA"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${accepted_to_initial_eta_minutes} ;;
  }

  measure:  average_created_to_on_scene_minutes{
    type: average_distinct
    description: "The average minutes between created time and on on-scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${created_to_on_scene_minutes} ;;
  }

  measure: average_accepted_to_resolved_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and Resolved Time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${accepted_to_resolved_minutes} ;;
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

  measure: average_wait_time_total_pre_logistics {
    description: "Total patient wait time: the average minutes between requested time and on-scene time"
    type: average_distinct
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_seconds} + ${assigned_time_seconds} + ${drive_time_seconds} ;;
    filters: {
      field: auto_assigned_flag
      value: "no"
    }
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
  }

  measure: average_wait_time_total_post_logistics {
    description: "Total patient wait time: the average minutes between requested time and on-scene time"
    type: average_distinct
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_seconds} + ${assigned_time_seconds} + ${drive_time_seconds} ;;
    filters: {
      field: auto_assigned_flag
      value: "yes"
    }
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
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

  dimension: reorder_reason {
    type: string
    description: "The reorder reason"
    sql: ${TABLE}.reorder_reason ;;
  }

  dimension: reassigned_or_reordered {
    type: yesno
    description: "A flag indicating the care request was reassigned OR re-ordered"
    sql: ${reassignment_reason_other_final} IS NOT NULL OR ${reorder_reason} IS NOT NULL ;;
  }

  dimension: reordered_visit {
    type: yesno
    sql: ${reorder_reason} IS NOT NULL ;;
  }

  measure: count_reordered_care_requests {
    description: "Count of care requests that were reordered by CSC"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: reordered_visit
      value: "yes"
    }
  }

  measure: count_reassigned_reordered_care_requests {
    description: "Count of care requests that were reassigned or reordered by CSC"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: reassigned_or_reordered
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
  }

  dimension: complete_comment {
    type: string
    sql: ${TABLE}.complete_comment ;;
  }

  dimension: followup_3day_result {
    type: string
    description: "The 3-day follow-up call result"
    sql: TRIM(${TABLE}.followup_3day_result) ;;
  }

  dimension: followup_3day {
    type: yesno
    description: "A flag indicating the 3-day follow-up call was completed"
    sql: ${complete_date} IS NOT NULL AND
    ${followup_3day_result} is NOT NULL AND ${followup_3day_result} != 'patient_called_but_did_not_answer' ;;
  }

  dimension: followup_3day_id {
    type: number
    sql: ${TABLE}.followup_3day_id ;;
  }

  dimension_group: day3_followup {
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
    sql: ${TABLE}.day3_followup_date ;;
  }

  dimension_group: eta {
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
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.eta_date ;;
  }

  dimension: bounceback_3day {
    type: yesno
    sql: ${followup_3day_result} LIKE '%same_complaint%' ;;
  }

  dimension: followup_14day_result {
    type: string
    description: "The 14-day follow-up result"
    sql: TRIM(${TABLE}.followup_14day_result) ;;
  }

  dimension: bounceback_14day {
    type: yesno
    sql: ${followup_14day_result} LIKE '%same_complaint%' OR ${bounceback_3day} ;;
  }


  dimension: bb_14_day_in_sample {
    label: "14-Day Bounce back flag, removing any bouncebacks without a 30 day followup"
    type: yesno
    sql: ((${bounceback_3day} AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)
         OR ${followup_14day_result} = 'ed_same_complaint' OR ${followup_14day_result} = 'hospitalization_same_complaint')
      AND ${followup_3day_result} != 'REMOVED';;
  }

  measure: bb_14_day_count_in_sample {
    label: "14-Day Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bb_14_day_in_sample
      value: "yes"
    }
  }

  dimension: followup_30day_result {
    type: string
    description: "The 30-day follow-up result"
    sql: TRIM(${TABLE}.followup_30day_result) ;;
  }

  dimension: followup_30day {
    type: yesno
    description: "A flag indicating the 14/30-day follow-up was completed"
    sql: ${complete_date} IS NOT NULL AND
    ((${followup_30day_result} IS NOT NULL AND ${followup_30day_result} != 'no_hie_data') OR
    ${bounceback_3day} OR ${bounceback_14day}) ;;
  }

  # Add 3 or 30 day followup measures
  dimension: followup_3day_or_30day {
    type: yesno
    description: "A flag indicating that either the 3 or 30-day follow-up was completed"
    sql: ${complete_date} IS NOT NULL AND
          (${followup_30day_result} IS NOT NULL AND ${followup_30day_result} != 'no_hie_data') OR
          (${followup_3day}) ;;
  }

  measure: count_3_or_30day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_3day_or_30day
      value: "yes"
    }
  }
  # End 3 or 30 day followup measures

  dimension: bb_30_day_in_sample {
    label: "30-Day Bounce back flag, removing any bouncebacks without a 30 day followup"
    type: yesno
    sql: (((${bounceback_3day} OR ${bounceback_14day}) AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)
         OR ${followup_30day_result} = 'ed_same_complaint' OR ${followup_30day_result} = 'hospitalization_same_complaint')
      AND ${followup_3day_result} != 'REMOVED';;
  }

  measure: bb_30_day_count_in_sample {
    label: "30-Day Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bb_30_day_in_sample
      value: "yes"
    }
  }

  dimension: no_hie_data {
    type: yesno
    sql: ${complete_date} IS NOT NULL AND (${followup_14day_result} = 'no_hie_data' OR ${followup_30day_result} = 'no_hie_data') ;;
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

  dimension_group: drive_start {
    type: time
    description: "The on-scene date and time minus the Google drive time"
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
    sql: ${on_scene_raw} - (${drive_time_seconds_google}::int * INTERVAL '1' second) ;;
  }

  dimension_group: scheduled_care {
    type: time
    description: "The date where we are trying to complete a scheduled care_request"
    convert_tz: no
    timeframes: [
      raw,
      date,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.scheduled_care_date ;;
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

  dimension_group: scheduled_care_created_coalese {
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
    sql: coalesce(case when ${pafu_or_follow_up} then ${scheduled_care_raw} else null end, ${created_raw}) ;;
  }

  measure: count_distinct_days_created {
    type: count_distinct
    sql_distinct_key: ${created_date} ;;
    sql: ${created_date} ;;

  }

  measure: distinct_days_scheduled_care_created_coalese_date {
    type: count_distinct
    sql_distinct_key: ${scheduled_care_created_coalese_date} ;;
    sql: ${scheduled_care_created_coalese_date} ;;

  }

  measure: count_distinct_days_accepted {
    type: count_distinct
    sql_distinct_key: ${accept_date} ;;
    sql: ${accept_date} ;;

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
    description: "The local on-route time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_route_raw}) AS INT)) +
        ((CAST(EXTRACT(MINUTE FROM ${on_route_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: drive_start_decimal {
    description: "The Google on-route time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${drive_start_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${drive_start_raw} ) AS FLOAT)) / 60) ;;
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
      hour,
      year
      ]
    sql: ${TABLE}.on_scene_date ;;
  }

  dimension_group: first_visit {
    type: time
    description: "The first local date/time that the patient was seen by DispatchHealth"
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
      day_of_month,
      quarter,
      hour,
      year
    ]
    sql: ${TABLE}.first_on_scene_time ;;
  }

  dimension: within_30_days_first_visit {
    type: yesno
    description: "A flag indicating that the visit is within 30 days of the first visit"
    sql: ${on_scene_raw} <= ${first_visit_raw} + interval '30 day' ;;
  }

  dimension: first_visit_pafu {
    type: yesno
    description: "A flag indicating that the first visit is a post-acute follow up"
    sql: ${first_visit_raw} IS NOT NULL AND ${care_requests.post_acute_follow_up} ;;
  }


  dimension: first_half_of_month_on_scene {
    type: yesno
    sql: ${on_scene_day_of_month} <= 15 ;;
  }

  dimension: pg_tz {
    type: string
    sql: ${TABLE}.pg_tz ;;
  }

  dimension_group: on_scene_mountain {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
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
    sql: ${TABLE}.on_scene_date AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: accept_mountain {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
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
    sql: ${TABLE}.accept_date AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: created_mountain {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
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
    sql: ${TABLE}.created_date AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
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
      day_of_month,
      day_of_week
    ]
    sql: ${TABLE}.accept_date ;;
  }

  dimension_group: accept_initial {
    type: time
    description: "The local date/time that the care request was first accepted.
                  If an auto assignment is overridden this will be different than accept date."
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
    sql: ${TABLE}.accept_date_initial ;;
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

  dimension: requested_rounded_integer {
    description: "The requested visit time of day, represented as a rounded decimal (e.g. 10:15 AM = 10)"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${requested_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${requested_raw} ) AS FLOAT)) / 60)) ;;
      value_format: "0"
  }


  dimension: on_scene_decimal {
    description: "The on-scene time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: on_scene_rounded_integer {
    description: "The on-scene time of day, represented as a decimal (e.g. 10:15 AM = 10)"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60)) ;;
      value_format: "0"
  }

  dimension: accepted_decimal {
    description: "The accepted time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${accept_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accept_raw} ) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  dimension: accepted_rounded_integer {
    description: "The accepted time of day, represented as a rounded decimal (e.g. 10:15 AM = 10)"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${accept_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accept_raw} ) AS FLOAT)) / 60)) ;;
    value_format: "0"
  }

  measure: first_accepted_decimal {
    description: "The first accepted time of day, represented as a decimal"
    type: min
    sql: ${accepted_decimal} ;;
    value_format: "0.00"
  }

  dimension: shift_start_decimal {
    description: "The shift start time of day, represented as a decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${shift_start_raw}) AS INT)) +
    ((CAST(EXTRACT(MINUTE FROM ${shift_start_raw}) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  dimension: shift_end_decimal {
    description: "The shift start time of day, represented as a decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${shift_end_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${shift_end_raw}) AS FLOAT)) / 60) ;;
    value_format: "0.00"
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

  dimension: weekday_complete {
    type: string
    description: "A flag indicating the complete date is during the week"
    sql: CASE WHEN ${complete_day_of_week_index} IN (0,1,2,3,4) THEN 'Weekday'
            WHEN ${complete_day_of_week_index} IN (5,6) THEN 'Weekend'
            ELSE NULL END;;
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

  dimension: eta_to_on_scene_resolved_minutes  {
    type: number
    description: "The number of minutes between the initial ETA and either the on-scene or resolved time"
    sql: EXTRACT(EPOCH FROM COALESCE(${on_scene_raw},${archive_raw}) - ${eta_raw})/60 ;;
  }

  dimension: accepted_to_initial_eta_minutes  {
    type: number
    description: "The number of minutes between when the care request was created and the initial ETA"
    sql: ROUND(CAST(EXTRACT(EPOCH FROM ${eta_raw} - ${accept_raw})/60 AS integer), 0) ;;
    value_format: "0"
  }

  dimension: mins_early_late_tier {
    type: tier
    tiers: [-60, -45, -30, -15, 0, 10, 15, 30, 45, 60]
    style: integer
    sql: ${eta_to_on_scene_resolved_minutes} ;;
  }

  dimension: mins_to_eta_tier {
    type: tier
    description: "The grouped number of minutes between accepted and ETA"
    tiers: [30, 60, 90, 120, 150, 180, 210, 240]
    style: integer
    sql: ${accepted_to_initial_eta_minutes} ;;
  }

  dimension: mins_to_eta_tier_wide {
    type: tier
    description: "The grouped number of minutes between accepted and ETA"
    tiers: [60, 120, 180, 240]
    style: integer
    sql: ${accepted_to_initial_eta_minutes} ;;
  }

  dimension: eta_150_mins_or_less {
    type: yesno
    description: "The accept to ETA time is 150 minutes or less"
    sql: ${accepted_to_initial_eta_minutes} <= 150 ;;
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
      day_of_week,
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

  dimension: end_of_shift_dead_time {
    type: number
    description: "The number of hours between last updated and shift end"
    sql: (EXTRACT(EPOCH FROM ${shift_end_raw}) - EXTRACT(EPOCH FROM ${shifts_end_of_shift_times.last_update_time_raw}))/3600 ;;
    value_format: "0.00"
  }

  dimension: end_of_shift_dead_time_45_mins {
    type: yesno
    description: "A flag indicating that the end of shift dead time > 45 minutes"
    sql: ${end_of_shift_dead_time} >= 0.75 ;;
  }

measure: sum_end_of_shift_dead_time {
  type: sum
  description: "A sum of end of shift dead time from last updated to shift end"
  sql: ${end_of_shift_dead_time} ;;
}

measure:  count_end_of_shift_dead_time_45_mins {
  type:  count_distinct
  description: "count of shifts where the end of shift dead time > 45 minutes"
  sql: ${care_requests.shift_team_id}  ;;
  filters: {
    field: end_of_shift_dead_time_45_mins
    value: "yes"
  }
}


  dimension: shift_team_id  {
    type: number
    sql:${TABLE}.shift_team_id ;;
  }


  measure: sum_shift_hours {
    type: sum
    description: "The sum of all scheduled shift hours"
    sql: ${shift_hours} ;;
  }

  measure: sum_distinct_shift_hours {
    type: sum_distinct
    description: "The sum of each scheduled shift hours"
    sql: ${shift_hours} ;;
    #sql_distinct_key: ${cars.name} ;;
    sql_distinct_key: ${care_requests.shift_team_id} ;;
  }

  measure: max_complete_time {
    label: "Last Care Request Completion Time"
    type: date_time
    sql:  MAX(${complete_raw}) ;;
  }

  dimension: created_decimal {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT)) / 60) ;;
      value_format: "0.00"
  }

  dimension: created_rounded_integer {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT)) / 60)) ;;
    value_format: "0"
  }

  dimension: complete_decimal {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: complete_resolved_decimal {
    description: "Complete or Resolved Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${complete_resolved_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_resolved_raw} ) AS FLOAT)) / 60) ;;
      value_format: "0.00"
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
    value_format: "0.00"
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

  dimension:  same_day_of_week_created_today {
    type: yesno
    sql:  ${today_mountain_day_of_week_index} = ${created_day_of_week_index};;
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

  dimension: month_to_date_created_two_days{
    type:  yesno
    sql: ${created_day_of_month} <= (${yesterday_mountain_day_of_month}-1) ;;
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
    value_format: "0.0"
    sql: ${complete_count}/(nullif(${distinct_weeks_on_scene},0))::float  ;;
  }

  measure: monthly_average_complete {
    type: number
    value_format: "0.0"
    sql: ${complete_count}/(nullif(${distinct_months_on_scene},0))::float ;;
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

  dimension: escalation_type {
    type: string
    sql: CASE
          WHEN UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
          ${primary_resolved_reason} = 'Referred - Point of Care' THEN 'Escalated On Scene'
          WHEN ${archive_comment} LIKE '%Referred - Phone Triage%' THEN 'Escalated Over Phone'
          ELSE NULL
         END ;;
  }


  dimension: escalated_on_scene {
    type: yesno
    sql: UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
    ${primary_resolved_reason} = 'Referred - Point of Care';;
  }

  dimension: lwbs_going_to_ed {
    type: yesno
    sql: ${archive_comment} SIMILAR TO '%(Cancelled by Patient: Going to an Emergency Department|Going to Emergency Department)%' ;;
  }

  dimension: lwbs_going_to_urgent_care {
    type: yesno
    sql: LOWER(${archive_comment}) SIMILAR TO '%(going to an urgent care|going to urgent care)%' ;;
  }

  dimension: lwbs_wait_time_too_long {
    type: yesno
    sql: LOWER(${archive_comment}) LIKE '%wait time too long%' ;;
  }

  dimension: lwbs_going_to_pcp {
    type: yesno
    sql: ${archive_comment} LIKE '%Going to PCP%' ;;
  }

  dimension: lwbs_no_longer_need_care {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: No longer need care%'
          or
          ${archive_comment} LIKE '%Cancelled by Patient or Partner: Symptoms Resolved / Wait it Out%' ;;
  }

  dimension: cancelled_by_patient_reason {
    type: yesno
    sql: ${primary_resolved_reason} = 'Cancelled by Patient' ;;
  }

  dimension: lwbs {
    type: yesno
    description: "Going to ED/Urgent Care, Wait Time Too Long, No Longer Need Care"
    sql: (${lwbs_going_to_ed} OR ${lwbs_going_to_urgent_care} OR
      ${lwbs_wait_time_too_long} OR ${lwbs_no_longer_need_care} OR ${lwbs_going_to_pcp}) and not ${booked_shaping_placeholder_resolved} ;;
  }

  dimension: resolved_no_answer_no_show {
    type: yesno
    sql: (${archive_comment} LIKE '%No Answer%' OR ${archive_comment} LIKE '%No Show%') and not ${booked_shaping_placeholder_resolved};;
  }

  dimension: resolved_no_show {
    type: yesno
    sql: (${archive_comment} LIKE '%No Show%') and not ${booked_shaping_placeholder_resolved};;
  }

  dimension: resolved_911_divert {
    type: yesno
    sql: ${archive_comment} LIKE '%911 Divert%' ;;
  }

  dimension: resolved_other {
    type: yesno
    sql:  ${complete_date} IS NULL AND ((${lwbs} IS NOT TRUE AND ${escalated_on_phone} IS NOT TRUE AND ${resolved_911_divert} IS NOT TRUE AND ${resolved_no_answer_no_show} IS NOT TRUE and ${booked_shaping_placeholder_resolved} is not true)
          OR ${archive_comment} IS NULL);;
  }

  dimension: resolved_category {
    type: string
    sql: CASE
          WHEN ${lwbs} THEN 'Left Without Being Seen'
          WHEN ${resolved_no_answer_no_show} THEN 'No Answer/No Show'
          WHEN ${resolved_911_divert} THEN '911 Diversion'
          WHEN ${escalated_on_phone} THEN 'Escalated Over Phone'
          WHEN ${resolved_other} THEN 'Other Resolved'
          ELSE 'Billable Visit'
        END
          ;;
  }

  measure: lwbs_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    link: {
      label: "Patient-Level Details"
      url: "https://dispatchhealth.looker.com/looks/1124?&f[markets.name]={{ _filters['markets.name'] | url_encode }}
      &f[markets.name_adj]={{ _filters['markets.name_adj'] | url_encode }}
      &f[care_request_flat.escalated_on_scene]={{ _filters['care_request_flat.escalated_on_scene'] | url_encode }}
      &f[care_request_flat.complete_resolved_date]=1+month+ago+for+1+month
      &f[care_request_flat.lwbs]={{ _filters['care_request_flat.lwbs'] | url_encode }}
      &f[care_request_flat.secondary_resolved_reason]={{ _filters['care_request_flat.secondary_resolved_reason'] | url_encode }}
      &f[athenadwh_payers_clone.custom_insurance_grouping]={{ _filters['athenadwh_payers_clone.custom_insurance_grouping'] | url_encode }}"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_flat.lwbs_count
    ]
  }

  measure: cancelled_by_patient_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: cancelled_by_patient_reason
      value: "yes"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
      ]
  }

  measure: no_answer_no_show_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved_no_answer_no_show
      value: "yes"
    }
  }

  measure: no_show_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved_no_show
      value: "yes"
    }
  }

  measure: resolved_non_lwbs_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: resolved_911_divert
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
    ]
  }

  measure: lwbs_rate {
    type: number
    value_format: "0.0%"
    sql: ${lwbs_count}::float/nullif(${care_requests.count_distinct_intended_care_requests},0) ;;

  }

  dimension: not_resolved_or_complete {
    type: yesno
    sql:not ${complete} and ${archive_comment} is null ;;
  }

  measure: not_resolved_or_complete_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }

  }

  dimension: pafu_or_follow_up {
    type: yesno
    sql: ${care_requests.follow_up} or ${care_requests.post_acute_follow_up} ;;
  }

  measure: follow_up_limbo_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }

    filters: {
      field: pafu_or_follow_up
      value: "yes"
    }

  }

  measure: non_follow_up_limbo_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }
    filters: {
      field: pafu_or_follow_up
      value: "no"
    }

  }

  measure: resolved_other_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: resolved_911_divert
      value: "no"
    }
    filters: {
      field: booked_shaping_placeholder_resolved
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }

    filters: {
      field: complete
      value: "no"
    }

    filters: {
      field: not_resolved_or_complete
      value: "no"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
    ]
  }

  measure: resolved_other_wo_shaping_booked_placeholder_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: resolved_911_divert
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }

    filters: {
      field: complete
      value: "no"
    }

    filters: {
      field: not_resolved_or_complete
      value: "no"
    }

    filters: {
      field: booked_resolved
      value: "no"
    }

    filters: {
      field: shaping_resolved
      value: "no"
    }

    filters: {
      field: placeholder_resolved
      value: "no"
    }

    drill_fields: [
      secondary_resolved_reason,
      care_request_count
    ]
  }


  measure: lwbs_count_pre_logistics {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    filters: {
      field: post_logistics_flag
      value: "no"
    }
  }

  measure: lwbs_count_post_logistics {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    filters: {
      field: post_logistics_flag
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
    sql: (${archive_comment} SIMILAR TO '(%Referred via Phone%|%Referred - Phone Triage%)') and not ${booked_shaping_placeholder_resolved};;
  }

  dimension: escalated_on_phone_ed {
    type: yesno
    sql:  (${archive_comment} LIKE '%Referred - Phone Triage: ED%' or  ${archive_comment} LIKE '%Referred via Phone: ED%' or ${archive_comment} LIKE '%Referred via Phone: Emergency Department%')  ;;

  }


  measure: escalated_on_phone_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
  }

  dimension: booked_shaping_placeholder_resolved {
    type: yesno
    sql:  lower(${archive_comment}) SIMILAR TO '%( cap|book|medicaid|tricare)%' and lower(${archive_comment}) not like '%capability%';;
  }

  dimension: out_of_service_out_of_scope {
    type: yesno
    sql:  lower(${archive_comment}) SIMILAR TO '%(oos|ooa|out of service area)%';;
  }

  dimension: shaping_resolved {
    type: yesno
    sql:  lower(${archive_comment}) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(${archive_comment}) not like '%capability%';;
  }

  dimension: booked_resolved {
    type: yesno
    sql:  lower(${archive_comment}) like '%book%' and not ${shaping_resolved} ;;
  }

  dimension: placeholder_resolved {
    type: yesno
    sql:  lower(${patients.last_name}) ='resolved' and not ${shaping_resolved} and not ${booked_resolved} ;;
  }

  measure: booked_shaping_placeholder_resolved_count {
    description: "Care requests resolved for booked, shaping or placeholder"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: booked_shaping_placeholder_resolved
      value: "yes"
    }
  }

  measure: shaping_resolved_count {
    description: "Care requests resolved for shaping"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: shaping_resolved
      value: "yes"
    }
  }

  measure: booked_resolved_count {
    description: "Care requests resolved for booked"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: booked_resolved
      value: "yes"
    }
  }

  measure: placeholder_resolved_count {
    description: "Care requests resolved with placeholder"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: placeholder_resolved
      value: "yes"
    }
  }

  measure: screened_escalated_phone_count {
    description: "Care requests secondary screened and escalated over the phone"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "yes"
    }
  }

  measure: screened_escalated_ed_phone_count {
    description: "Care requests secondary screened and escalated over the phone ED"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "yes"
    }
  }

  measure: not_screened_escalated_onscene_count {
    description: "Care requests not secondary screened that were escalated on scene"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_scene
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_phone_count {
    description: "Care requests NOT secondary screened and escalated over the phone"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_phone_count_ed {
    description: "Care requests NOT secondary screened and escalated over the phone to the ED"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_phone_count_other {
    description: "Care requests NOT secondary screened and escalated over the phone not to th ED"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: escalated_on_phone_ed
      value: "no"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_on_phone_ed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: escalated_on_phone_ed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
  }

  measure: non_screeened_escalated_on_phone_ed_percent{
    type: number
    sql: ${non_screened_escalated_on_phone_ed_count}::float/(nullif(${care_request_count},0))::float ;;
    value_format: "0%"
  }


  measure: escalated_on_phone_ed_percent{
    type: number
    sql: ${escalated_on_phone_ed_count}::float/(nullif(${care_request_count},0))::float ;;
    value_format: "0%"
  }

  measure: escalated_on_phone_ed_percent_green{
    type: number
    sql: ${risk_assessments.count_green_escalated_phone}::float/(nullif(${risk_assessments.count_green},0))::float  ;;
    value_format: "0%"
  }

  measure:  non_screeened_escalated_on_phone_ed_percent_green{
    type: number
    sql: ${risk_assessments.non_screened_count_green_escalated_phone}::float/(nullif(${risk_assessments.count_green},0))::float  ;;
    value_format: "0%"
  }


  measure: escalated_on_phone_ed_percent_yellow{
    type: number
    sql: ${risk_assessments.count_yellow_escalated_phone}::float/(nullif(${risk_assessments.count_yellow},0))::float ;;
    value_format: "0%"
  }

  measure: non_screened_escalated_on_phone_ed_percent_yellow{
    type: number
    sql: ${risk_assessments.non_screened_count_yellow_escalated_phone}::float/(nullif(${risk_assessments.count_yellow},0))::float ;;
    value_format: "0%"
  }





  measure: escalated_on_phone_ed_percent_red{
    type: number
    sql:  ${risk_assessments.count_red_escalated_phone}::float/(nullif(${risk_assessments.count_red},0))::float ;;
    value_format: "0%"
  }

  measure: non_screened_escalated_on_phone_ed_percent_red{
    type: number
    sql:  ${risk_assessments.non_screened_count_red_escalated_phone}::float/(nullif(${risk_assessments.count_red},0))::float ;;
    value_format: "0%"
  }

  dimension: hours_to_archive {
    value_format: "0.0"
    type: number
    sql: round(EXTRACT(EPOCH FROM ${archive_raw}-${requested_raw})/3600) ;;
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

  dimension: prior_complete_week_flag {
    description: "The complete date is in the past complete week"
    type: yesno
    sql: ((((${complete_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
         (${complete_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_complete_month_flag {
    description: "The complete date is in the past complete month"
    type: yesno
    sql: ((((${complete_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${complete_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
  }

  dimension: prior_on_scene_month_flag {
    description: "The complete date is in the past complete month"
    type: yesno
    sql: ((((${on_scene_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${on_scene_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
  }

  dimension: prior_archive_week_flag {
    description: "The archive date is in the past complete week"
    type: yesno
    sql: ((((${archive_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
      (${archive_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_created_week_flag {
    description: "The created date is in the past complete week"
    type: yesno
    sql: ((((${created_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
      (${created_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_created_month_flag {
    description: "The created date is in the past complete month"
    type: yesno
    sql: ((((${created_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${created_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
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

    measure: complete_count_medicaid {
      type: count_distinct
      sql: ${care_request_id} ;;
      filters: {
        field: complete
        value: "yes"
      }
      filters: {
        field: insurance_coalese_crosswalk.custom_insurance_grouping
        value: "(MAID)MEDICAID"
      }
    }

  measure: complete_count_tricare {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: insurance_coalese_crosswalk.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
  }

  dimension: payer_tricare {
    type:  yesno
    description: "Insurance/Payer custom group is Tricare"
    sql: trim(lower(${insurance_coalese_crosswalk.custom_insurance_grouping})) LIKE '(tc)tricare' ;;

  }

  measure: complete_count_medicaid_tricare {
    type: number
    sql: ${complete_count_medicaid}+${complete_count_tricare} ;;
  }


  dimension: flu_chief_complaint {
    type: yesno
    sql:
    lower(${care_requests.chief_complaint}) SIMILAR TO '%(flu|cough)%'
    OR
    lower(${care_requests.chief_complaint}) like '%uri'
    OR
    lower(${care_requests.chief_complaint}) like '%uri %'
    OR
    lower(${care_requests.chief_complaint}) like '%uri/%'
    or trim(lower(${care_requests.chief_complaint})) = 'uri';;
  }

  measure: complete_count_flu {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: athenadwh_icdcodeall.likely_flu_diganosis
      value: "yes"
    }
  }

  measure: complete_count_flu_chief_complaint {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: flu_chief_complaint
      value: "yes"
    }
  }


  measure: flu_percent {
    type: number
    value_format: "0.0%"
    sql: ${complete_count_flu}::float/nullif(${complete_count}::float,0);;
  }

  measure: flu_percent_chief_complaint {
    type: number
    value_format: "0.0%"
    sql: ${complete_count_flu_chief_complaint}::float/nullif(${complete_count}::float,0);;
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

  measure: care_request_count_uhc {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: channel_items.uhc_care_request
      value: "yes"
    }
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

  measure: max_on_scene_day_of_month {
    type: number
    sql: max(${on_scene_day_of_month}) ;;
  }

  measure: max_created_day_of_month {
    type: number
    sql: max(${created_day_of_month}) ;;
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

  measure: care_request_count_run_rate {
    type: number
    value_format: "0"
    sql:  ${care_request_count}/${month_percent};;
  }

  measure: complete_count_flu_run_rate {
    type: number
    value_format: "0"
    sql:  ${complete_count_flu}/${month_percent};;
  }

  measure: count_distinct_care_requests_phone_run_rate {
    type: number
    value_format: "0"
    sql:  ${care_requests.count_distinct__care_requests_phone}/${month_percent};;
  }

  measure: count_distinct_care_requests_other_run_rate {
    type: number
    value_format: "0"
    sql:  ${care_requests.count_distinct_care_requests_other}/${month_percent};;
  }

  measure: monthly_complete_run_rate_seasonal_adj {
    type: number
    value_format: "#,##0"
    sql: (
           (
            ${complete_count}/${month_percent}
           )
          /${seasonal_adj.seasonal_adj}
         )
        /${days_in_month_adj.days_in_month_adj};;
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

  dimension: days_in_month_on_scene {
    type: number
    sql:
     case when to_char(${on_scene_date} , 'YYYY-MM') = ${yesterday_mountain_month} then ${yesterday_mountain_day_of_month}
    else
      DATE_PART('days',
        DATE_TRUNC('month', ${on_scene_date})
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
    sql: coalesce((case when ${ga_pageviews_clone.high_level_category} in('Other', 'Self Report Direct to Consumer') then null else ${ga_pageviews_clone.high_level_category} end), ${web_ga_pageviews_clone.high_level_category}) ;;
  }

  measure: dtc_agg_category {
    type: string
    sql: array_agg(${ga_high_level_category})::text ;;
  }

  measure: dtc_agg_category_hiearchy{
    type: string
    sql: case when ${dtc_agg_category} like '%SEM: Non-Brand%' then 'SEM: Non-Brand'
     when ${dtc_agg_category}  like '%SEM: Brand%' then 'SEM: Brand'
    when ${dtc_agg_category}  like '%Display%' then 'Display'
     when ${dtc_agg_category}  like '%Local Listings%' then 'Local Listings'
     when ${dtc_agg_category} like '%Organic Search%' then 'Organic Search'
      when ${dtc_agg_category}  like '%Other%' then 'Other'
      when ${dtc_agg_category}  like '%Self Report Direct to Consumer%' then 'Self Report Direct to Consumer'
   else null
end  ;;
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

  measure: min_complete_timestamp {
    type: date_time
    sql: min(${complete_raw}) ;;
  }

  measure: max_complete_timestamp {
    type: date_time
    sql: max(${complete_raw}) ;;
  }

  dimension: weekend_after_3pm {
    description: "A flag indicating the care request took place after 3PM or on the weekend"
    type: yesno
    sql: ${on_scene_hour_of_day} > 15 OR ${on_scene_day_of_week_index} IN (5, 6)  ;;
  }

  dimension: dc1 {
    description: "Diagnosis Only"
    type: number
    #hidden: yes
    sql: CASE WHEN ${diversion_flat.diagnosis_code} IS NOT NULL THEN 1 ELSE 0 END ;;
  }

  measure: dc1_max {
    description: "Max diversion dc1 value"
    type: max
    sql: ${dc1} ;;
  }

  dimension: dc2 {
    description: "Survey Response YES to ER"
    type: number
    #hidden: yes
    sql: CASE WHEN ${ed_diversion_survey_response_clone.survey_yes_to_er} OR ${medical_necessity_notes.er_911_alternative} THEN 1 ELSE 0 END ;;
  }

  measure: dc2_max {
    description: "Max diversion dc2 value"
    type: max
    sql: ${dc2} ;;
  }

  dimension: dc3 {
    description: "911 Diversion Program"
    type: number
    #hidden: yes
    sql: CASE WHEN ${channel_items.divert_from_911} OR ${medical_necessity_notes.er_911_alternative} THEN 1 ELSE 0 END ;;
  }

  measure: dc3_max {
    description: "Max diversion dc3 value"
    type: max
    sql: ${dc3} ;;
  }

  dimension: dc4 {
    description: "POS SNF"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_snf} THEN 1 ELSE 0 END ;;
  }

  measure: dc4_max {
    description: "Max diversion dc4 value"
    type: max
    sql: ${dc4} ;;
  }

  dimension: dc5 {
    description: "POS Assisted Living"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_al} THEN 1 ELSE 0 END ;;
  }

  measure: dc5_max {
    description: "Max diversion dc5 value"
    type: max
    sql: ${dc5} ;;
  }

  dimension: dc6 {
    description: "Referred from Home Health, PCP or Care Mgmt"
    type: number
    #hidden: yes
    sql: CASE WHEN ${channel_items.referred_from_hh_pcp_cm} THEN 1 ELSE 0 END ;;
  }

  measure: dc6_count {
    description: "Count Referred from Home Health, PCP or Care Mgmt"
    label: "Count Referred from Home Health, PCP or Care Mgmt"
    type:  count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: dc6
      value: "1"
    }
  }

  measure: dc6_max {
    description: "Max diversion dc6 value"
    type: max
    sql: ${dc6} ;;
  }

  dimension: dc7 {
    description: "Weekends or After 3 PM"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_request_flat.weekend_after_3pm} THEN 1 ELSE 0 END ;;
  }

  measure: dc7_max {
    description: "Max diversion dc7 value"
    type: max
    sql: ${dc7} ;;
  }

  measure: dc7_count {
    description: "Count Weekends or After 3 PM"
    label: "Count Weekends or After 3 PM"
    type:  count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: dc7
      value: "1"
    }
  }

  dimension: dc8 {
    description: "Abnormal Vitals (O2 sat < 90%, HR > 100, SBP < 90 for adults)"
    type: number
    #hidden: yes
    sql: CASE WHEN ${vitals_flat.abnormal_vitals} THEN 1 ELSE 0 END ;;
  }

  measure: dc8_max {
    description: "Max diversion dc8 value"
    type: max
    sql: ${dc8} ;;
  }

  measure: dc8_count {
    description: "Count Abnormal Vitals (O2 sat < 90%, HR > 100, SBP < 90 for adults)"
    label: "Count Abnormal Vitals"
    type:  count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: dc8
      value: "1"
    }
  }

  dimension: dc9 {
    description: "Additional Dx of Confusion or Altered Awareness"
    type: number
    #hidden: yes
    sql: CASE WHEN ${athenadwh_icdcodeall.confusion_altered_awareness} THEN 1 ELSE 0 END ;;
  }

  measure: dc9_max {
    description: "Max diversion dc9 value"
    type: max
    sql: ${dc9} ;;
  }

  dimension: dc10 {
    description: "Wheelchair or Homebound"
    type: number
    #hidden: yes
    sql: CASE WHEN ${athenadwh_icdcodeall.wheelchair_homebound} THEN 1 ELSE 0 END ;;
  }

  measure: dc10_max {
    description: "Max diversion dc10 value"
    type: max
    sql: ${dc10} ;;
  }

  measure: dc10_count {
    description: "Count Wheelchair or Homebound"
    label: "Count Wheelchair or Homebound"
    type:  count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: dc10
      value: "1"
    }
  }

  dimension: dc11 {
    description: "EKG Performed"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.ekg_performed} THEN 1 ELSE 0 END ;;
  }

  measure: dc11_max {
    description: "Max diversion dc11 value"
    type: max
    sql: ${dc11} ;;
  }

  dimension: dc12 {
    description: "Nebulizer Treatment"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.nebulizer} THEN 1 ELSE 0 END ;;
  }

  measure: dc12_max {
    description: "Max diversion dc12 value"
    type: max
    sql: ${dc12} ;;
  }

  dimension: dc13 {
    description: "IV/Fluids Administered"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.iv_fluids} THEN 1 ELSE 0 END ;;
  }

  measure: dc13_max {
    description: "Max diversion dc13 value"
    type: max
    sql: ${dc13} ;;
  }

  dimension: dc14 {
    description: "Blood Tests Performed"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.blood_tests} THEN 1 ELSE 0 END ;;
  }

  measure: dc14_max {
    description: "Max diversion dc14 value"
    type: max
    sql: ${dc14} ;;
  }

  dimension: dc15 {
    description: "Catheter Adjustment or Placement"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.catheter_placement} THEN 1 ELSE 0 END ;;
  }

  measure: dc15_max {
    description: "Max diversion dc15 value"
    type: max
    sql: ${dc15} ;;
  }

  dimension: dc16 {
    description: "Laceration Repair"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.laceration_repair} THEN 1 ELSE 0 END ;;
  }

  measure: dc16_max {
    description: "Max diversion dc16 value"
    type: max
    sql: ${dc16} ;;
  }

  dimension: dc17 {
    description: "Epistaxis Tx"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.epistaxis} THEN 1 ELSE 0 END ;;
  }

  measure: dc17_max {
    description: "Max diversion dc17 value"
    type: max
    sql: ${dc17} ;;
  }

  dimension: dc18 {
    description: "Rectal Prolapse Reduction or Hernia Reduction"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.hernia_rp_reduction} THEN 1 ELSE 0 END ;;
  }

  measure: dc18_max {
    description: "Max diversion dc18 value"
    type: max
    sql: ${dc18} ;;
  }

  dimension: dc19 {
    description: "Nursemaids elbow reduction or other joint reduction"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.joint_reduction} THEN 1 ELSE 0 END ;;
  }

  measure: dc19_max {
    description: "Max diversion dc19 value"
    type: max
    sql: ${dc19} ;;
  }

  dimension: dc20 {
    description: "Gastrostomy Tube replacement or repair"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.gastronomy_tube} THEN 1 ELSE 0 END ;;
  }

  measure: dc20_max {
    description: "Max diversion dc20 value"
    type: max
    sql: ${dc20} ;;
  }

  dimension: dc21 {
    description: "I&D of Abscess"
    type: number
    #hidden: yes
    sql: CASE WHEN ${cpt_code_dimensions_clone.abscess_drain} THEN 1 ELSE 0 END ;;
  }

  measure: dc21_max {
    description: "Max diversion dc21 value"
    type: max
    sql: ${dc21} ;;
  }

  dimension: dc22 {
    description: "POS SNF AND (abnormal vital signs  OR altered mental status)"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_snf} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness}) THEN 1 ELSE 0 END ;;
  }

  measure: dc22_max {
    description: "Max diversion dc22 value"
    type: max
    sql: ${dc22} ;;
  }

  dimension: dc23 {
    description: "POS SNF AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_snf} AND ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc23_max {
    description: "Max diversion dc23 value"
    type: max
    sql: ${dc23} ;;
  }

  dimension: dc24 {
    description: "POS SNF AND referral"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_snf} AND ${channel_items.referred_from_hh_pcp_cm} THEN 1 ELSE 0 END ;;
  }

  measure: dc24_max {
    description: "Max diversion dc24 value"
    type: max
    sql: ${dc24} ;;
  }

  dimension: dc25 {
    description: "POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_snf} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness}) AND
    ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc25_max {
    description: "Max diversion dc25 value"
    type: max
    sql: ${dc25} ;;
  }

  dimension: dc26 {
    description: "POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_snf} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness} OR
    ${cpt_code_dimensions_clone.any_cs_procedure} OR ${channel_items.referred_from_hh_pcp_cm}) AND ${care_request_flat.weekend_after_3pm} THEN 1 ELSE 0 END ;;
  }

  measure: dc26_max {
    description: "Max diversion dc26 value"
    type: max
    sql: ${dc26} ;;
  }

  dimension: dc27 {
    description: "POS AL AND (abnormal vital signs OR altered mental status)"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_al} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness}) THEN 1 ELSE 0 END ;;
  }

  measure: dc27_max {
    description: "Max diversion dc27 value"
    type: max
    sql: ${dc27} ;;
  }

  dimension: dc28 {
    description: "POS AL AND procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_al} AND ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc28_max {
    description: "Max diversion dc28 value"
    type: max
    sql: ${dc28} ;;
  }

  dimension: dc29 {
    description: "POS AL AND referral"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_al} AND ${channel_items.referred_from_hh_pcp_cm} THEN 1 ELSE 0 END ;;
  }

  measure: dc29_max {
    description: "Max diversion dc29 value"
    type: max
    sql: ${dc29} ;;
  }

  dimension: dc30 {
    description: "POS AL AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_al} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness}) AND
    ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc30_max {
    description: "Max diversion dc30 value"
    type: max
    sql: ${dc30} ;;
  }

  dimension: dc31 {
    description: "POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_al} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness} OR
    ${cpt_code_dimensions_clone.any_cs_procedure} OR ${channel_items.referred_from_hh_pcp_cm}) AND ${care_request_flat.weekend_after_3pm} THEN 1 ELSE 0 END ;;
  }

  measure: dc31_max {
    description: "Max diversion dc31 value"
    type: max
    sql: ${dc31} ;;
  }

  dimension: dc32 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status)"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness}) THEN 1 ELSE 0 END ;;
  }

  measure: dc32_max {
    description: "Max diversion dc32 value"
    type: max
    sql: ${dc32} ;;
  }

  dimension: dc33 {
    description: "POS HOME AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc33_max {
    description: "Max diversion dc33 value"
    type: max
    sql: ${dc33} ;;
  }

  dimension: dc34 {
    description: "POS HOME AND referral"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${channel_items.referred_from_hh_pcp_cm} THEN 1 ELSE 0 END ;;
  }

  measure: dc34_max {
    description: "Max diversion dc34 value"
    type: max
    sql: ${dc34} ;;
  }

  dimension: dc35 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness}) AND
    ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc35_max {
    description: "Max diversion dc35 value"
    type: max
    sql: ${dc35} ;;
  }

  dimension: dc36 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND (${vitals_flat.abnormal_vitals} OR ${athenadwh_icdcodeall.confusion_altered_awareness} OR
    ${cpt_code_dimensions_clone.any_cs_procedure} OR ${channel_items.referred_from_hh_pcp_cm}) AND ${care_request_flat.weekend_after_3pm} THEN 1 ELSE 0 END ;;
  }

  measure: dc36_max {
    description: "Max diversion dc36 value"
    type: max
    sql: ${dc36} ;;
  }

  dimension: dc37 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status)"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${athenadwh_icdcodeall.wheelchair_homebound} AND (${vitals_flat.abnormal_vitals} OR
    ${athenadwh_icdcodeall.confusion_altered_awareness}) THEN 1 ELSE 0 END ;;
  }

  measure: dc37_max {
    description: "Max diversion dc37 value"
    type: max
    sql: ${dc37} ;;
  }

  dimension: dc38 {
    description: "POS HOME AND wheelchair/homebound AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${athenadwh_icdcodeall.wheelchair_homebound} AND ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc38_max {
    description: "Max diversion dc38 value"
    type: max
    sql: ${dc38} ;;
  }

  dimension: dc39 {
    description: "POS HOME AND wheelchair/homebound AND referral"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${athenadwh_icdcodeall.wheelchair_homebound} AND ${channel_items.referred_from_hh_pcp_cm} THEN 1 ELSE 0 END ;;
  }

  measure: dc39_max {
    description: "Max diversion dc39 value"
    type: max
    sql: ${dc39} ;;
  }

  dimension: dc40 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${athenadwh_icdcodeall.wheelchair_homebound} AND (${vitals_flat.abnormal_vitals} OR
    ${athenadwh_icdcodeall.confusion_altered_awareness}) AND ${cpt_code_dimensions_clone.any_cs_procedure} THEN 1 ELSE 0 END ;;
  }

  measure: dc40_max {
    description: "Max diversion dc40 value"
    type: max
    sql: ${dc40} ;;
  }

  dimension: dc41 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    #hidden: yes
    sql: CASE WHEN ${care_requests.pos_home} AND ${athenadwh_icdcodeall.wheelchair_homebound} AND (${vitals_flat.abnormal_vitals} OR
    ${athenadwh_icdcodeall.confusion_altered_awareness} OR ${cpt_code_dimensions_clone.any_cs_procedure} OR ${channel_items.referred_from_hh_pcp_cm}) AND
    ${care_request_flat.weekend_after_3pm} THEN 1 ELSE 0 END ;;
  }

  measure: dc41_max {
    description: "Max diversion dc41 value"
    type: max
    sql: ${dc41} ;;
  }


  dimension: diversion_category_first_met {
    description: "The first diversion category that was met"
    type: string
    sql: CASE
          WHEN ${dc1} = 1 AND ${diversion_flat.dc1} = 1 THEN 'Diagnosis Only'
          WHEN ${dc2} = 1 AND ${diversion_flat.dc2} = 1 THEN 'Survey Response Yes to ER'
          WHEN ${dc3} = 1 AND ${diversion_flat.dc3} = 1 THEN '911 Diversion Program'
          WHEN ${dc4} = 1 AND ${diversion_flat.dc4} = 1 THEN 'POS SNF'
          WHEN ${dc5} = 1 AND ${diversion_flat.dc5} = 1 THEN 'POS Assisted Living'
          WHEN ${dc6} = 1 AND ${diversion_flat.dc6} = 1 THEN 'Referred from HH, PCP or CM'
          WHEN ${dc7} = 1 AND ${diversion_flat.dc7} = 1 THEN 'Weekends or After 3 PM'
          WHEN ${dc8} = 1 AND ${diversion_flat.dc8} = 1 THEN 'Abnormal Vitals'
          WHEN ${dc9} = 1 AND ${diversion_flat.dc9} = 1 THEN 'Confusion or Altered Awareness'
          WHEN ${dc10} = 1 AND ${diversion_flat.dc10} = 1 THEN 'Wheelchair/Homebound'
          WHEN ${dc11} = 1 AND ${diversion_flat.dc11} = 1 THEN 'EKG Performed'
          WHEN ${dc12} = 1 AND ${diversion_flat.dc12} = 1 THEN 'Nebulizer Treatment'
          WHEN ${dc13} = 1 AND ${diversion_flat.dc13} = 1 THEN 'IV/Fluids Administered'
          WHEN ${dc14} = 1 AND ${diversion_flat.dc14} = 1 THEN 'Blood Tests Performed'
          WHEN ${dc15} = 1 AND ${diversion_flat.dc15} = 1 THEN 'Catheter Adjustment/Placement'
          WHEN ${dc16} = 1 AND ${diversion_flat.dc16} = 1 THEN 'Laceration Repair'
          WHEN ${dc17} = 1 AND ${diversion_flat.dc17} = 1 THEN 'Epistaxis'
          WHEN ${dc18} = 1 AND ${diversion_flat.dc18} = 1 THEN 'Hernia/Rectal Prolapse Reduction'
          WHEN ${dc19} = 1 AND ${diversion_flat.dc19} = 1 THEN 'Nursemaids Elbow/Other Joint Reduction'
          WHEN ${dc20} = 1 AND ${diversion_flat.dc20} = 1 THEN 'Gastronomy Tube Replacement or Repair'
          WHEN ${dc21} = 1 AND ${diversion_flat.dc21} = 1 THEN 'I&D of Abscess'
          WHEN ${dc22} = 1 AND ${diversion_flat.dc22} = 1 THEN 'POS SNF AND (abnormal vital signs  OR altered mental status)'
          WHEN ${dc23} = 1 AND ${diversion_flat.dc23} = 1 THEN 'POS SNF AND any procedures'
          WHEN ${dc24} = 1 AND ${diversion_flat.dc24} = 1 THEN 'POS SNF AND referral'
          WHEN ${dc25} = 1 AND ${diversion_flat.dc25} = 1 THEN 'POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures'
          WHEN ${dc26} = 1 AND ${diversion_flat.dc26} = 1 THEN 'POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday'
          WHEN ${dc27} = 1 AND ${diversion_flat.dc27} = 1 THEN 'POS AL AND (abnormal vital signs OR altered mental status)'
          WHEN ${dc28} = 1 AND ${diversion_flat.dc28} = 1 THEN 'POS AL AND procedures'
          WHEN ${dc29} = 1 AND ${diversion_flat.dc29} = 1 THEN 'POS AL AND referral'
          WHEN ${dc30} = 1 AND ${diversion_flat.dc30} = 1 THEN 'POS AL AND (abnormal vital signs OR altered mental status) AND any procedures'
          WHEN ${dc31} = 1 AND ${diversion_flat.dc31} = 1 THEN 'POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday'
          WHEN ${dc32} = 1 AND ${diversion_flat.dc32} = 1 THEN 'POS HOME AND (abnormal vital signs OR altered mental status)'
          WHEN ${dc33} = 1 AND ${diversion_flat.dc33} = 1 THEN 'POS HOME AND any procedures'
          WHEN ${dc34} = 1 AND ${diversion_flat.dc34} = 1 THEN 'POS HOME AND referral'
          WHEN ${dc35} = 1 AND ${diversion_flat.dc35} = 1 THEN 'POS HOME AND (abnormal vital signs OR altered mental status) AND any procedures'
          WHEN ${dc36} = 1 AND ${diversion_flat.dc36} = 1 THEN 'POS HOME AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday'
          WHEN ${dc37} = 1 AND ${diversion_flat.dc37} = 1 THEN 'POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status)'
          WHEN ${dc38} = 1 AND ${diversion_flat.dc38} = 1 THEN 'POS HOME AND wheelchair/homebound AND any procedures'
          WHEN ${dc39} = 1 AND ${diversion_flat.dc39} = 1 THEN 'POS HOME AND wheelchair/homebound AND referral'
          WHEN ${dc40} = 1 AND ${diversion_flat.dc40} = 1 THEN 'POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures'
          WHEN ${dc41} = 1 AND ${diversion_flat.dc41} = 1 THEN 'POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday'
          ELSE 'No Diversion Criteria Met'
  END;;
  }

  measure: diversion_categories_met {
    description: "A list of the diversion categories that have been met"
    type: string
    sql: array_to_string(array_agg(${diversion_category_first_met}), ' | ') ;;
  }

  dimension: diversion_cats_met {
    description: "The number of diversion categories met"
    type: number
    sql: COALESCE(${dc1}, 0)*COALESCE(${diversion_flat.dc1}, 0) +
    COALESCE(${dc2}, 0)*COALESCE(${diversion_flat.dc2}, 0) +
    COALESCE(${dc3}, 0)*COALESCE(${diversion_flat.dc3}, 0) +
    COALESCE(${dc4}, 0)*COALESCE(${diversion_flat.dc4}, 0) +
    COALESCE(${dc5}, 0)*COALESCE(${diversion_flat.dc5}, 0) +
    COALESCE(${dc6}, 0)*COALESCE(${diversion_flat.dc6}, 0) +
    COALESCE(${dc7}, 0)*COALESCE(${diversion_flat.dc7}, 0) +
    COALESCE(${dc8}, 0)*COALESCE(${diversion_flat.dc8}, 0) +
    COALESCE(${dc9}, 0)*COALESCE(${diversion_flat.dc9}, 0) +
    COALESCE(${dc10}, 0)*COALESCE(${diversion_flat.dc10}, 0) +
    COALESCE(${dc11}, 0)*COALESCE(${diversion_flat.dc11}, 0) +
    COALESCE(${dc12}, 0)*COALESCE(${diversion_flat.dc12}, 0) +
    COALESCE(${dc13}, 0)*COALESCE(${diversion_flat.dc13}, 0) +
    COALESCE(${dc14}, 0)*COALESCE(${diversion_flat.dc14}, 0) +
    COALESCE(${dc15}, 0)*COALESCE(${diversion_flat.dc15}, 0) +
    COALESCE(${dc16}, 0)*COALESCE(${diversion_flat.dc16}, 0) +
    COALESCE(${dc17}, 0)*COALESCE(${diversion_flat.dc17}, 0) +
    COALESCE(${dc18}, 0)*COALESCE(${diversion_flat.dc18}, 0) +
    COALESCE(${dc19}, 0)*COALESCE(${diversion_flat.dc19}, 0) +
    COALESCE(${dc20}, 0)*COALESCE(${diversion_flat.dc20}, 0) +
    COALESCE(${dc21}, 0)*COALESCE(${diversion_flat.dc21}, 0) +
    COALESCE(${dc22}, 0)*COALESCE(${diversion_flat.dc22}, 0) +
    COALESCE(${dc23}, 0)*COALESCE(${diversion_flat.dc23}, 0) +
    COALESCE(${dc24}, 0)*COALESCE(${diversion_flat.dc24}, 0) +
    COALESCE(${dc25}, 0)*COALESCE(${diversion_flat.dc25}, 0) +
    COALESCE(${dc26}, 0)*COALESCE(${diversion_flat.dc26}, 0) +
    COALESCE(${dc27}, 0)*COALESCE(${diversion_flat.dc27}, 0) +
    COALESCE(${dc28}, 0)*COALESCE(${diversion_flat.dc28}, 0) +
    COALESCE(${dc29}, 0)*COALESCE(${diversion_flat.dc29}, 0) +
    COALESCE(${dc30}, 0)*COALESCE(${diversion_flat.dc30}, 0) +
    COALESCE(${dc31}, 0)*COALESCE(${diversion_flat.dc31}, 0) +
    COALESCE(${dc32}, 0)*COALESCE(${diversion_flat.dc32}, 0) +
    COALESCE(${dc33}, 0)*COALESCE(${diversion_flat.dc33}, 0) +
    COALESCE(${dc34}, 0)*COALESCE(${diversion_flat.dc34}, 0) +
    COALESCE(${dc35}, 0)*COALESCE(${diversion_flat.dc35}, 0) +
    COALESCE(${dc36}, 0)*COALESCE(${diversion_flat.dc36}, 0) +
    COALESCE(${dc37}, 0)*COALESCE(${diversion_flat.dc37}, 0) +
    COALESCE(${dc38}, 0)*COALESCE(${diversion_flat.dc38}, 0) +
    COALESCE(${dc39}, 0)*COALESCE(${diversion_flat.dc39}, 0) +
    COALESCE(${dc40}, 0)*COALESCE(${diversion_flat.dc40}, 0) +
    COALESCE(${dc41}, 0)*COALESCE(${diversion_flat.dc41}, 0);;
  }

  dimension: diversion_flag {
    type: yesno
    sql: ${diversion_cats_met} > 0;;
  }

  measure: count_er_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_type.diversion_type_er
      value: "yes"
    }
    filters: {
      field:diversion_flag
      value: "yes"
    }
    filters: {
      field: escalated_on_scene
      value: "no"
    }
    filters: {
      field: care_requests.post_acute_follow_up
      value: "no"
    }
  }

  dimension: diversion_er {
    type: number
    sql: CASE WHEN ${diversion_type.diversion_type_er} AND ${diversion_flag} THEN 1 ELSE 0 END ;;
  }

  measure: diversion_savings_er {
    type: number
    sql: ${count_er_diversions} *
        MAX(CASE
          WHEN ${insurance_plans.er_diversion} IS NOT NULL THEN ${insurance_plans.er_diversion}
          WHEN ${population_health_channels.er_diversion} IS NOT NULL THEN ${population_health_channels.er_diversion}
          WHEN ${channel_items.er_diversion} IS NOT NULL THEN ${channel_items.er_diversion}
          ELSE 2000
        END) ;;
    value_format: "$#,##0"
  }

  measure: count_911_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_type.diversion_type_911
      value: "yes"
    }
    filters: {
      field:diversion_flag
      value: "yes"
    }
    filters: {
      field: escalated_on_scene
      value: "no"
    }
    filters: {
      field: care_requests.post_acute_follow_up
      value: "no"
    }
  }
  dimension: diversion_911 {
    type: number
    sql: CASE WHEN ${diversion_type.diversion_type_911} AND ${diversion_flag} THEN 1 ELSE 0 END ;;
  }

  measure: diversion_savings_911 {
    type: number
    sql: ${count_911_diversions} *
        MAX(CASE
          WHEN ${insurance_plans.nine_one_one_diversion} IS NOT NULL THEN ${insurance_plans.nine_one_one_diversion}
          WHEN ${population_health_channels.nine_one_one_diversion} IS NOT NULL THEN ${population_health_channels.nine_one_one_diversion}
          WHEN ${channel_items.nine_one_one_diversion} IS NOT NULL THEN ${channel_items.nine_one_one_diversion}
          ELSE 750
        END) ;;
    value_format: "$#,##0"
  }

  measure: count_hospitalization_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_type.diversion_type_hospitalization
      value: "yes"
    }
    filters: {
      field:diversion_flag
      value: "yes"
    }
    filters: {
      field: escalated_on_scene
      value: "no"
    }
    filters: {
      field: care_requests.post_acute_follow_up
      value: "no"
    }
  }

  measure: diversion_savings_hospitalization {
    type: number
    sql: ${count_hospitalization_diversions} *
    MAX(CASE
          WHEN ${insurance_plans.hospitalization_diversion} IS NOT NULL THEN ${insurance_plans.hospitalization_diversion}
          WHEN ${population_health_channels.hospitalization_diversion} IS NOT NULL THEN ${population_health_channels.hospitalization_diversion}
          WHEN ${channel_items.hospitalization_diversion} IS NOT NULL THEN ${channel_items.hospitalization_diversion}
          ELSE 12000
        END) ;;
    value_format: "$#,##0"
  }

  dimension: diversion_hospitalization {
    type: number
    sql: CASE WHEN ${diversion_type.diversion_type_hospitalization} AND ${diversion_flag} THEN 1 ELSE 0 END ;;
  }

  measure: count_observation_diversions {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: diversion_type.diversion_type_observation
      value: "yes"
    }
    filters: {
      field:diversion_flag
      value: "yes"
    }
    filters: {
      field: escalated_on_scene
      value: "no"
    }
    filters: {
      field: care_requests.post_acute_follow_up
      value: "no"
    }
  }

  measure: diversion_savings_observation {
    type: number
    sql: ${count_observation_diversions} *
    MAX(CASE
          WHEN ${insurance_plans.observation_diversion} IS NOT NULL THEN ${insurance_plans.observation_diversion}
          WHEN ${population_health_channels.observation_diversion} IS NOT NULL THEN ${population_health_channels.observation_diversion}
          WHEN ${channel_items.observation_diversion} IS NOT NULL THEN ${channel_items.observation_diversion}
          ELSE 4000
        END) ;;
    value_format: "$#,##0"
  }

  dimension: diversion_observation {
    type: number
    sql: CASE WHEN ${diversion_type.diversion_type_observation} AND ${diversion_flag} THEN 1 ELSE 0 END ;;
  }

  dimension: high_acuity_visit {
    type: yesno
    sql: ${diversion_flag} OR ${escalated_on_scene} OR ${care_requests.post_acute_follow_up};;
  }

  measure: count_high_acuity_visits {
    type: count_distinct
    description: "Count of visits that met a diversion criteria or were PAFU or were escalated on scene"
    sql: ${care_request_id} ;;
    filters: {
      field: high_acuity_visit
      value: "yes"
    }
  }

  dimension: diversion_category {
    type: string
    sql: CASE
      WHEN ${complete_time} IS NULL THEN 'not completed'
      WHEN ${escalated_on_scene} THEN 'escalated'
      WHEN ${visit_facts_clone.day_30_followup_outcome} IN ( 'ed_same_complaint', 'hospitalization_same_complaint' )
        OR
        ${visit_facts_clone.day_14_followup_outcome} IN( 'ed_same_complaint', 'hospitalization_same_complaint' )
        OR
        ${visit_facts_clone.day_3_followup_outcome} IN( 'ed_same_complaint', 'hospitalization_same_complaint') THEN 'ed_same_complaint'
      WHEN lower(${cars.name}) IN ('smfr_car', 'wmfr car')  THEN
        'smfr/wmfr'
      WHEN lower(${channel_items.type_name}) IN( 'home health',
                          'snf',
                          'provider group' ) THEN lower(${channel_items.type_name})
      WHEN lower(${channel_items.type_name}) = 'senior care'
        AND
        ${on_scene_hour_of_day} < 15
        AND
       ${on_scene_day_of_week_index} NOT IN (5, 6) THEN 'senior care - weekdays before 3pm'
      WHEN lower(${channel_items.type_name})  = 'senior care'
        AND
        (
          ${on_scene_hour_of_day} > 15
          OR
            ${on_scene_day_of_week_index} IN (5, 6)
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
    description: "The probability of an ED diversion based on the diversion category"
    type: number
    sql:  CASE
      WHEN ${diversion_category} = 'ed_same_complaint' THEN  0.0
      WHEN ${diversion_category} = 'not completed' THEN 0.0
      WHEN ${diversion_category} = 'escalated' THEN  0
      WHEN ${diversion_category} = 'smfr/wmfr' THEN  1.0
      WHEN ${diversion_category} = 'home health' THEN  .9
      WHEN ${diversion_category} = 'snf' THEN 1.0
      WHEN ${diversion_category} = 'provider group' THEN .5
      WHEN ${diversion_category} = 'senior care - weekdays before 3pm' THEN .5
      WHEN ${diversion_category} = 'senior care - weekdays after 3pm and weekends' THEN  1.0
      WHEN ${diversion_category} = 'survey responded emergency room' THEN   1.0
      WHEN ${diversion_category} = 'survey responded not emergency room' THEN  0.0
      WHEN ${diversion_category} = 'no survey' THEN ROUND(CAST(${ed_diversion_survey_response_rate_clone.er_percent} AS numeric), 3)
        ELSE 0.0
      END ;;
  }


  #.89 comes from this report: https://dispatchhealth.looker.com/explore/dashboard/care_requests?qid=kYQK5B33hMS9mlBhfjwJJl&toggle=fil
  dimension: ed_diversion_adj {
    type: number
    sql: case when ${followup_30day} then ${ed_diversion}
         else ${ed_diversion}*0.89 end;;
  }

  dimension: 911_diversion {
    type: number
    description: "The probability of a 911 diversion based on the diversion category"
    sql:  CASE
      WHEN ${diversion_category} = 'ed_same_complaint' THEN  0
      WHEN ${diversion_category} = 'escalated' THEN  0
      WHEN ${diversion_category} = 'not completed' THEN 0
      WHEN ${diversion_category} = 'smfr/wmfr' THEN 1.0
      WHEN ${diversion_category} = 'home health' THEN .5
      WHEN ${diversion_category} = 'snf' THEN 1.0
      WHEN ${diversion_category} = 'senior care - weekdays before 3pm' THEN  .5
      WHEN ${diversion_category} = 'senior care - weekdays after 3pm and weekends' THEN  1.0
        ELSE 0.0
      END;;
  }

  #.89 comes from this report: https://dispatchhealth.looker.com/explore/dashboard/care_requests?qid=kYQK5B33hMS9mlBhfjwJJl&toggle=fil
  dimension: 911_diversion_adj {
    type: number
    sql: case when ${followup_30day} then ${911_diversion}
              else ${911_diversion}*0.89 end;;
  }

  dimension: hospital_diversion {
    type: number
    sql: ${ed_diversion_adj} * 0.05;;
  }


  measure: est_vol_ed_diversion {
    type: sum_distinct
    sql_distinct_key:  concat(${care_request_id}, ${followup_30day}) ;;
    value_format: "#,##0"
    sql: ${ed_diversion_adj};;

  }

  measure: est_vol_hospital_diversion {
    type: sum_distinct
    sql_distinct_key:  concat(${care_request_id}, ${followup_30day}) ;;
    value_format: "#,##0"
    sql: ${hospital_diversion};;

  }


  measure: est_vol_911_diversion {
    type: sum_distinct
    sql_distinct_key:  concat(${care_request_id}, ${followup_30day}) ;;
    value_format: "#,##0"
    sql: ${911_diversion_adj};;

  }

  measure: est_ed_diversion_savings {
    type: sum_distinct
    sql_distinct_key:  concat(${care_request_id}, ${followup_30day});;
    value_format: "$#,##0"
    sql: ${ed_diversion_adj} * 2000;;

  }

  measure: est_911_diversion_savings {
    type: sum_distinct
    sql_distinct_key: concat(${care_request_id}, ${followup_30day}) ;;
    value_format: "$#,##0"
    sql: ${911_diversion_adj} * 750;;

  }

  measure: est_hospital_diversion_savings {
    type: sum_distinct
    sql_distinct_key: concat(${care_request_id}, ${followup_30day}) ;;
    value_format: "$#,##0"
    sql: ${hospital_diversion} * 12000;;
  }

  measure: est_diversion_savings {
    type: sum_distinct
    sql_distinct_key: concat(${care_request_id}, ${followup_30day}) ;;
    value_format: "$#,##0"
    sql: ${911_diversion_adj} * 750 + ${ed_diversion_adj} * 2000 + ${hospital_diversion} *12000;;

  }
  dimension: patient_age_month {
    type: number
    sql:  extract(year from age(${care_requests.created_raw}, ${patients.created_raw}))*12 + extract(month from age(${care_requests.created_raw},  ${patients.created_raw})) ;;
  }

  dimension: patient_age_month_min_complete_date {
    type: number
    sql:  extract(year from age(${care_requests.created_raw}, ${min_patient_complete_visit.min_complete_raw}))*12 + extract(month from age(${care_requests.created_raw},  ${min_patient_complete_visit.min_complete_raw})) ;;
  }

  dimension: patient_age_month_absolute {
    type: number
    sql:  extract(year from age('2018-10-01', ${patients.created_raw}))*12 + extract(month from age('2018-10-01',  ${patients.created_raw})) ;;
  }
  dimension: secondary_screening {
    type: yesno
    sql: ${secondary_screenings.care_request_id} is not null;;
  }

  dimension_group: now_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month, time_of_day,raw]
    sql:  now();;
  }

  dimension: created_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${created_mountain_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_mountain_raw} ) AS FLOAT)) / 60);;
  }

  dimension: now_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${now_mountain_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${now_mountain_raw} ) AS FLOAT)) / 60);;
  }

  dimension: before_now {
    type: yesno
    sql: ${created_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: max_time_mountain_predictions {
    type: number
    sql:  case when ${markets.id} in(159, 160, 167) then 21
               when ${markets.id} in(164, 168) then 19
               when ${markets.id} in(166, 169, 165) then 20
               when ${markets.id} in(162, 170, 161) then 22
              else 21 end;;
  }

  dimension: prediction_elgible {
    type: yesno
    sql: ${created_mountain_decimal} < ${max_time_mountain_predictions} ;;
  }

  dimension: origin_phone_not_populated {
    type: yesno
    sql: ${origin_phone} IS NULL
         OR LENGTH(${origin_phone}) = 0
        OR (${origin_phone}) = '';;
  }

  measure: origin_phone_populated_count {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${care_request_id} ;;
    filters: {
      field: origin_phone_not_populated
      value: "no"
    }
  }
  measure: percent_origin_phone_populated {
    type: number
    value_format: "0%"
    sql: ${origin_phone_populated_count}::float/${care_request_count}::float ;;

  }

  dimension: contact_id_not_populated {
    type: yesno
    sql: ${contact_id} IS NULL;;
  }

  measure: contact_id_populated_count {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${care_request_id} ;;
    filters: {
      field: contact_id_not_populated
      value: "no"
    }
  }
  measure: percent_contact_id_populated {
    type: number
    value_format: "0%"
    sql: ${contact_id_populated_count}::float/${care_request_count}::float ;;

  }

  dimension: new_patient_first_visit {
    description: "Flags a patient that had their first visit date occurr within the date range of the filtered population (patient may have 1+ visits in range)."
    type: yesno
    sql: ${first_visit_date} = ${on_scene_date};;
  }

  measure: count_new_patient_first_visits {
    description: "Counts the number of distinct patients visited for the first time wihtin the date range of the fitered population (patient may have 1+ visits in range)"
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: new_patient_first_visit
      value: "yes"
    }
  }

  dimension: return_patient {
    description: "Determines a patient that has been visited more than one time on separate days"
    type: yesno
    sql: ${first_visit_date} != ${on_scene_date};;
  }

  measure: count_return_patients {
    description: "Count of the number of distinct patients that have been visited more than one time by DH on separate days"
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: return_patient
      value: "yes"
    }
  }

  measure: count_return_patient_visits {
    description: "Counts the number visits associated with a repeat patient for spearate days"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: return_patient
      value: "yes"
    }
  }


}

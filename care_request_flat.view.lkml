include: "care_request_flat_user.view.lkml"

view: care_request_flat {
  extends: [care_request_flat_user]


  dimension: self_report_primary_package_id {
    type: number
    sql: ${TABLE}.package_id ;;
  }


  measure: complete_count_seasonal_adj {
    type: number
    value_format: "#,##0"
    sql: (${complete_count}/${seasonal_adj.seasonal_adj})/${days_in_month_adj.days_in_month_adj} ;;
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

  dimension: drive_time_seconds_google {
    type: number
    sql: ${TABLE}.drive_time_seconds ;;
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

  dimension: in_queue_time_minutes {
    type: number
    description: "The number of minutes between requested time and accepted time"
    sql: (EXTRACT(EPOCH FROM ${accept_raw})-EXTRACT(EPOCH FROM ${created_raw}))::float/60.0 ;;
    value_format: "0.00"
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

  measure:  median_drive_time_minutes{
    type: median_distinct
    description: "The median number of minutes between on-route time and on-scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes} ;;
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

  measure: count_distinct_days_created {
    type: count_distinct
    sql_distinct_key: ${created_date} ;;
    sql: ${created_date} ;;

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
      hour
      ]
    sql: ${TABLE}.on_scene_date ;;
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

  dimension: on_scene_decimal {
    description: "The on-scene time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: accepted_decimal {
    description: "The accepted time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${accept_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accept_raw} ) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  measure: first_accepted_decimal {
    description: "The first accepted time of day, represented as a decimal"
    type: min
    sql: ${accepted_decimal} ;;
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

  dimension: lwbs_going_to_ed {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: Going to an Emergency Department%' ;;
  }

  dimension: lwbs_going_to_urgent_care {
    type: yesno
    sql: LOWER(${archive_comment}) LIKE '%going to an urgent care%' ;;
  }

  dimension: lwbs_wait_time_too_long {
    type: yesno
    sql: ${archive_comment} LIKE '%Wait time too long%' ;;
  }

  dimension: lwbs_no_longer_need_care {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: No longer need care%' ;;
  }

  dimension: cancelled_by_patient_reason {
    type: yesno
    sql: ${primary_resolved_reason} = 'Cancelled by Patient' ;;
  }

  dimension: lwbs {
    type: yesno
    description: "Going to ED/Urgent Care, Wait Time Too Long, No Longer Need Care"
    sql: ${lwbs_going_to_ed} OR ${lwbs_going_to_urgent_care} OR
      ${lwbs_wait_time_too_long} OR ${lwbs_no_longer_need_care} ;;
  }

  dimension: resolved_no_answer_no_show {
    type: yesno
    sql: ${archive_comment} LIKE '%No Answer%' OR ${archive_comment} LIKE '%No Show%';;
  }

  dimension: resolved_911_divert {
    type: yesno
    sql: ${archive_comment} LIKE '%911 Divert%' ;;
  }

  dimension: resolved_other {
    type: yesno
    sql:  ${complete_date} IS NULL AND ((${lwbs} IS NOT TRUE AND ${escalated_on_phone} IS NOT TRUE AND ${resolved_911_divert} IS NOT TRUE AND ${resolved_no_answer_no_show} IS NOT TRUE)
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
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
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
    sql: ${lwbs_count}::float/nullif(${care_request_count},0) ;;

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
    sql: ${archive_comment} LIKE '%Referred - Phone Triage%' ;;
  }

  dimension: escalated_on_phone_ed {
    type: yesno
    sql: ${archive_comment} LIKE '%Referred - Phone Triage: ED%' ;;
  }


  measure: escalated_on_phone_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
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

  measure: escalated_on_phone_ed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
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

  measure: escalated_on_phone_ed_percent_yellow{
    type: number
    sql: ${risk_assessments.count_yellow_escalated_phone}::float/(nullif(${risk_assessments.count_yellow},0))::float ;;
    value_format: "0%"
  }


  measure: escalated_on_phone_ed_percent_red{
    type: number
    sql:  ${risk_assessments.count_red_escalated_phone}::float/(nullif(${risk_assessments.count_red},0))::float ;;
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

  measure: complete_count_flu {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: icd_code_dimensions_clone.likely_flu_diganosis
      value: "yes"
    }
  }

  measure: flu_percent {
    type: number
    value_format: "0.0%"
    sql: ${complete_count_flu}::float/nullif(${complete_count}::float,0);;
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

  measure: min_complete_timestamp {
    type: date_time
    sql: min(${complete_raw}) ;;
  }

  measure: max_complete_timestamp {
    type: date_time
    sql: max(${complete_raw}) ;;
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
      WHEN lower(${cars.name}) = lower('SMFR_Car') THEN
        'smfr'
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
    type: number
    sql:  CASE
      WHEN ${diversion_category} = 'ed_same_complaint' THEN  0.0
      WHEN ${diversion_category} = 'not completed' THEN 0.0
      WHEN ${diversion_category} = 'escalated' THEN  0
      WHEN ${diversion_category} = 'smfr' THEN  1.0
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
    sql:  CASE
      WHEN ${diversion_category} = 'ed_same_complaint' THEN  0
      WHEN ${diversion_category} = 'escalated' THEN  0
      WHEN ${diversion_category} = 'not completed' THEN 0
      WHEN ${diversion_category} = 'smfr' THEN 1.0
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

}

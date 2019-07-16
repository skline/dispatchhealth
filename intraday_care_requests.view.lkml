view: intraday_care_requests {
  sql_table_name: public.intraday_care_requests ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: accepted {
    type: yesno
    sql: ${accepted_time} is not null;;
  }

  dimension: complete {
    type: yesno
    sql: ${complete_time} is not null or lower(${archive_comment}) like '%referred - point of care%';;
  }

  dimension: escalated_on_scene {
    type: yesno
    sql: lower(${archive_comment}) like '%referred - point of care%';;
  }
  dimension: complete_accepted_inqueue{
    sql: case when ${complete} then 'complete'
              when ${accepted} and not ${resolved} then 'accepted'
              when ${current_status} = 'requested' and not ${resolved} and not ${stuck_inqueue} and not ${accepted} then 'inqueue'
              else null end;;
  }

  dimension: resolved {
    type: yesno
    sql: ${complete_time} is null and (${archived_time} is not null and lower(${archive_comment}) not like '%referred - point of care%');;
  }


  dimension: meta_data {
    type: string
    sql: ${TABLE}.meta_data ;;
  }

  dimension: etos {
    type: number
    sql: (${TABLE}.meta_data ->> 'etos')::int ;;
  }

  dimension: channel_item_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'channel_item_id')::int ;;
  }

  dimension: market_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'market_id')::int ;;
  }

  dimension: package_id {
    type: number
    sql: case when (${TABLE}.meta_data ->> 'package_id')='' then 9999999999999999
    else (${TABLE}.meta_data ->> 'package_id')::int end;;
  }

  dimension: shift_team_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'shift_team_id')::int ;;
  }

  dimension: current_status {
    type: string
    sql: ${TABLE}.meta_data ->> 'current_status' ;;
  }

  dimension: complete_comment {
    type: string
    sql: ${TABLE}.meta_data ->> 'complete_comment' ;;
  }

  dimension: archive_comment {
    type: string
    sql: ${TABLE}.meta_data ->> 'archived_status_comments' ;;
  }

  dimension: service_line_id {
    type: number
    sql: ${TABLE}.meta_data ->> 'service_line_id' ;;
  }

  dimension: zipcode {
    type: string
    sql: left(${TABLE}.meta_data ->> 'zipcode',5);;
  }

  dimension: smfr_care_request{
    type: yesno
    sql:  ${zipcode} in('80122', '80123', '80124', '80125', '80126', '80128', '80134', '80135', '80138', '80210', '80222', '80224', '80231', '80235', '80237', '80013', '80014', '80015', '80016', '80018', '80104', '80110', '80111', '80112', '80120', '80121');;
  }


  dimension: care_request_location {
    type: location
    sql_latitude: ${TABLE}.meta_data ->> 'latitude' ;;
    sql_longitude: ${TABLE}.meta_data ->> 'longitude' ;;
  }

  dimension_group: etc {
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
    sql: (meta_data->>'etc')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: care_request_created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week
    ]
    sql: (meta_data->>'created_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: accepted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day, day_of_week
    ]
    sql: (meta_data->>'accepted_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: complete {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day, day_of_week
    ]
    sql: (meta_data->>'completed_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: archived {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
       hour_of_day, day_of_week
    ]
    sql: (meta_data->>'archived_at')::timestamp WITH TIME ZONE ;;
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
      year,
      hour_of_day, day_of_week
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: stuck_inqueue {
    type: yesno
    sql: ${care_request_id} in(64317) ;;
  }
  measure: inqueue_crs {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }
  }

  measure: inqueue_crs_tricare {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }

  }

  measure: inqueue_smfr_elgible {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: smfr_care_request
      value: "yes"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }


  }

  dimension: uhc_care_request {
    type: yesno
    sql:${channel_item_id} in(2851, 2849, 2850, 2852, 2848, 2890, 2900);;
  }

  measure: inqueue_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }

  }

  measure: resolved_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: resolved
      value: "yes"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }

  }

  measure: accepted_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "yes"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }
    filters: {
      field: resolved
      value: "no"
    }
  }

  measure: complete_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }
  }

  measure: inqueue_crs_medicaid {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MAID)MEDICAID"
    }

  }

  measure: inqueue_crs_pafu {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: service_lines_intra.id
      value: "2,6"
    }

  }

  measure: inqueue_crs_medicaid_tricare {
    type: number
    sql:  ${inqueue_crs_medicaid}+${inqueue_crs_tricare};;
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${care_request_id} ;;
  }

  dimension: accepted_today {
    type: yesno
    sql: ${accepted_date} = date(now() AT TIME ZONE 'US/Mountain') ;;
  }

  dimension: accepted_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${accepted_raw} AT TIME ZONE 'US/Mountain') AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accepted_raw} AT TIME ZONE 'US/Mountain' ) AS FLOAT)) / 60);;
  }

  dimension: care_request_created_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${care_request_created_raw} AT TIME ZONE 'US/Mountain') AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${care_request_created_raw} AT TIME ZONE 'US/Mountain' ) AS FLOAT)) / 60);;
  }

  dimension: complete_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${complete_raw} AT TIME ZONE 'US/Mountain') AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_raw} AT TIME ZONE 'US/Mountain' ) AS FLOAT)) / 60);;
  }
  dimension_group: now_mountain{
    type: time
    convert_tz: no
    timeframes: [day_of_week_index, week, month, day_of_month, time_of_day,raw]
    sql:  now() AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: now_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${now_mountain_raw} ) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${now_mountain_raw} ) AS FLOAT)) / 60);;
  }

  dimension: before_now_accepted {
    type: yesno
    sql: ${accepted_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: before_now_created {
    type: yesno
    sql: ${care_request_created_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: before_now_complete {
    type: yesno
    sql: ${complete_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: created_to_now_diff_hours {
    type: number
    sql: EXTRACT(EPOCH FROM ${now_mountain_raw} - (${care_request_created_raw} AT TIME ZONE 'US/Mountain'))/3600 ;;
  }

 # dimension: inqueue_over_hour {
#    type: yesno
#    sql:  ;;
#  }



  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: visit_facts {
  sql_table_name: jasperdb.visit_facts ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
      year
    ]
    sql: ${TABLE}.accepted_time ;;
  }

  dimension: car_dim_id {
    type: number
    sql: ${TABLE}.car_dim_id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: channel_dim_id {
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.chief_complaint ;;
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
      year
    ]
    sql: ${TABLE}.complete_time ;;
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

  dimension: csc_shift_id {
    type: string
    sql: ${TABLE}.csc_shift_id ;;
  }

  dimension: day_14_followup_outcome {
    type: string
    sql: ${TABLE}.day_14_followup_outcome ;;
  }

  dimension: day_30_followup_outcome {
    type: string
    sql: ${TABLE}.day_30_followup_outcome ;;
  }

  dimension: day_3_followup_outcome {
    type: string
    sql: ${TABLE}.day_3_followup_outcome ;;
  }

  dimension: emt_shift_id {
    type: string
    sql: ${TABLE}.emt_shift_id ;;
  }

  dimension: facility_type_dim_id {
    type: number
    sql: ${TABLE}.facility_type_dim_id ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: letter_recipient_dim_id {
    type: number
    sql: ${TABLE}.letter_recipient_dim_id ;;
  }

  dimension: letter_sent {
    type: yesno
    sql: ${TABLE}.letter_sent ;;
  }

  dimension_group: local_accepted {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_accepted_time ;;
  }

  dimension_group: local_complete {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_complete_time ;;
  }

  dimension_group: local_on_route {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_on_route_time ;;
  }

  dimension_group: local_on_scene {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_on_scene_time ;;
  }

  dimension_group: local_requested {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_requested_time ;;
  }

  dimension: location_dim_id {
    type: number
    sql: ${TABLE}.location_dim_id ;;
  }

  dimension: visit_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: new_patient {
    type: yesno
    sql: ${TABLE}.new_patient ;;
  }

  dimension: no_charge_entry_reason {
    type: string
    sql: ${TABLE}.no_charge_entry_reason ;;
  }

  dimension: nppa_shift_id {
    type: string
    sql: ${TABLE}.nppa_shift_id ;;
  }

  dimension_group: on_route {
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
    sql: ${TABLE}.on_route_time ;;
  }

  dimension_group: on_scene {
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
    sql: ${TABLE}.on_scene_time ;;
  }

  dimension: other_resolve_reason {
    type: string
    sql: ${TABLE}.other_resolve_reason ;;
  }

  dimension: patient_dim_id {
    type: number
    sql: ${TABLE}.patient_dim_id ;;
  }

  dimension: patient_employer_dim_id {
    type: number
    sql: ${TABLE}.patient_employer_dim_id ;;
  }

  dimension: provider_dim_id {
    type: number
    sql: ${TABLE}.provider_dim_id ;;
  }

  dimension: request_type_dim_id {
    type: number
    sql: ${TABLE}.request_type_dim_id ;;
  }

  dimension_group: requested {
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
    sql: ${TABLE}.requested_time ;;
  }

  dimension: resolve_reason {
    type: string
    sql: ${TABLE}.resolve_reason ;;
  }

  dimension: resolved {
    type: yesno
    sql: ${TABLE}.resolved ;;
  }

  measure: count_resolved_requests {
    type: count
    filters: {
      field: resolved
      value: "yes"
    }

    drill_fields: [details*]
  }

  measure: count_complete_visits {
    type: count
    filters: {
      field: resolved
      value: "no"
    }

    drill_fields: [details*]
  }

  dimension: secondary_resolve_reason {
    type: string
    sql: ${TABLE}.secondary_resolve_reason ;;
  }

  dimension: seconds_in_queue {
    type: number
    sql: ${TABLE}.seconds_in_queue ;;
  }

  dimension: minutes_in_queue {
    type: number
    sql: 1.0 * ${TABLE}.seconds_in_queue / 60 ;;
  }

  dimension: seconds_of_travel_time {
    type: number
    sql: ${TABLE}.seconds_of_travel_time ;;
  }

  dimension: seconds_on_scene {
    type: number
    sql: ${TABLE}.seconds_on_scene ;;
  }

  dimension: hours_on_scene {
    type: number
    sql: 1.0 * ${seconds_on_scene} / 3600 ;;
  }

  dimension: total_acct_receivable_payments {
    type: number
    sql: ${TABLE}.total_acct_receivable_payments ;;
  }

  dimension: total_acct_receivable_transactions {
    type: number
    sql: ${TABLE}.total_acct_receivable_transactions ;;
  }

  dimension: total_charge {
    type: number
    sql: ${TABLE}.total_charge ;;
  }

  dimension: total_expected_allowable {
    type: number
    sql: ${TABLE}.total_expected_allowable ;;
  }

  dimension: total_rvus {
    type: number
    sql: ${TABLE}.total_rvus ;;
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
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: visit_dim_number {
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: work_rvus {
    type: number
    sql: ${TABLE}.work_rvus ;;
  }

  dimension: billable_visit {
    type: yesno
    sql: ${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL ;;
  }

  dimension: non_smfr_billable_visit {
    type: yesno
    sql: ${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL AND ${car_dimensions.car_name} != 'SMFR_Car';;
  }

  measure: count {
    type: count
    drill_fields: [details*]
  }

  measure: count_of_billable_visits {
    type: count
    filters: {
      field: billable_visit
      value: "yes"
    }

    drill_fields: [details*]
  }

  measure: count_of_non_smfr_billable_visits {
    type: count
    filters: {
      field: non_smfr_billable_visit
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: resolved_request {
    type: yesno
    sql: ${resolved} IS TRUE ;;
  }

  measure: count_of_resolved_requests {
    type: count
    filters: {
      field: resolved
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: on_scene_visits {
    type: yesno
    sql: ${resolved} = 'no' AND ${resolved_seen_flag} = 'yes' ;;
  }

  measure: count_of_on_scene_visits {
    type: count
    filters: {
      field: on_scene_visits
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: in_queue {
    type: yesno
    sql: ${local_requested_date} IS NOT NULL AND
         ${local_accepted_date} IS NOT NULL ;;
  }

  dimension: in_accepted_queue {
    type: yesno
    sql: ${local_accepted_date} IS NOT NULL AND ${local_on_route_date} IS NOT NULL ;;
  }

  dimension: in_on_route_queue {
    type: yesno
    sql: ${local_on_route_date} IS NOT NULL AND ${local_on_scene_date} IS NOT NULL ;;
  }

  dimension: in_on_scene_queue {
    type: yesno
    sql: ${local_on_scene_date} IS NOT NULL AND ${local_complete_date} IS NOT NULL ;;
  }

  measure: average_time_in_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: average_time_in_accepted_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_accepted_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: average_time_in_on_route_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_on_route_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: average_time_in_on_scene_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_on_scene_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  #Sum("Completed Flag", 'Current') + Sum("Resolved-Seen Flag", 'Current')

  measure: average_on_scene_time {
    type: average
    sql: ${hours_on_scene} ;;
    drill_fields: [details*]
    value_format_name: decimal_2
  }
  dimension: diversion_category {
    type: string
    sql: CASE
WHEN ${visit_facts.local_complete_time} IS NULL THEN 'not completed'
WHEN ${visit_facts.day_30_followup_outcome} IN ( 'ed_same_complaint', 'hospitalization_same_complaint' )
  OR
  ${visit_facts.day_14_followup_outcome} IN( 'ed_same_complaint', 'hospitalization_same_complaint' )
  OR
  ${visit_facts.day_3_followup_outcome} IN( 'ed_same_complaint', 'hospitalization_same_complaint') THEN 'ed_same_complaint'
WHEN ${car_dimensions.car_name} = 'SMFR_Car' THEN
  'smfr'
WHEN ${channel_dimensions.sub_type} IN( 'home health',
                    'snf',
                    'provider group' ) THEN channel_dimensions.sub_type
WHEN ${channel_dimensions.sub_type} = 'senior care'
  AND
  hour(${visit_dimensions.local_visit_time}) < 15
  AND
  dayofweek(${visit_dimensions.local_visit_date}) NOT IN ( 1,
                                         7 ) THEN 'senior care - weekdays before 3pm'
WHEN ${channel_dimensions.sub_type} = 'senior care'
  AND
  (
    hour(${visit_dimensions.local_visit_time}) > 15
    OR
    dayofweek(${visit_dimensions.local_visit_date}) IN ( 1,
                                       7 )
  )
  THEN 'senior care - weekdays after 3pm and weekends'
WHEN ${ed_diversion_survey_response.answer_selection_value} = 'Emergency Room' THEN 'survey responded emergency room'
WHEN ${ed_diversion_survey_response.answer_selection_value} != 'Emergency Room'
  AND
  ${ed_diversion_survey_response.answer_selection_value} IS NOT NULL THEN 'survey responded not emergency room'
WHEN ${ed_diversion_survey_response.answer_selection_value} IS NULL THEN
  'no survey'
ELSE 'other'
END;;
  }

  dimension: ed_diversion {
    type: number
    sql:  CASE
WHEN ${diversion_category} = 'ed_same_complaint' THEN  0
WHEN ${diversion_category} = 'not completed' THEN 0
WHEN ${diversion_category} = 'smfr' THEN  1
WHEN ${diversion_category} = 'home health' THEN  .9
WHEN ${diversion_category} = 'snf' THEN 1
WHEN ${diversion_category} = 'provider group' THEN .5
WHEN ${diversion_category} = 'senior care - weekdays before 3pm' THEN .5
WHEN ${diversion_category} = 'senior care - weekdays after 3pm and weekends' THEN  1.0
WHEN ${diversion_category} = 'survey responded emergency room' THEN   1.0
WHEN ${diversion_category} = 'survey responded not emergency room' THEN  0
WHEN ${diversion_category} = 'no survey' THEN ${ed_diversion_survey_response_rate.er_percent}
  ELSE '?'
END ;;
  }

  dimension: 911_diversion {
    type: number
    sql:  CASE
WHEN ${diversion_category} = 'smfr' THEN 1
WHEN ${diversion_category} = 'home health' THEN .5
WHEN ${diversion_category} = 'snf' THEN 1
WHEN ${diversion_category} = 'senior care - weekdays before 3pm' THEN  .5
WHEN ${diversion_category} = 'senior care - weekdays after 3pm and weekends' THEN  1.0
  ELSE 0
END;;
  }

  measure: est_vol_ed_diversion {
    type: sum
    sql: round(${ed_diversion},1);;

  }

  measure: est_vol_911_diversion {
    type: sum
    sql: round(${911_diversion}, 1);;

  }

  measure: est_ed_diversion_savings {
    type: sum
    sql: round(${ed_diversion} * 2000,2);;

  }

  measure: est_911_diversion_savings {
    type: sum
    sql: round(${911_diversion} * 750,2);;

  }

  measure: est_diversion_savings {
    type: sum
    sql: round(${911_diversion} * 750 + ${ed_diversion} * 2000,2);;

  }

  dimension: resolved_seen_flag {
    type: yesno
    sql: ${resolved} IS TRUE and ${local_on_scene_time} IS NOT NULL ;;
  }

  measure: count_of_resolved_seen {
    type: count
    filters: {
      field: resolved_seen_flag
      value: "yes"
    }

    drill_fields: [details*]
  }

  set: details {
    fields: [id, hours_on_scene, total_charge]
  }

}

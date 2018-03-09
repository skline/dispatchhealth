view: care_requests {
  sql_table_name: public.care_requests ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: accepted_order {
    type: number
    sql: ${TABLE}.accepted_order ;;
  }

  dimension: activated_by {
    type: string
    sql: ${TABLE}.activated_by ;;
  }

  dimension: appointment_type {
    type: string
    sql: ${TABLE}.appointment_type ;;
  }

  dimension: centura_connect_aco {
    type: string
    sql: ${TABLE}.centura_connect_aco ;;
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
  }

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension: chrono_visit_id {
    type: string
    sql: ${TABLE}.chrono_visit_id ;;
  }

  dimension: consent_signature {
    type: string
    sql: ${TABLE}.consent_signature ;;
  }

  dimension: consenter_name {
    type: string
    sql: ${TABLE}.consenter_name ;;
  }

  dimension: consenter_relationship {
    type: string
    sql: ${TABLE}.consenter_relationship ;;
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
      year, day_of_month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created_mountain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.created_at - interval '7 hour';;
  }
  dimension: credit_card_consent {
    type: yesno
    sql: ${TABLE}.credit_card_consent ;;
  }

  dimension: data_use_consent {
    type: yesno
    sql: ${TABLE}.data_use_consent ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: dispatch_queue_id {
    type: number
    sql: ${TABLE}.dispatch_queue_id ;;
  }

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }

  dimension_group: eta {
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
    sql: ${TABLE}.eta ;;
  }

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension: market_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.market_id ;;
  }

  dimension_group: on_accepted_eta {
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
    sql: ${TABLE}.on_accepted_eta ;;
  }

  dimension_group: on_route_eta {
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
    sql: ${TABLE}.on_route_eta ;;
  }

  dimension_group: on_scene_etc {
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
    sql: ${TABLE}.on_scene_etc ;;
  }

  dimension_group: on_scene_etc_mountain {
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
    sql: ${TABLE}.on_scene_etc - interval '7 hour' ;;
  }



  dimension: orig_city {
    type: string
    sql: ${TABLE}.orig_city ;;
  }

  dimension: orig_latitude {
    type: number
    sql: ${TABLE}.orig_latitude ;;
  }

  dimension: orig_longitude {
    type: number
    sql: ${TABLE}.orig_longitude ;;
  }

  dimension: orig_state {
    type: string
    sql: ${TABLE}.orig_state ;;
  }

  dimension: orig_street_address_1 {
    type: string
    sql: ${TABLE}.orig_street_address_1 ;;
  }

  dimension: orig_street_address_2 {
    type: string
    sql: ${TABLE}.orig_street_address_2 ;;
  }

  dimension: orig_zipcode {
    type: string
    sql: ${TABLE}.orig_zipcode ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: place_of_service {
    type: string
    sql: ${TABLE}.place_of_service ;;
  }

  dimension_group: prioritized {
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
    sql: ${TABLE}.prioritized_at ;;
  }

  dimension: prioritized_by {
    type: string
    sql: ${TABLE}.prioritized_by ;;
  }

  dimension: priority_note {
    type: string
    sql: ${TABLE}.priority_note ;;
  }

  dimension: privacy_policy_consent {
    type: yesno
    sql: ${TABLE}.privacy_policy_consent ;;
  }

  dimension_group: prompted_survey {
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
    sql: ${TABLE}.prompted_survey_at ;;
  }

  dimension_group: pulled {
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
    sql: ${TABLE}.pulled_at ;;
  }

  dimension_group: pushed {
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
    sql: ${TABLE}.pushed_at ;;
  }

  dimension: request_type_id {
    type: number
    sql: ${TABLE}.request_type ;;
  }

  dimension: request_type {
    type: string
    sql:  case when ${request_type_id} = 0 then 'phone'
               when ${request_type_id} = 1 then 'manual_911'
               when ${request_type_id} = 2 then 'mobile'
               when ${request_type_id} = 3 then 'web'
               when ${request_type_id} = 4 then 'mobile_android'
               when ${request_type_id} = 5 then 'centura_connect'
               when ${request_type_id} = 6 then 'centura_care_coordinator'
               when ${request_type_id} = 7 then 'orderly'
            else 'other' end;;
  }

  dimension: requested_by {
    type: number
    sql: ${TABLE}.requested_by ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: treatment_consent {
    type: yesno
    sql: ${TABLE}.treatment_consent ;;
  }

  dimension: triage_note_salesforce_id {
    type: string
    sql: ${TABLE}.triage_note_salesforce_id ;;
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

  dimension: use_as_billing_address {
    type: yesno
    sql: ${TABLE}.use_as_billing_address ;;
  }

  dimension_group: verbal_consent {
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
    sql: ${TABLE}.verbal_consent_at ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct {
   type: number
   sql: count(distinct ${id}) ;;
  }


  dimension:  complete_visit {
    type: yesno
    sql: ${care_request_complete.care_request_id} is not null;;
  }

  dimension:  archived_visit {
    type: yesno
    sql: ${care_request_archived.care_request_id} is not null;;
  }


  dimension:  referred_point_of_care {
    type: yesno
    sql: ${care_request_archived.comment} like '%Referred - Point of Care%';;
  }

  dimension:  billable_est {
    type: yesno
    sql: ${referred_point_of_care} or ${care_requests.complete_visit};;
  }

  measure: count_billable_est {
    type: count
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  dimension: smfr_billable {
    type: yesno
    sql: ${cars.name} LIKE '%SMFR%' AND ${billable_est};;
  }

  measure: count_smfr_billable {
    type: count
    filters: {
      field: smfr_billable
      value: "yes"
    }
  }

  dimension:  accepted_visit {
    type: yesno
    sql: ${care_request_accepted.care_request_id} is not null;;
  }

  dimension:  requested_visit {
    type: yesno
    sql: ${care_request_requested.care_request_id} is not null;;
  }


dimension_group: today_mountain{
  type: time
  timeframes: [day_of_week_index, week, month, day_of_month]
  sql: current_date;;
}

dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }




dimension:  same_day_of_week {
  type: yesno
  sql:  ${yesterday_mountain_day_of_week_index}= ${created_mountain_day_of_week_index};;
}

dimension: until_today {
    type: yesno
    sql: ${created_mountain_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${created_mountain_day_of_week_index} >= 0 ;;
  }

dimension: this_week {
  type:  yesno
  sql: ${yesterday_mountain_week} =  ${created_mountain_week};;
}

  dimension: this_month {
    type:  yesno
    sql: ${yesterday_mountain_month} =  ${created_mountain_month};;
  }
measure: distinct_days {
  type: number
  sql: count(DISTINCT ${created_mountain_date}) ;;
}

  dimension: month_to_date  {
    type:  yesno
    sql: ${created_mountain_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension: current_day_string {
    type: string
    sql:trim(to_char(current_date - interval '1 day', 'day')) ;;
  }
  measure: distinct_weeks {
    type: number
    sql: count(DISTINCT ${created_mountain_week}) ;;
  }

  measure: distinct_months {
    type: number
    sql: count(DISTINCT ${created_mountain_month}) ;;
  }


  measure: daily_average {
    type: number
    sql: ${count}/${distinct_days} ;;
  }


  measure: weekly_average {
    type: number
    sql: ${count}/${distinct_weeks} ;;
  }

  measure: monthly_average {
    type: number
    sql: ${count}/${distinct_months} ;;
  }
  measure: min_day {
    type: date
    sql: min(${created_mountain_date}) ;;
  }

  measure: max_day {
    type: date
    sql:max(${created_mountain_date}) ;;
  }

  measure: min_week {
    type: string
    sql: min(${created_mountain_week}) ;;
  }

  measure: max_week {
    type: string
    sql:max(${created_mountain_week}) ;;
  }
  measure: min_month {
    type: string
    sql: min(${created_mountain_month}) ;;
  }

  measure: max_month {
    type: string
    sql:max(${created_mountain_month}) ;;
  }


  measure: min_max_range_day {
    type: string
    sql:
  case when ${min_week} =  ${yesterday_mountain_week} then ${min_day}::text
  else concat(${current_day_string}, 's ', ${min_day}, ' thru ', ${max_day}) end ;;

  }

  measure: min_max_range_week {
    type: string
    sql:
      case when ${min_week} =  ${yesterday_mountain_week} then concat(${min_day}, ' thru ', ${max_day})
      else concat('Week to date for weeks ', ${min_week}, ' thru ', ${max_week}) end ;;

    }

  measure: min_max_range {
    type: string
    sql: concat(${min_day}, ' thru ', ${max_day});;

    }
  dimension: care_request_patient_create_diff {
    type: number
    sql:EXTRACT(EPOCH FROM (${created_mountain_raw}- ${patients.created_mountain_raw} )) ;;
  }

  dimension: new_care_request_bool {
    type:  yesno
    sql:  ${care_request_patient_create_diff}< 4000 ;;
  }

  dimension: marketing_meta_data {
    type: string
    sql:  ${TABLE}.marketing_meta_data;;
  }

  dimension: ga_client_id {
    type: string
    sql: (${TABLE}.marketing_meta_data->>'ga_client_id')::text ;;
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      ehr_name,
      consenter_name,
      markets.id,
      markets.name,
      markets.provider_group_name,
      markets.short_name,
      credit_cards.count
    ]
  }
}

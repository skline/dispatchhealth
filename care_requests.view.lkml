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
    sql: CASE
          WHEN ${TABLE}.activated_by LIKE 'Other:%' THEN 'Other'
          ELSE initcap(replace(${TABLE}.activated_by, '’', ''))
        END ;;
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

  dimension: chief_complaint_trimmed {
    type: string
    sql: trim(lower(${chief_complaint})) ;;
  }

  dimension: post_acute_follow_up {
    type: yesno
    description: "Chief complaint, risk protocol name, or channel name is post-acute follow-up"
    sql:  ${chief_complaint_trimmed} SIMILAR TO '%(pafu|post acute|post-acute)%' OR
          ${risk_assessments.protocol_name} = 'Post-Acute Patient' OR
          ${channel_items.name} SIMILAR TO '%(pafu|post acute|post-acute)%';;
  }

  dimension: follow_up {
    type: yesno
    description: "The word follow-up or follow up occurs in Chief Complaint"
    sql:  ${chief_complaint_trimmed} SIMILAR TO '%(follow-up|follow up)%' ;;
  }


  measure: placeholder1 {
    type: number
    sql: NULL ;;
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

  dimension: credit_card_completed {
    type: yesno
    sql: ${credit_cards.care_request_id} IS NOT NULL ;;
  }

  measure: count_credit_card_completed {
    type: count
    sql: ${TABLE}.id ;;
    filters: {
      field: credit_card_completed
      value: "yes"
    }
  }

  dimension: credit_card_error {
    type: yesno
    sql: ${credit_card_errors.care_request_id} IS NOT NULL ;;
  }

  measure: count_credit_card_errors {
    type: number
    sql: COUNT(${credit_card_errors.care_request_id}) ;;
  }

  dimension: credit_card_attempted {
    type: yesno
    sql: ${credit_card_error} OR ${credit_card_completed} ;;
  }

  measure: count_credit_attempted {
    type: count
    sql: ${TABLE}.id ;;
    filters: {
      field: credit_card_attempted
      value: "yes"
    }
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
    convert_tz: no
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
    sql: ${TABLE}.created_at  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: pre_post {
    type: yesno
    sql: ${created_mountain_raw} BETWEEN '2018-04-02'::TIMESTAMP AND '2018-04-13'::TIMESTAMP ;;
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

  dimension_group: on_route_eta_mountain {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_route_eta AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
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
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_scene_etc AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: on_scene_etc_local {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_scene_etc AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: actual_minus_etc {
    type: number
    sql: CASE
          WHEN ABS((EXTRACT(EPOCH FROM ${care_request_flat.complete_raw}) - EXTRACT(EPOCH FROM ${on_scene_etc_local_raw}))::float/60.0) < 720
          THEN (EXTRACT(EPOCH FROM ${care_request_flat.complete_raw}) - EXTRACT(EPOCH FROM ${on_scene_etc_local_raw}))::float/60.0
          ELSE NULL
        END
          ;;
    value_format: "0.00"
  }

  dimension: actual_minus_etc_tier {
    type: tier
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${actual_minus_etc} ;;
  }

  measure: avg_actual_minus_etc {
    type: average
    sql: ${actual_minus_etc} ;;
    value_format: "0.00"
  }

  measure: median_actual_minus_etc {
    type: median
    sql: ${actual_minus_etc} ;;
    value_format: "0.00"
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

  measure: count_distinct_patients {
    type: count_distinct
    sql: ${patient_id} ;;
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

  measure: count_distinct_pre_logistics {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: care_request_flat.post_logistics_flag
      value: "no"
    }
  }

  measure: count_distinct_post_logistics {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: care_request_flat.post_logistics_flag
      value: "yes"
    }
  }


  dimension:  complete_visit {
    type: yesno
    sql: ${care_request_flat.complete_date} is not null;;
  }

  dimension:  archived_visit {
    type: yesno
    sql: ${care_request_flat.archive_date} is not null;;
  }

  dimension: complete_visit_with_procedure {
    type: yesno
    sql: ${complete_visit} AND ${cpt_code_dimensions_clone.non_em_cpt_flag} ;;
  }

  measure: count_complete_visit_with_procedures {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: complete_visit_with_procedure
      value: "yes"
    }
  }

  dimension:  referred_point_of_care {
    type: yesno
    sql: ${care_request_flat.complete_comment} like '%Referred - Point of Care%';;
  }

  dimension:  billable_est {
    type: yesno
    sql: ${referred_point_of_care} or ${care_requests.complete_visit};;
  }

  dimension:  billable_with_cpt {
    type: yesno
    sql: ${billable_est} AND ${cpt_code_dimensions_clone.cpt_code_flag};;
  }

  dimension: billable_actual {
    type: yesno
    sql: ${billable_est} AND ${athenadwh_appointments_clone.no_charge_entry_reason} IS NULL ;;
  }

  measure: count_billable_est {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    drill_fields: [
      athenadwh_referral_providers.name,
      athenadwh_referral_providers.provider_category,
      count_billable_est
    ]
  }

  measure: count_optimum_drive_time {
    type: count_distinct
    description: "Count of complete visits where drive time < 20 minutes"
    sql: ${id} ;;
    filters: {
      field: care_request_flat.under_20_minute_drive_time
      value: "yes"
    }
  }

  measure: count_visits_with_onscene_meds {
    type: count_distinct
    description: "Count of completed care requests where medications were administered"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: athenadwh_documents_clone.medicine_administered_onscene
      value: "yes"
    }
  }

  measure: count_visits_with_onscene_labs {
    type: count_distinct
    description: "Count of completed care requests where labs were performed on-scene"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: athenadwh_lab_imaging_providers.provider_category
      value: "Performed On-Scene"
    }
    filters: {
      field: athenadwh_lab_imaging_results.document_class
      value: "LABRESULT"
    }
  }

  measure: count_visits_with_third_party_labs {
    type: count_distinct
    description: "Count of completed care requests where labs were performed by 3rd party"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: athenadwh_lab_imaging_providers.provider_category
      value: "Performed by Third Party"
    }
    filters: {
      field: athenadwh_lab_imaging_results.document_class
      value: "LABRESULT"
    }
  }

  measure: count_billable_actual {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations where Athena no charge entry reason is NULL"
    sql: ${id} ;;
    filters: {
      field: billable_actual
      value: "yes"
    }
    drill_fields: [
      athenadwh_referral_providers.name,
      athenadwh_referral_providers.provider_category,
      count_billable_est
    ]
  }

  measure: count_auto_assigned {
    type: count_distinct
    description: "Count of auto-assigned care requests"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: care_request_flat.auto_assigned_final
      value: "true"
    }
  }

  measure: count_auto_assignment_overridden {
    type: count_distinct
    description: "Count of overridden auto-assigned care requests"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: care_request_flat.auto_assignment_overridden
      value: "true"
    }
  }

  measure: count_visits_prescriptions {
    type: count_distinct
    description: "Count of completed care requests where 1 or more prescriptions were written"
    sql: ${id} ;;
    filters: {
     field: athenadwh_prescriptions.prescriptions_flag
    value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_visits_labs {
    type: count_distinct
    description: "Count of completed care requests where 1 or more labs were ordered"
    sql: ${id} ;;
    filters: {
      field: athenadwh_clinical_results_clone.labs_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_visits_imaging {
    type: count_distinct
    description: "Count of completed care requests where imaging was ordered"
    sql: ${id} ;;
    filters: {
      field: athenadwh_lab_imaging_results.imaging_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_visits_dme {
    type: count_distinct
    description: "Count of completed care requests where durable medical equipment was ordered"
    sql: ${id} ;;
    filters: {
      field: athenadwh_dme.dme_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_home_health_referrals {
    type: count_distinct
    description: "Count of completed care requests where a home health referral was made"
    sql: ${id} ;;
    filters: {
      field: athenadwh_orders.home_health_referrals_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_provider_referrals {
    type: count_distinct
    description: "Count of completed care requests where a referral to a provider was made"
    sql: ${id} ;;
    filters: {
      field: athenadwh_orders.provider_referrals_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }


  measure: count_billable_with_cpt {
    type: count
    description: "Count of completed care requests OR on-scene escalations that include a CPT code"
    filters: {
      field: billable_with_cpt
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
    sql: ${care_request_flat.accept_date} is not null;;
  }

  dimension:  requested_visit {
    type: yesno
    sql: ${care_request_flat.requested_date} is not null;;
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

dimension: dashboard_image {
  sql: ('https://s3.amazonaws.com/dispatchhealth-analytics/Dispatch-Desktop-Dashboard-R3-Blank.png')  ;;
}

dimension: client_overview_image {
  sql: ${dashboard_image} ;;
  html:<img src={{value}} width="1200" height="672" alt="DispatchHealth"> ;;
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

measure: distinct_day_of_week {
  type: count_distinct
  sql: ${created_mountain_day_of_week_index} ;;
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

  measure: max_on_scene_time {
    label: "Last Care Request Completed Time"
    type: date_time
    sql:  max(${care_request_flat.complete_time}::timestamp) ;;
  }

  measure: min_on_route_time {
    label: "First Care Request On Route Time"
    type: date_time
    sql:  min(${care_request_flat.on_route_time}::timestamp) ;;
  }

  measure: shift_end_last_cr_diff{
    label: "Hours between Last Patient Seen and Shift End "
    type: number
    sql:  round(((EXTRACT(EPOCH FROM ${max_on_scene_time}::timestamp - ${care_request_flat.shift_end_time}::timestamp))/3600)::decimal,2);;
  }

  measure: shift_start_first_on_route_diff{
    label: "Hours Between Shift Start and First On Route"
    type: number
    sql:  round(((EXTRACT(EPOCH FROM ${min_on_route_time}::timestamp - ${care_request_flat.shift_start_time}::timestamp))/3600)::decimal,2);;
  }

  measure: shift_end_last_cr_diff_adj{
    label: "Hours between Last Patient Seen and Shift End Adj"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    sql:  case when  ${shift_end_last_cr_diff} > 18.0  then ${shift_end_last_cr_diff} - 24.0
               when  ${shift_end_last_cr_diff} < -18.0 then ${shift_end_last_cr_diff} + 24.0
           else ${shift_end_last_cr_diff} end;;
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
    sql:  (${care_request_patient_create_diff}< (60*60) or ${visit_facts_clone.new_patient}=1) ;;
  }

  dimension: marketing_meta_data {
    type: string
    sql:  ${TABLE}.marketing_meta_data;;
  }

  dimension: ga_client_id {
    type: string
    sql: (${TABLE}.marketing_meta_data->>'ga_client_id')::text ;;
  }

  dimension: origin_phone {
    type: string
    sql:  ${TABLE}.origin_phone;;
  }

  dimension: origin_phone_not_populated {
    type: yesno
    sql: care_requests.origin_phone IS NULL
         OR LENGTH(care_requests.origin_phone) = 0
        OR (care_requests.origin_phone) = '';;
  }

  measure: origin_phone_populated_count {
    type: count_distinct
    sql_distinct_key: ${id} ;;
    sql: ${id} ;;
    filters: {
      field: origin_phone_not_populated
      value: "no"
    }
  }
  measure: percent_origin_phone_populated {
    type: number
    value_format: "0%"
    sql: ${origin_phone_populated_count}::float/${count}::float ;;

  }

  dimension: contact_id_not_populated {
    type: yesno
    sql: care_requests.contact_id IS NULL
         OR LENGTH(care_requests.contact_id) = 0
        OR (care_requests.contact_id) = '';;
  }

  measure: contact_id_populated_count {
    type: count_distinct
    sql_distinct_key: ${id} ;;
    sql: ${id} ;;
    filters: {
      field: origin_phone_not_populated
      value: "no"
    }
  }
  measure: percent_contact_id_populated {
    type: number
    value_format: "0%"
    sql: ${contact_id_populated_count}::float/${count}::float ;;

  }


  dimension: days_in_month {
    type: number
    sql:  DATE_PART('days',
        DATE_TRUNC('month', ${created_mountain_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) ;;
  }

  measure: resolved_reason {
    type: string
    sql:array_agg(distinct concat(${care_request_flat.archive_comment}, ${care_request_flat.complete_comment}))::text ;;
  }
  measure: min_complete_timestamp_mountain {
    type: date_time
    sql: min(${care_request_complete.created_mountain_raw}) ;;
  }
  dimension: resolved_reason_full {
    type: string
    sql: coalesce(${care_request_flat.complete_comment}, ${care_request_flat.archive_comment}) ;;
  }

  dimension: primary_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 1)) ;;
  }

  dimension: secondary_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 2)) ;;
  }

  dimension: primary_and_secondary_resolved_reason {
    type: string
    sql: concat(${primary_resolved_reason},': ', ${secondary_resolved_reason}) ;;
  }

  dimension: other_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 3)) ;;
  }

  dimension: other_resolved_booked {
    type: yesno
    description: "A flag indicating resolved - booked for the day"
    sql: LOWER(${other_resolved_reason}) LIKE '%booked%' ;;
  }


  dimension: escalated_on_scene {
    type: yesno
    sql: UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE%' ;;
  }

  dimension: lwbs_going_to_ed {
    type: yesno
    sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: Going to an Emergency Department' ;;
  }

  dimension: lwbs_going_to_urgent_care {
    type: yesno
    sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: Going to an Urgent Care' ;;
  }

  dimension: lwbs_wait_time_too_long {
    type: yesno
    sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: Wait time too long' ;;
  }

  dimension: lwbs_no_show {
    type: yesno
    sql: ${care_request_flat.archive_comment} = 'No Show' ;;
  }

  dimension: lwbs {
    type: yesno
    description: "Going to ED/Urgent Care, Wait Time Too Long, or No Show"
    sql: ${lwbs_going_to_ed} OR ${lwbs_going_to_urgent_care} OR ${lwbs_wait_time_too_long} OR ${lwbs_no_show} ;;
  }

  measure: lwbs_count {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    drill_fields: [care_request_flat.archive_comment]
  }

  measure: escalated_on_scene_count {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: escalated_on_scene
      value: "yes"
    }
  }


  dimension: escalated_on_scene_ed {
    type: yesno
    sql: ${care_request_flat.complete_comment} = 'Referred - Point of Care: ED'
      OR ${care_request_flat.complete_comment} = 'Referred - Point of care: ED';;
  }

  dimension: escalated_on_phone {
    type: yesno
    sql: ${care_request_flat.complete_comment} LIKE '%Referred - Phone Triage%' ;;
  }

  dimension: escalated_on_phone_reason {
    type: string
    sql: CASE
          WHEN ${escalated_on_phone} THEN split_part(${care_request_complete.comment}, ':', 2)
          ELSE NULL
        END ;;
  }
  dimension: contact_id {
    type: number
    sql: case
          when ${TABLE}.contact_id ='' then null
          else ${TABLE}.contact_id::bigint
         end;;
  }

  dimension: no_credit_card_reason {
    type: string
    sql:${TABLE}.no_credit_card_reason ;;
  }

  dimension: no_credit_card_reason_other {
    type: string
    sql:${TABLE}.no_credit_card_reason_other ;;
  }

  dimension: no_credit_card_collected {
    type: yesno
    hidden: yes
    sql: ${no_credit_card_reason} = '' IS FALSE;;
  }

  measure: count_no_credit_card_collected {
    type: count_distinct
    description: "Count of care requests where no credit card was collected"
    sql: ${id} ;;
    filters: {
      field: no_credit_card_collected
      value: "yes"
    }
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

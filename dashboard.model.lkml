connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project


explore: care_requests {

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }

  # Join all cloned tables from the BI database -- DE,
  join: visit_facts_clone {
    view_label: "Visit Facts relevant ID's used for matching"
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${visit_facts_clone.care_request_id} ;;
  }

  join: visit_dimensions_clone {
    relationship: many_to_one
    sql_on: ${care_requests.id} = ${visit_dimensions_clone.care_request_id} ;;
  }

  join: transaction_facts_clone {
    relationship: one_to_many
    sql_on: ${transaction_facts_clone.visit_dim_number} = ${visit_dimensions_clone.visit_number}  ;;
  }

#   join: charge_dimensions_clone {
#     relationship: one_to_one
#     sql_on: ${transaction_facts_clone.athena_charge_id} = ${charge_dimensions_clone.athena_charge_id} ;;
#   }

  join: cpt_code_dimensions_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.cpt_code_dim_id} = ${cpt_code_dimensions_clone.id} ;;
  }

# Not much information here -- unclear if this is necessary
#   join: cpt_em_references_clone {
#      relationship: one_to_one
#     sql_on: ${cpt_em_references_clone.cpt_code} = ${cpt_code_dimensions_clone.cpt_code} ;;
#   }

  join: icd_visit_joins_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.visit_dim_number} = ${icd_visit_joins_clone.visit_dim_number} ;;
  }

  join: icd_code_dimensions_clone {
    relationship: many_to_one
    sql_on: ${icd_code_dimensions_clone.id} = CAST(${icd_visit_joins_clone.icd_dim_id} AS INT) ;;
  }

  join: letter_recipient_dimensions_clone {
    relationship:  many_to_one
    sql_on: ${letter_recipient_dimensions_clone.id} = ${visit_facts_clone.letter_recipient_dim_id} ;;
  }

  join: payer_dimensions_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.primary_payer_dim_id} = ${primary_payer_dimensions_clone.id}  ;;
  }

  join: primary_payer_dimensions_clone {
    relationship: one_to_one
    sql_on: ${transaction_facts_clone.primary_payer_dim_id} = ${primary_payer_dimensions_clone.id} ;;
  }

#   join: pcp_dimensions_clone {
#   sql_on: ??? ;;
#   }

#   join: shift_planning_facts_clone {
#     sql_on: ${shift_planning_facts_clone.car_dim_id} = ${visit_facts_clone.car_dim_id} ;;
#   }

  join: app_shift_planning_facts_clone {
    view_label: "APP Shift Information"
    from: shift_planning_facts_clone
    type: full_outer
    relationship: many_to_one
    sql_on: TRIM(UPPER(${app_shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(trim(${users.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
            ${app_shift_planning_facts_clone.local_actual_start_date} = ${visit_dimensions_clone.local_visit_date} ;;
    sql_where: ${app_shift_planning_facts_clone.schedule_role} LIKE '%Training%' OR
               ${app_shift_planning_facts_clone.schedule_role} LIKE '%NP/PA%' OR
               ${care_requests.id} IS NOT NULL ;;
    }

  join: dhmt_shift_planning_facts_clone {
    view_label: "DHMT Shift Information"
    from: shift_planning_facts_clone
    type: full_outer
    relationship: many_to_one
    sql_on: TRIM(UPPER(${dhmt_shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(${users.first_name},'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
            ${dhmt_shift_planning_facts_clone.local_actual_start_date} = ${visit_dimensions_clone.local_visit_date} AND
            ${dhmt_shift_planning_facts_clone.schedule_role} IN ('DHMT', 'EMT') AND
            ${dhmt_shift_planning_facts_clone.car_dim_id} IS NOT NULL ;;
  }

  join: survey_responses_flat_clone {
    relationship: one_to_one
    sql_on: ${survey_responses_flat_clone.visit_dim_number} = ${visit_facts_clone.visit_dim_number};;
  }

  # End cloned BI table joins
  ############################

  join: addressable_items {
    relationship: one_to_one
    sql_on: ${addressable_items.addressable_type} = 'CareRequest' and ${care_requests.id} = ${addressable_items.addressable_id};;
  }
  join: addresses {
    relationship: one_to_one
    sql_on:  ${addressable_items.address_id} = ${addresses.id} ;;
  }

  join: credit_cards {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${credit_cards.care_request_id} ;;
  }

  join: care_request_distances {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_distances.care_request_id} ;;
  }

  join: care_request_consents {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_consents.care_request_id} ;;
  }

  join: care_team_members {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${care_team_members.care_request_id} ;;
  }

  join: credit_card_errors {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${credit_card_errors.care_request_id} ;;
  }

  join: shift_teams {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  }

  join: shift_team_members {
    relationship: many_to_one
    sql_on: ${shift_team_members.shift_team_id} = ${shift_teams.id} ;;
  }

  join: shifts{
    relationship: many_to_one
    sql_on:  ${shift_teams.shift_id}  =  ${shifts.id};;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_teams.car_id} = ${cars.id} ;;
  }

  join: users {
    relationship: one_to_one
    sql_on:  ${shift_team_members.user_id} = ${users.id};;
  }

  join: csc_user_roles {
    relationship: one_to_many
    from: user_roles
    sql_on: ${bill_processors.user_id} = ${csc_user_roles.user_id} ;;
  }

  join: csc_users {
    relationship: one_to_one
    from: roles
    sql_on: ${csc_user_roles.role_id} = ${csc_users.id} ;;
  }

  join: bill_processors {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${bill_processors.care_request_id} ;;
  }

  join: csc_names {
    relationship: one_to_many
    from: users
    sql_on: ${bill_processors.user_id} = ${csc_names.id} ;;
  }

  join: provider_profiles {
    relationship: one_to_one
    sql_on: ${provider_profiles.user_id} = ${users.id} ;;
  }

  join: dhmt_names {
    view_label: "DHMT Names"
    from: users
    relationship: one_to_one
    sql_on: ${users.id} = ${provider_profiles.user_id} AND ${provider_profiles.position} = 'emt' ;;
  }

  join: app_names {
    view_label: "Advanced Practice Provider Names"
    from: users
    relationship: one_to_one
    sql_on: ${users.id} = ${provider_profiles.user_id} AND ${provider_profiles.position} = 'advanced practice provider' ;;
  }

  join: risk_assessments {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${risk_assessments.care_request_id} and ${risk_assessments.score} is not null ;;
  }

  join: markets {
    relationship: one_to_one
    sql_on: ${care_requests.market_id} = ${markets.id} ;;
  }

  join: states {
    relationship: one_to_one
    sql_on: ${markets.state} = ${states.abbreviation} ;;
  }

  join: insurances {
    relationship: many_to_one
    sql_on: ${care_requests.patient_id} = ${insurances.patient_id} AND ${insurances.priority} = '1' AND ${insurances.patient_id} IS NOT NULL ;;
  }

  join: insurance_plans {
    relationship: many_to_one
    sql_on: ${insurances.package_id} = ${insurance_plans.package_id} AND ${insurances.company_name} = ${insurance_plans.name} AND ${insurance_plans.state_id} = ${states.id};;
  }

  join: insurance_classifications {
    relationship: many_to_one
    sql_on: ${insurance_plans.insurance_classification_id} = ${insurance_classifications.id} ;;
  }

  join: care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
  }

  join: care_request_requested{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_requested.care_request_id} = ${care_requests.id} and ${care_request_requested.name}='requested';;
  }

  join: care_request_accepted{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_accepted.care_request_id} = ${care_requests.id} and ${care_request_accepted.name}='accepted';;
  }

  join: care_request_archived{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='archived';;
  }

  join: care_request_scheduled{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_scheduled.care_request_id} = ${care_requests.id} and ${care_request_scheduled.name}='scheduled';;
  }

  join: care_request_flat {
    relationship: one_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: timezones {
    relationship: many_to_one
    sql_on: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  }

  join: budget_projections_by_market_clone {
    sql_on: ${care_requests.market_id} = ${budget_projections_by_market_clone.market_dim_id}
      AND ${care_request_flat.on_scene_month}=${budget_projections_by_market_clone.month_month};;
  }

  join: patients {
    sql_on:  ${patients.id} =${care_requests.patient_id} ;;
  }

  join: eligible_patients {
    relationship: one_to_one
    sql_on:
    UPPER(concat(${eligible_patients.first_name}::text, ${eligible_patients.last_name}::text, to_char(${eligible_patients.dob_raw}, 'MM/DD/YY'), ${eligible_patients.gender}::text)) =
    UPPER(concat(${patients.first_name}::text, ${patients.last_name}::text, to_char(${patients.dob}, 'MM/DD/YY'),
      CASE WHEN ${patients.gender} = 'Female' THEN 'F'
      WHEN ${patients.gender} = 'Male' THEN 'M'
      ELSE ''
      END)) ;;
  }

  join: power_of_attorneys {
    sql_on:  ${patients.id} =${power_of_attorneys.patient_id} ;;
  }

  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: patient_payer_lookup{
    relationship: one_to_one
    sql_on: ${patients.id} = ${patient_payer_lookup.dashboard_patient_id}  ;;
  }

  join: primary_payer_packages {
    relationship: one_to_many
    sql_on: ${patient_payer_lookup.primary_payer_dim_id} = ${primary_payer_packages.primary_payer_dim_id} ;;
  }

join: invoca_clone {
sql_on: ((${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null)
        OR (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null)
        )
        and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
        ;;

}
join: ga_pageviews_clone {
  sql_on:
    abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
          and ${ga_pageviews_clone.client_id} = ${invoca_clone.analytics_vistor_id}  ;;

  }

  join: web_ga_pageviews_clone {
    from: ga_pageviews_clone
    sql_on:
    abs(EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})-EXTRACT(EPOCH FROM ${web_ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
      and care_requests.marketing_meta_data->>'ga_client_id' = ${web_ga_pageviews_clone.client_id}  ;;

    }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;
  }
  join: ga_experiments {
    sql_on: ${ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id}
            OR
            ${web_ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id} ;;
  }

  join: ga_adwords_stats_clone {
    sql_on: (${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw})
      OR (${ga_adwords_stats_clone.client_id} = ${web_ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${web_ga_pageviews_clone.timestamp_raw});;
  }

  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_stats_clone.adwordscampaignid}  ;;
  }

  join: ad_groups_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
  }
  join: shift_hours_by_day_market_clone {
    sql_on:  ${markets.name} = ${shift_hours_by_day_market_clone.market_name}
      and ${care_request_flat.complete_date} = ${shift_hours_by_day_market_clone.date_date};;
  }

  join: shift_hours_market_month {
    from: shift_hours_by_day_market_clone
    sql_on:  ${markets.name} = ${shift_hours_market_month.market_name}
      and ${care_request_flat.complete_month} = ${shift_hours_market_month.date_month};;
  }

  join: ga_adwords_cost_clone {
    sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
            and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
            and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
            and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
                  and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}

            ;;
  }
}

explore: shift_planning_facts_clone {

  join: shift_planning_shifts_clone {
    relationship: one_to_one
    sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_shifts_clone.shift_id} and ${shift_planning_shifts_clone.imported_after_shift} = 1 ;;
  }

  join: shift_team_visits {
    relationship: one_to_many
    sql_on: TRIM(UPPER(${shift_planning_facts_clone.clean_employee_name})) =
    replace(upper(trim(regexp_replace(replace(trim(${shift_team_visits.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${shift_team_visits.last_name})), '''', '') AND
    ${shift_planning_facts_clone.local_actual_start_date}= ${shift_team_visits.complete_date_date};;
  }

  join: care_request_flat {
    relationship: one_to_many
    sql_on: ${care_request_flat.care_request_id} = ${shift_team_visits.care_request_id};;
  }

}

explore: productivity_data_clone {

  join: markets {
    relationship: many_to_one
    sql_on: ${productivity_data_clone.market_dim_id} = ${markets.id} ;;
    }

  join: shift_planning_facts_clone {
    relationship: one_to_many
    sql_on: ${productivity_data_clone.date_date} = ${shift_planning_facts_clone.local_actual_start_date} AND
            ${markets.humanity_id} = ${shift_planning_facts_clone.schedule_location_id} ;;
  }

  join: shift_planning_shifts_clone {
    relationship: one_to_one
    sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_shifts_clone.shift_id} and ${shift_planning_shifts_clone.imported_after_shift}=1 ;;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_planning_facts_clone.car_dim_id} = ${cars.id} ;;
  }

  # join: timezones {
  #   relationship: many_to_one
  #   sql: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  # }

  join: shift_teams {
    relationship: one_to_one
    sql_on: ${shift_teams.car_id} = ${shift_planning_facts_clone.car_dim_id} AND
            ${shift_planning_facts_clone.local_actual_start_date} = (${shift_teams.start_date}- INTERVAL '6 hour') ;;
  }

  join: shifts{
    relationship: one_to_one
    sql_on:  ${shift_teams.shift_id}  =  ${shifts.id};;
  }

  join: users {
    relationship: one_to_many
    sql_on: TRIM(UPPER(${shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(trim(${users.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
            ${shift_planning_facts_clone.local_actual_start_date} = ${productivity_data_clone.date_date} ;;
  }

  join: shift_team_members {
    relationship: one_to_many
    sql_on: ${shift_team_members.user_id} = ${users.id} ;;
  }

  join: care_requests {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  }

  join: care_request_flat {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_flat.care_request_id} ;;
  }

}

explore: channel_items {
  join: care_requests {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: channels {
    relationship: many_to_one
    sql_on:  ${channels.id} = ${channel_items.channel_id};;
  }
  join: markets {
    relationship: many_to_one
    sql_on: ${channels.market_id} = ${markets.id} ;;
  }
  join: sales_force_implementation_score_recent {
    relationship: one_to_one
    sql_on: ${sales_force_implementation_score_recent.channel_item_id} = ${channel_items.id} ;;
  }

}

explore: invoca_clone {


  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;
    sql_where: ${invoca_clone.utm_medium} !='self report' ;;
  }

  join: patients {
    sql_on:   ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null   ;;
  }

  join: care_requests {
    sql_on: (${patients.id} = ${care_requests.patient_id}  OR ${care_requests.origin_phone} = ${invoca_clone.caller_id})
      and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5);;
  }

  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }


  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: markets {
    sql_on:  ${markets.id} =${invoca_clone.market_id} ;;
  }

  join: ga_pageviews_clone {
    sql_on:
    ${invoca_clone.analytics_vistor_id} = ${ga_pageviews_clone.client_id}
  and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
    ;;
  }

  join: ga_experiments {
    sql_on: ${ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id};;

  }


  join: ga_adwords_stats_clone {
    sql_on:
    ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw};;
  }

  join: ga_adwords_cost_clone {
    sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
            and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
            and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
            and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
                  and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}
            ;;
  }


  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_stats_clone.adwordscampaignid}  ;;
  }

  join: adwords_ad_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordscreativeid} = ${adwords_ad_clone.ad_id} ;;
  }

  join: ad_groups_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
  }




}

explore: ga_pageviews_full_clone {
  label: "GA explore"


  join: invoca_clone {
    type:  full_outer
    sql_on:
    abs(
        EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_full_clone.timestamp_mst_raw})) < (60*60*1.5)
          and ${ga_pageviews_full_clone.client_id} = ${invoca_clone.analytics_vistor_id}  ;;
    sql_where:  ${invoca_clone.start_date} >'2018-03-15'
      OR ${ga_pageviews_full_clone.timestamp_time} is not null;;
  }

  join: marketing_cost_clone {
    sql_on:   ${ga_pageviews_full_clone.source_final} = ${marketing_cost_clone.type}
              and ${ga_pageviews_full_clone.timestamp_mst_date} =${marketing_cost_clone.date_date}
              and ${ga_pageviews_full_clone.medium_final}  in('cpc', 'paid search', 'paidsocial', 'ctr', 'image_carousel', 'static_image', 'display', 'nativedisplay')

            ;;
  }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;
  }

  join: ga_experiments {
    sql_on: ${ga_pageviews_full_clone.exp_id} = ${ga_experiments.exp_id};;

  }

  join: ga_adwords_stats_clone {
    sql_on: ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_full_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_full_clone.timestamp_raw};;
  }

  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_stats_clone.adwordscampaignid}  ;;
  }

  join: ad_groups_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
  }


  join: patients {
    sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
  }

  join: ga_geodata_clone {
    sql_on: ${ga_pageviews_full_clone.client_id} = ${ga_geodata_clone.client_id}
    and ${ga_pageviews_full_clone.timestamp_raw} = ${ga_geodata_clone.timestamp_raw};;
  }

  join: ga_zips_clone {
    sql_on: ${ga_geodata_clone.latitude} = ${ga_zips_clone.latitude}
      and  ${ga_geodata_clone.longitude} = ${ga_zips_clone.longitude};;
  }


  join: web_care_requests {
    from: care_requests
    sql_on:
        (
          abs(EXTRACT(EPOCH FROM ${ga_pageviews_full_clone.timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
          AND
          web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_full_clone.client_id}
         ) ;;
  }

  join: care_requests {
    sql_on:
        (
          (
            ${patients.id} = ${care_requests.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
          OR
          (
            ${care_requests.origin_phone} = ${invoca_clone.caller_id}
            and
            ${care_requests.origin_phone} is not null
          )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
        );;
  }



  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: web_care_request_flat {
    from: care_request_flat
    relationship: many_to_one
    sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
  }



  join: markets {
    sql_on:  ${markets.id} = ${ga_pageviews_full_clone.market_id} ;;
  }


  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} or ${channel_items.id} =${web_care_requests.channel_item_id};;
  }

}

explore: ga_pageviews_clone {
  label: "Facebook Paid Explore"

  join: facebook_paid_performance_clone {
    type:  full_outer
    sql_on: ${facebook_paid_performance_clone.market_id} = ${ga_pageviews_clone.facebook_market_id_final}
        AND
        ${ga_pageviews_clone.timestamp_date} = ${facebook_paid_performance_clone.start_date}
        AND
        lower(${ga_pageviews_clone.source}) in ('facebook', 'facebook.com', 'instagram', 'instagram.com')
        AND
        lower(${ga_pageviews_clone.medium}) in('image_carousel', 'paidsocial', 'ctr', 'static_image');;
  }

  join: invoca_clone {
    type: full_outer
    sql_on:

    (
      abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
      and
      ${ga_pageviews_clone.client_id} = ${invoca_clone.analytics_vistor_id}
    )
     ;;

      sql_where:
              (
                (
                  ${invoca_clone.utm_medium} in('image_carousel', 'paidsocial', 'ctr', 'static_image')
                  AND
                  lower(${invoca_clone.utm_source}) in('facebook', 'facebook.com', 'instagram', 'instagram.com')
                )
                OR
                (
                  ${invoca_clone.utm_source} like '%FB Click to Call%'
                )
                AND
                ${invoca_clone.start_date} >'2018-03-15'
              )
              OR
              (
                lower(${ga_pageviews_clone.source}) in ('facebook', 'facebook.com', 'instagram', 'instagram.com')
                AND
                lower(${ga_pageviews_clone.medium}) in('image_carousel', 'paidsocial', 'ctr', 'static_image')
              )
              OR
              ${facebook_paid_performance_clone.start_date} is not null
              ;;
    }

    join: incontact_clone {
      sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
           and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                ;;
    }

    join: patients {
      sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
    }


    join: web_care_requests {
      from: care_requests
      sql_on:
      (
        abs(EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
        AND
        web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_clone.client_id}
      ) ;;
    }

  join: care_requests {
    sql_on:
      (
        (
          ${patients.id} = ${care_requests.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
          OR
          (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
      );;
  }


    join: care_request_flat {
      relationship: many_to_one
      sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
    }

    join: web_care_request_flat {
      from: care_request_flat
      relationship: many_to_one
      sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
    }

    join: markets {
      sql_on:  ${markets.id} = ${ga_pageviews_clone.facebook_market_id_final} ;;
    }


    join: channel_items {
      sql_on:  ${channel_items.id} =${care_requests.channel_item_id} OR
                ${channel_items.id} =${web_care_requests.channel_item_id} ;;
    }

  join: ga_experiments {
    sql_on: ${ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id};;

  }

  }



  explore: ga_pageviews_bidellect {
    label: "Bidellect Explore"

    join: bidtellect_cost_clone {
      type:  full_outer
      sql_on: ${bidtellect_cost_clone.market_id} = ${ga_pageviews_bidellect.market_id}
        AND
        ${ga_pageviews_bidellect.timestamp_date} = ${bidtellect_cost_clone.hour_date}
        AND
        lower(${ga_pageviews_bidellect.source}) in ('bidtellect')
        AND
        lower(${ga_pageviews_bidellect.medium}) in('nativedisplay');;
    }

    join: invoca_clone {
      type: full_outer
      sql_on:

              (
                abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_bidellect.timestamp_raw})) < (60*60*1.5)
                and
                ${ga_pageviews_bidellect.client_id} = ${invoca_clone.analytics_vistor_id}
              )
               ;;

        sql_where:
                (
                  (
                    lower(${invoca_clone.utm_source}) in('bidtellect')
                    AND
                    lower(${invoca_clone.utm_medium}) in('nativedisplay')
                  )
                  AND
                  ${invoca_clone.start_date} >'2018-03-15'
                )
                OR
                (
                  lower(${ga_pageviews_bidellect.source}) in ('bidtellect')
                  AND
                  lower(${ga_pageviews_bidellect.medium}) in('nativedisplay')
                )
                OR
                ${bidtellect_cost_clone.hour_date} is not null
                ;;
      }

      join: incontact_clone {
        sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
                 and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                      ;;
      }

      join: patients {
        sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
      }



      join: web_care_requests {
        from: care_requests
        sql_on:
            (
              abs(EXTRACT(EPOCH FROM ${ga_pageviews_bidellect.timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
              AND
              web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_bidellect.client_id}
            ) ;;
      }

    join: care_requests {
      sql_on:
            (
              (
                ${patients.id} = ${care_requests.patient_id} and (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
                OR
                (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
              )
              AND
              abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
            );;
    }
      join: care_request_flat {
        relationship: many_to_one
        sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
      }

      join: web_care_request_flat {
        from: care_request_flat
        relationship: many_to_one
        sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
      }

      join: markets {
        sql_on:  ${markets.id} = ${ga_pageviews_bidellect.market_id_final} ;;
      }

      join: channel_items {
        sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
      }
    }



    explore: ga_adwords_stats_clone {

      join: ga_adwords_cost_clone {
        type: full_outer
        sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
                and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
                and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
                and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
                and ${ga_adwords_stats_clone.admatchtype} =${ga_adwords_cost_clone.admatchtype}
                      and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}

                ;;
      }
      join: ga_pageviews_clone {
        sql_on: ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
          and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw};;
      }

      join: adwords_campaigns_clone {
        sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_cost_clone.adwordscampaignid}  ;;
      }

      join: adwords_ad_clone {
        sql_on:  ${ga_adwords_cost_clone.adwordscreativeid} = ${adwords_ad_clone.ad_id} ;;
      }

      join: ad_groups_clone {
        sql_on:  ${ga_adwords_cost_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
      }



      join: invoca_clone {
        type: full_outer
        sql_on:
                (
                  abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_adwords_stats_clone.page_timestamp_raw})) < (60*60*1.5) and
                  ${ga_adwords_stats_clone.client_id} = ${invoca_clone.analytics_vistor_id}
                )
              ;;
        sql_where:(
            (
              (
                ${invoca_clone.utm_medium} in('paid search', 'cpc')
                AND
                ${invoca_clone.utm_source} in('google.com', 'google')
              )
              OR
              ${invoca_clone.utm_medium} in('Google Call Extension')
            )
            AND
            ${invoca_clone.start_date} >'2018-03-06'
          )
            OR
            ${ga_adwords_stats_clone.adwordscampaignid} != 0
            OR
             ${ga_adwords_cost_clone.adwordscampaignid} != 0
            ;;
      }

      join: incontact_clone {
        sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
                 and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                      ;;
      }

      join: patients {
        sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
      }

      join: web_care_requests {
        from: care_requests
        sql_on:
              (

                 abs(EXTRACT(EPOCH FROM ${ga_adwords_stats_clone.page_timestamp_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
                AND
                web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_adwords_stats_clone.client_id}
              ) ;;

        }

      join: care_requests {
        sql_on:
            (
              (
                ${patients.id} = ${care_requests.patient_id} and (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
                OR
                (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
              )
              AND
              abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)

            );;

        }


          join: care_request_flat {
            relationship: many_to_one
            sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
          }

          join: web_care_request_flat {
            from: care_request_flat
            relationship: many_to_one
            sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
          }

          join: markets {
            sql_on:  ${markets.id} =${ga_adwords_stats_clone.market_id} ;;
          }


          join: channel_items {
            sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
          }

      join: web_channel_items {
        from: channel_items
        sql_on:  ${web_channel_items.id} =${web_care_requests.channel_item_id} ;;
      }


        }

        explore: zipcodes {
          join: markets {
            sql_on: ${zipcodes.market_id} = ${markets.id} ;;
          }
        }

        explore: insurance_plans {

          join: states{
            relationship: many_to_one
            sql_on:  ${states.id} =${insurance_plans.state_id} ;;
          }

          join: insurance_classifications {
            relationship: many_to_one
            sql_on: ${insurance_plans.insurance_classification_id} = ${insurance_classifications.id} ;;
          }
        }

        explore: incontact_clone {

          join: invoca_clone {
            sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
                     and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                          ;;
          }
          join: care_requests {
            sql_on: ${care_requests.created_mountain_date} = ${incontact_clone.start_date} and ${incontact_clone.market_id} =${care_requests.market_id} ;;
          }
          join: care_request_flat {
            relationship: many_to_one
            sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
          }


          join: markets {
            sql_on:  ${markets.id} = ${incontact_clone.market_id} ;;
          }

          join: channel_items {
            sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
          }


        }

        explore: csc_survey_clone {
          join: incontact_clone {
            sql_on:  ${incontact_clone.contact_id} = ${csc_survey_clone.contact_id} ;;
          }

          join: markets {
            sql_on: ${incontact_clone.market_id} = ${markets.id} ;;
          }


        }




        # join: shift_teams {
        #   relationship: one_to_one
        #   sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
        # }

        # join: shift_team_members {
        #   relationship: one_to_many
        #   sql_on:  ${shift_teams.id} = ${shift_team_members.shift_team_id};;
        # }

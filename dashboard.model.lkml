connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: care_requests {

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }
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

  join: risk_assessments {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${risk_assessments.care_request_id} ;;
  }

  join: markets {
    relationship: one_to_one
    sql_on: ${care_requests.market_id} = ${markets.id} ;;
  }

  join: insurances {
    relationship: many_to_one
    sql_on: ${care_requests.patient_id} = ${insurances.patient_id} AND ${insurances.priority} = 1 AND ${insurances.patient_id} IS NOT NULL ;;
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

  join: care_request_local_times {
    relationship: many_to_one
    sql_on: ${care_request_local_times.care_request_id} = ${care_requests.id} ;;
  }

  join: budget_projections_by_market_clone {
    sql_on: ${care_requests.market_id} = ${budget_projections_by_market_clone.market_dim_id}
      AND ${care_request_complete.created_mountain_month}=${budget_projections_by_market_clone.month_month};;
  }

  join: patients {
    sql_on:  ${patients.id} =${care_requests.patient_id} ;;
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
            and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 172800
            ;;

    }
  join: ga_pageviews_clone {
    sql_on:
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_raw})) < 172800
              and ${ga_pageviews_clone.client_id} = ${invoca_clone.analytics_vistor_id}  ;;

    }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
       and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
            ;;
  }

  join: incontact_spot_check_by_market {
    sql_on: ${incontact_spot_check_by_market.market_id} = ${markets.id} and ${care_request_requested.created_date}=${incontact_spot_check_by_market.date_call}
            ;;
  }
  join: shift_hours_by_day_market_clone {
    sql_on:  ${markets.name} = ${shift_hours_by_day_market_clone.market_name}
    and ${care_request_complete.created_mountain_date} = ${shift_hours_by_day_market_clone.date_date};;
  }

  join: shift_hours_market_month {
    from: shift_hours_by_day_market_clone
    sql_on:  ${markets.name} = ${shift_hours_market_month.market_name}
      and ${care_request_complete.created_mountain_month} = ${shift_hours_market_month.date_month};;
  }

  join: ga_adwords_stats_clone {
    sql_on: (${ga_adwords_stats_clone.client_id} = ${invoca_clone.analytics_vistor_id} or care_requests.marketing_meta_data->>'ga_client_id' = ${ga_adwords_stats_clone.client_id})
      and ${ga_adwords_stats_clone.page_timestamp_date} = ${invoca_clone.start_date};;
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
explore: channel_items {
  join: care_requests {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
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
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
  }
  join: channels {
    relationship: many_to_one
    sql_on:  ${channels.id} = ${channel_items.channel_id};;
  }
  join: markets {
    relationship: many_to_one
    sql_on: ${channels.market_id} = ${markets.id} ;;
  }

  }

  explore: invoca_clone {


  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
       and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
            ;;
    }

    join: patients {
      sql_on:   ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null   ;;
    }

    join: care_requests {
      sql_on: (${patients.id} = ${care_requests.patient_id}  OR ${care_requests.origin_phone} = ${invoca_clone.caller_id})
                 and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 172800 ;;
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
      sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
    }

    join: channel_items {
      sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
    }

    join: markets {
      sql_on:  ${markets.id} =${invoca_clone.market_id} ;;
    }

    join: incontact_spot_check_clone {
      sql_on: ${incontact_spot_check_clone.incontact_contact_id} = ${incontact_clone.contact_id}
        ;;
    }

    join: ga_adwords_stats_clone {
      sql_on: ${ga_adwords_stats_clone.client_id} = ${invoca_clone.analytics_vistor_id}
               and ${ga_adwords_stats_clone.page_timestamp_date} = ${invoca_clone.start_date};;
    }
    join: ga_adwords_cost_clone {
      sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
      and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
      and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
      and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
            and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}

      ;;
      }
    join: ga_pageviews_clone {
      sql_on:  ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw};;
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
            EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_full_clone.timestamp_raw})) < 172800
              and ${ga_pageviews_full_clone.client_id} = ${invoca_clone.analytics_vistor_id}  ;;
    sql_where:  ${invoca_clone.start_date} >'2018-03-15'
               OR ${ga_pageviews_full_clone.timestamp_time} is not null;;


  }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
       and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
            ;;
  }


  join: patients {
    sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
  }

  join: care_requests {
    sql_on:
    (
      (
        ${patients.id} = ${care_requests.patient_id}
      OR
      (
        ${care_requests.origin_phone} = ${invoca_clone.caller_id}
        and
        ${care_requests.origin_phone} is not null
      )
    )
    AND
    abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 172800
    );;
    }

  join: web_care_requests {
    from: care_requests
    sql_on:
    (
      abs(EXTRACT(EPOCH FROM ${ga_pageviews_full_clone.timestamp_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < 172800
      AND
      web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_full_clone.client_id}
     ) ;;
  }
  join: web_care_request_complete{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${web_care_request_complete.care_request_id} = ${web_care_requests.id} and ${web_care_request_complete.name}='complete';;
    }

  join: web_care_request_archived{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${web_care_request_archived.care_request_id} = ${web_care_requests.id} and ${web_care_request_archived.name}='archived';;
    }


  join: markets {
    sql_on:  ${markets.id} = ${ga_pageviews_full_clone.market_id} ;;
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
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
  }

  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: incontact_spot_check_clone {
    sql_on: ${incontact_spot_check_clone.incontact_contact_id} = ${incontact_clone.contact_id}
      ;;
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
          abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_raw})) < 172800
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

    join: care_requests {
      sql_on:
          (
            (
              ${patients.id} = ${care_requests.patient_id}
              OR
              (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
            )
            AND
            abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 172800
          );;
    }

    join: web_care_requests {
      from: care_requests
      sql_on:
          (
            abs(EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < 172800
            AND
            web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_clone.client_id}
          ) ;;
    }

    join: markets {
      sql_on:  ${markets.id} = ${ga_pageviews_clone.facebook_market_id_final} ;;
    }

    join: care_request_complete{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
    }

    join: web_care_request_complete{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${web_care_request_complete.care_request_id} = ${web_care_requests.id} and ${web_care_request_complete.name}='complete';;
    }
    join: web_care_request_archived{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${web_care_request_archived.care_request_id} = ${web_care_requests.id} and ${web_care_request_archived.name}='archived';;
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
      sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
    }

    join: channel_items {
      sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
    }

    join: incontact_spot_check_clone {
      sql_on: ${incontact_spot_check_clone.incontact_contact_id} = ${incontact_clone.contact_id}
        ;;
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
          abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_bidellect.timestamp_raw})) < 172800
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

  join: care_requests {
    sql_on:
    (
      (
        ${patients.id} = ${care_requests.patient_id}
        OR
        (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
      )
      AND
      abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 172800
    );;
  }

  join: web_care_requests {
    from: care_requests
    sql_on:
    (
      abs(EXTRACT(EPOCH FROM ${ga_pageviews_bidellect.timestamp_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < 172800
      AND
      web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_bidellect.client_id}
    ) ;;
  }

  join: markets {
    sql_on:  ${markets.id} = ${ga_pageviews_bidellect.market_id_final} ;;
  }

  join: care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
  }

  join: web_care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${web_care_request_complete.care_request_id} = ${web_care_requests.id} and ${web_care_request_complete.name}='complete';;
  }
  join: web_care_request_archived{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${web_care_request_archived.care_request_id} = ${web_care_requests.id} and ${web_care_request_archived.name}='archived';;
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
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
  }

  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: incontact_spot_check_clone {
    sql_on: ${incontact_spot_check_clone.incontact_contact_id} = ${incontact_clone.contact_id}
      ;;
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
          abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_adwords_stats_clone.page_timestamp_raw})) < 172800 and
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

  join: care_requests {
    sql_on:
    (
      (
        ${patients.id} = ${care_requests.patient_id}
        OR
        (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
      )
      AND
      abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 172800

    );;

  }
  join: web_care_requests {
    from: care_requests
    sql_on:
    (

       abs(EXTRACT(EPOCH FROM ${ga_adwords_stats_clone.page_timestamp_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < 172800
      AND
      web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_adwords_stats_clone.client_id}
    ) ;;

  }

  join: markets {
    sql_on:  ${markets.id} =${ga_adwords_stats_clone.market_id} ;;
  }

  join: care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
  }

  join: web_care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${web_care_request_complete.care_request_id} = ${web_care_requests.id} and ${web_care_request_complete.name}='complete';;
  }

  join: web_care_request_archived{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${web_care_request_archived.care_request_id} = ${web_care_requests.id} and ${web_care_request_archived.name}='archived';;
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
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
  }

  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: incontact_spot_check_clone {
    sql_on: ${incontact_spot_check_clone.incontact_contact_id} = ${incontact_clone.contact_id}
      ;;
  }

}

explore: zipcodes {
  join: markets {
    sql_on: ${zipcodes.market_id} = ${markets.id} ;;
  }
}

explore: insurance_plans {
  join: states{
    sql_on:  ${states.id} =${insurance_plans.state_id} ;;
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

  join: markets {
    sql_on:  ${markets.id} = ${incontact_clone.market_id} ;;
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
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
  }

  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }


}

explore: csc_survey_clone {

}




  # join: shift_teams {
  #   relationship: one_to_one
  #   sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  # }

  # join: shift_team_members {
  #   relationship: one_to_many
  #   sql_on:  ${shift_teams.id} = ${shift_team_members.shift_team_id};;
  # }

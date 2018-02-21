view: adwords_combined {
    label: "combined adwords"
    # Or, you could make this view a derived table, like this:
    derived_table: {
      sql: select *
        from
        (select
case when coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%3035001518%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%7192700805%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%4804933444%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%8044950053%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%7028484443%' then 'No Number'
     else coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') end
as adword_phone_number,adwords_call_data_clone.campaign as adwords_campaign, adwords_call_data_clone.start_time as adwords_start_time, adwords_call_data_clone.end_time as adwords_end_time, adwords_call_data_clone.area_code as adwords_area_code, adwords_call_data_clone.seconds as adwords_seconds, adwords_call_data_clone.ad_group as adwords_ad_group, adwords_call_data_clone.headline as adwords_headline, adwords_call_data_clone.headline_1 as adwords_headline_1, adwords_call_data_clone.headline_2 as adwords_headline_2, adwords_call_data_clone.short_headline as adwords_short_headline, adwords_call_data_clone.long_headline as adwords_long_headline, adwords_call_data_clone.description as adwords_description, adwords_call_data_clone.desciption_1 as adwords_desciption_1, adwords_call_data_clone.description_2 as adwords_description_2, adwords_call_data_clone.display_url as adwords_display_url, adwords_call_data_clone.ad as adwords_ad, adwords_call_data_clone.path_1 as adwords_path_1, adwords_call_data_clone.path_2 as adwords_path_2, adwords_call_data_clone.bussiness_name as adwords_bussiness_name, adwords_call_data_clone.keyword_final_url as adwords_keyword_final_url, adwords_call_data_clone.search_keyword as adwords_search_keyword, adwords_call_data_clone.ad_label as adwords_ad_label, adwords_call_data_clone.quality_score as adwords_quality_score, invoca_clone.start_time as invoca_start_time, invoca_clone.profile as invoca_profile, invoca_clone.profile_campaign as invoca_profile_campaign, invoca_clone.media_type as invoca_media_type, invoca_clone.source as invoca_source, invoca_clone.promo_number_description as invoca_promo_number_description, invoca_clone.promo_number_id as invoca_promo_number_id, invoca_clone.call_result as invoca_call_result, invoca_clone.city as invoca_city, invoca_clone.region as invoca_region, invoca_clone.repeat_caller as invoca_repeat_caller, invoca_clone.caller_id as invoca_caller_id, invoca_clone.phone_type as invoca_phone_type, invoca_clone.total_duration as invoca_total_duration, invoca_clone.traffic_source as invoca_traffic_source, invoca_clone.keywords as invoca_keywords, invoca_clone.utm_campaign as invoca_utm_campaign, invoca_clone.utm_content as invoca_utm_content, invoca_clone.utm_term as invoca_utm_term, invoca_clone.adset_name as invoca_adset_name, invoca_clone.placement as invoca_placement, invoca_clone.search_type as invoca_search_type, invoca_clone.pool_type as invoca_pool_type, invoca_clone.call_record_ikd as invoca_call_record_ikd, invoca_clone.end_call as invoca_end_call, invoca_clone.adwords_click_id as invoca_adwords_click_id, invoca_clone.analytics_vistor_id as invoca_analytics_vistor_id, invoca_clone.utm_source as invoca_utm_source, invoca_clone.utm_medium as invoca_utm_medium, invoca_clone.destination_phone_number as invoca_destination_phone_number, invoca_clone.display_name_append as invoca_display_name_append, invoca_clone.first_name_append as invoca_first_name_append, invoca_clone.last_name_append as invoca_last_name_append, invoca_clone.age_range_append as invoca_age_range_append, invoca_clone.gender_append as invoca_gender_append, invoca_clone.street_address_append as invoca_street_address_append, invoca_clone.city_append as invoca_city_append, invoca_clone.state_append as invoca_state_append, invoca_clone.zip_append as invoca_zip_append, invoca_clone.country_append as invoca_country_append, invoca_clone.carrier_append as invoca_carrier_append, invoca_clone.line_type_append as invoca_line_type_append, invoca_clone.is_prepaid_append as invoca_is_prepaid_append, invoca_clone.primary_email_append as invoca_primary_email_append, invoca_clone.linked_email_append as invoca_linked_email_append, invoca_clone.househould_income_append as invoca_househould_income_append, invoca_clone.martial_status_append as invoca_martial_status_append, invoca_clone.home_owner_append as invoca_home_owner_append, invoca_clone.home_value_append as invoca_home_value_append, invoca_clone.length_residence_append as invoca_length_residence_append, invoca_clone.occupation_append as invoca_occupation_append, invoca_clone.education_append as invoca_education_append, invoca_clone.children_append as invoca_children_append, invoca_clone.high_net_worth_append as invoca_high_net_worth_append, incontact_clone.contact_type as incontact_contact_type, incontact_clone.skll_name as incontact_skll_name, incontact_clone.from_number as incontact_from_number, incontact_clone.contact_id as incontact_contact_id, incontact_clone.to_number as incontact_to_number, incontact_clone.start_time as incontact_start_time, incontact_clone.end_time as incontact_end_time, incontact_clone.duration as incontact_duration, incontact_clone.talk_time_sec as incontact_talk_time_sec, incontact_clone.contact_time_sec as incontact_contact_time_sec
from looker_scratch.adwords_call_data_clone
left join looker_scratch.incontact_clone
on abs(EXTRACT(EPOCH FROM adwords_call_data_clone.end_time)-EXTRACT(EPOCH FROM incontact_clone.end_time)) < 3
           and incontact_clone.from_number::text like  CONCAT('%', adwords_call_data_clone.area_code ,'%')
left join looker_scratch.invoca_clone
on abs(EXTRACT(EPOCH FROM adwords_call_data_clone.end_time)-EXTRACT(EPOCH FROM invoca_clone.start_time+invoca_clone.total_duration)) < 15 and
    abs(EXTRACT(EPOCH FROM adwords_call_data_clone.start_time)-EXTRACT(EPOCH FROM invoca_clone.start_time)) < 15
       and invoca_clone.caller_id::text like  CONCAT('%', adwords_call_data_clone.area_code ,'%')) combined_adwords

               ;;
        indexes: ["adword_phone_number"]
      }


    dimension: adword_phone_number {
      type: string
      sql: ${TABLE}.adword_phone_number ;;
    }

  dimension: adwords_campaign {
    type: string
    sql: ${TABLE}.adwords_campaign ;;
  }

  dimension: adwords_search_keyword {
    type: string
    sql: ${TABLE}.adwords_search_keyword ;;
  }

  dimension: patient_poa_user {
    type: string
    sql:   case  when ${patients.mobile_number} like CONCAT('%', ${adwords_combined.adword_phone_number} ,'%') then 'patient'
            when  REPLACE(${power_of_attorneys.phone}, '-', '') like  CONCAT('%', ${adwords_combined.adword_phone_number} ,'%') then 'POA'
            when  ${users.mobile_number} like CONCAT('%', ${adwords_combined.adword_phone_number} ,'%') then 'user'
            else 'none' end;;
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}.incontact_contact_id ;;
  }

}

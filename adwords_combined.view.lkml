view: adwords_combined {
    label: "combined adwords"
    # Or, you could make this view a derived table, like this:
    derived_table: {
      sql: select *
        from
        (select
case when coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%3035001518%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%7192700805%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%4804933444%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%8044950053%' or coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') like '%7028484443%' then 'No Number'
     else coalesce(invoca_clone.caller_id::text, incontact_clone.from_number::text, 'No Number') end
as adword_phone_number, adwords_call_data_clone.campaign as adwords_campaign, adwords_call_data_clone.start_time as adwords_start_time, adwords_call_data_clone.end_time as adwords_end_time, adwords_call_data_clone.area_code as adwords_area_code, adwords_call_data_clone.seconds as adwords_seconds, adwords_call_data_clone.ad_group as adwords_ad_group, adwords_call_data_clone.headline as adwords_headline, adwords_call_data_clone.headline_1 as adwords_headline_1, adwords_call_data_clone.headline_2 as adwords_headline_2, adwords_call_data_clone.short_headline as adwords_short_headline, adwords_call_data_clone.long_headline as adwords_long_headline, adwords_call_data_clone.description as adwords_description, adwords_call_data_clone.desciption_1 as adwords_desciption_1, adwords_call_data_clone.description_2 as adwords_description_2, adwords_call_data_clone.display_url as adwords_display_url, adwords_call_data_clone.ad as adwords_ad, adwords_call_data_clone.path_1 as adwords_path_1, adwords_call_data_clone.path_2 as adwords_path_2, adwords_call_data_clone.bussiness_name as adwords_bussiness_name, adwords_call_data_clone.keyword_final_url as adwords_keyword_final_url, adwords_call_data_clone.search_keyword as adwords_search_keyword, adwords_call_data_clone.ad_label as adwords_ad_label, adwords_call_data_clone.quality_score as adwords_quality_score, invoca_clone.start_time as invoca_start_time, invoca_clone.call_record_ikd as invoca_call_record_ikd, invoca_clone.source as invoca_source, invoca_clone.promo_number_description as invoca_promo_number_description, invoca_clone.original_publisher as invoca_original_publisher, invoca_clone.original_publisher_id as invoca_original_publisher_id, invoca_clone.call_segment_path as invoca_call_segment_path, invoca_clone.final_campaign as invoca_final_campaign, invoca_clone.total_key_presses as invoca_total_key_presses, invoca_clone.total_duration as invoca_total_duration, invoca_clone.total_connected_duration as invoca_total_connected_duration, invoca_clone.total_ivr_duration as invoca_total_ivr_duration, invoca_clone.transactions as invoca_transactions, invoca_clone.fees as invoca_fees, invoca_clone.profile_fees as invoca_profile_fees, invoca_clone.city as invoca_city, invoca_clone.region as invoca_region, invoca_clone.caller_id as invoca_caller_id, invoca_clone.phone_type as invoca_phone_type, invoca_clone.signal_name as invoca_signal_name, invoca_clone.revenue as invoca_revenue, invoca_clone.recording as invoca_recording, invoca_clone.display_name as invoca_display_name, invoca_clone.first_name as invoca_first_name, invoca_clone.last_name as invoca_last_name, invoca_clone.age_range as invoca_age_range, invoca_clone.email as invoca_email, invoca_clone.gender as invoca_gender, invoca_clone.address_type as invoca_address_type, invoca_clone.address as invoca_address, invoca_clone.city_append as invoca_city_append, invoca_clone.state as invoca_state, invoca_clone.zip as invoca_zip, invoca_clone.country as invoca_country, invoca_clone.carrier as invoca_carrier, invoca_clone.line_type as invoca_line_type, invoca_clone.prepaid as invoca_prepaid, invoca_clone.primary_email as invoca_primary_email, invoca_clone.household_income as invoca_household_income, invoca_clone.marital_status as invoca_marital_status, invoca_clone.own_rent as invoca_own_rent, invoca_clone.home_value as invoca_home_value, invoca_clone.length_residence as invoca_length_residence, invoca_clone.occupation as invoca_occupation, invoca_clone.education as invoca_education, invoca_clone.has_children as invoca_has_children, invoca_clone.high_net_worth as invoca_high_net_worth, incontact_clone.contact_type as incontact_contact_type, incontact_clone.skll_name as incontact_skll_name, incontact_clone.from_number as incontact_from_number, incontact_clone.contact_id as incontact_contact_id, incontact_clone.to_number as incontact_to_number, incontact_clone.start_time as incontact_start_time, incontact_clone.end_time as incontact_end_time, incontact_clone.duration as incontact_duration, incontact_clone.talk_time_sec as incontact_talk_time_sec, incontact_clone.contact_time_sec as incontact_contact_time_sec
from looker_scratch.adwords_call_data_clone
left join looker_scratch.incontact_clone
on abs(EXTRACT(EPOCH FROM adwords_call_data_clone.end_time)-EXTRACT(EPOCH FROM incontact_clone.end_time)) < 3
           and incontact_clone.from_number::text like  CONCAT('%', adwords_call_data_clone.area_code ,'%')
left join looker_scratch.invoca_clone
on abs(EXTRACT(EPOCH FROM adwords_call_data_clone.end_time)-EXTRACT(EPOCH FROM invoca_clone.start_time+invoca_clone.total_duration)) < 15 and
    abs(EXTRACT(EPOCH FROM adwords_call_data_clone.start_time)-EXTRACT(EPOCH FROM invoca_clone.start_time)) < 15
       and invoca_clone.caller_id::text like  CONCAT('%', adwords_call_data_clone.area_code ,'%')) ed_diversion_survey_response_rate
               ;;

        sql_trigger_value: select date_trunc('hour', now())  ;;
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
}

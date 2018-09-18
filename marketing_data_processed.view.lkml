view: marketing_data_processed {
    derived_table: {
      sql:
      SELECT
        lower(coalesce(invoca_clone.utm_source, ga_pageviews_full_clone.source, marketing_cost_clone.type))  AS "source_final",
        lower(coalesce(adwords_campaigns_clone.campaign_name,  marketing_cost_clone.campaign_name, invoca_clone.utm_campaign, ga_pageviews_full_clone.campaign))  AS "campaign_final",
        lower(coalesce(ad_groups_clone.ad_group_name, (coalesce(invoca_clone.utm_content, (split_part(substring(ga_pageviews_full_clone.full_url from 'utm_content=\w+'), '=', 2)))), (lower(marketing_cost_clone.ad_group_name))))  AS "ad_group_final",
        case
              when (ga_pageviews_full_clone.timestamp_mst ) is not null then (ga_pageviews_full_clone.timestamp_mst )
              when (invoca_clone.start_time ) is not null then (invoca_clone.start_time )
              when (marketing_cost_clone.date ) is not null then (marketing_cost_clone.date )
         else null end as "marketing_time",
         lower(coalesce(invoca_clone.utm_content, (split_part(substring(ga_pageviews_full_clone.full_url from 'utm_content=\w+'), '=', 2))))  AS "content_final",
         ga_pageviews_full_clone.full_url  AS "full_url",
         ga_pageviews_full_clone.fullreferrer  AS "fullreferrer",
         lower(coalesce(invoca_clone.utm_medium, ga_pageviews_full_clone.medium, 'cpc'))  AS "medium_final",
         lower(coalesce(invoca_clone.utm_term, (split_part(substring(ga_pageviews_full_clone.full_url from 'utm_term=\w+'), '=', 2))))  AS "term_final",
         ga_pageviews_full_clone.client_id  AS "ga_client_id",
         invoca_clone.caller_id AS "invoca_phone_number",
         ga_pageviews_full_clone.timestamp_mst as ga_timestamp_mst,
         invoca_clone.start_time as invoca_start_time,
         marketing_cost_clone.date as marketing_cost_date,
         lower(marketing_cost_clone.campaign_name) as marketing_cost_campaign_name,
         lower(marketing_cost_clone.ad_group_name) as marketing_cost_ad_group_name,
         lower(marketing_cost_clone.type) as marketing_cost_type,
         marketing_cost_clone.impressions ad_impressions,
         marketing_cost_clone.cost as marketing_cost,
         marketing_cost_clone.clicks ad_clicks,
         invoca_clone.call_record_ikd as call_record_ikd,
         ga_pageviews_full_clone.timestamp as ga_timestamp_orig,
        lower(invoca_clone.profile_campaign) as invoca_profile_campaign,
        invoca_clone.promo_number_description as invoca_promo_number_description
FROM looker_scratch.ga_pageviews_clone  AS ga_pageviews_full_clone
FULL OUTER JOIN looker_scratch.invoca_clone  AS invoca_clone ON abs(
        EXTRACT(EPOCH FROM invoca_clone.start_time)-EXTRACT(EPOCH FROM ga_pageviews_full_clone.timestamp_mst)) < (60*60*1.5)
          and ga_pageviews_full_clone.client_id = invoca_clone.analytics_vistor_id
LEFT JOIN looker_scratch.ga_adwords_stats_clone  AS ga_adwords_stats_clone ON ga_adwords_stats_clone.client_id = ga_pageviews_full_clone.client_id
      and ga_adwords_stats_clone.page_timestamp = ga_pageviews_full_clone.timestamp
LEFT JOIN looker_scratch.adwords_campaigns_clone  AS adwords_campaigns_clone ON adwords_campaigns_clone.campaign_id = ga_adwords_stats_clone.adwordscampaignid
LEFT JOIN looker_scratch.ad_groups_clone  AS ad_groups_clone ON ga_adwords_stats_clone.adwordsadgroupid = ad_groups_clone.adwordsadgroupid
FULL OUTER JOIN looker_scratch.marketing_cost_clone  AS marketing_cost_clone ON lower((lower(coalesce(invoca_clone.utm_source, ga_pageviews_full_clone.source, marketing_cost_clone.type)))) = lower(marketing_cost_clone.type)
    and (DATE(ga_pageviews_full_clone.timestamp_mst )) =(DATE(marketing_cost_clone.date ))
    and lower((lower(coalesce(invoca_clone.utm_medium, ga_pageviews_full_clone.medium, 'cpc'))))  in('cpc', 'paid search', 'paidsocial', 'ctr', 'image_carousel', 'static_image', 'display', 'nativedisplay')
    and lower((lower(coalesce(ad_groups_clone.ad_group_name, (coalesce(invoca_clone.utm_content, (split_part(substring(ga_pageviews_full_clone.full_url from 'utm_content=\w+'), '=', 2)))), (lower(marketing_cost_clone.ad_group_name)))))) = lower((lower(marketing_cost_clone.ad_group_name)))
    and lower((lower(coalesce(adwords_campaigns_clone.campaign_name,  marketing_cost_clone.campaign_name, invoca_clone.utm_campaign, ga_pageviews_full_clone.campaign)))) = lower(marketing_cost_clone.campaign_name)
    ;;
      sql_trigger_value: select array_agg(timevalue)
from
(select count(*) as timevalue
from looker_scratch.ga_pageviews_clone
union all
select count(*)  as timevalue
from looker_scratch.invoca_clone
union all
select count(*) as timevalue
from looker_scratch.marketing_cost_clone)lq;;
      indexes: ["marketing_time"]
  }

  dimension: source_final {
    type: string
    sql: ${TABLE}.source_final ;;
  }
  dimension: invoca_promo_number_description {
    type: string
    sql: ${TABLE}.invoca_promo_number_description ;;
  }

  dimension: fullreferrer {
    type: string
    sql: ${TABLE}.fullreferrer ;;
  }

  dimension: medium_final {
    type: string
    sql: ${TABLE}.medium_final ;;
  }

  dimension: term_final {
    type: string
    sql: ${TABLE}.term_final ;;
  }

  dimension: marketing_cost_date {
    type: date
    sql: ${TABLE}.marketing_cost_date ;;
  }

  dimension: marketing_cost_ad_group_name {
    type: string
    sql: ${TABLE}.marketing_cost_ad_group_name ;;
  }

  dimension: ad_impressions {
    type: number
    sql: ${TABLE}.ad_impressions ;;
  }

  dimension: ad_clicks {
    type: number
    sql: ${TABLE}.ad_clicks ;;
  }

  dimension: marketing_cost {
    type: number
    sql: ${TABLE}.marketing_cost ;;
  }





  dimension: ga_client_id {
    type: string
    sql: ${TABLE}.ga_client_id ;;
  }

  dimension: campaign_final {
    type: string
    sql: ${TABLE}.campaign_final ;;
  }

  dimension: ad_group_final {
    type: string
    sql: ${TABLE}.campaign_final ;;
  }


  dimension: call_record_ikd {
    type: string
    sql: ${TABLE}.call_record_ikd ;;
  }

  dimension: invoca_phone_number {
    type: string
    sql: ${TABLE}.invoca_phone_number ;;
  }

  dimension: full_url {
    type: string
    sql: ${TABLE}.full_url ;;
  }


  dimension_group: ga_timestamp_mst {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.ga_timestamp_mst ;;
  }

  dimension_group: invoca_start{
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.invoca_start_time ;;
  }

  dimension_group: ga_timestamp_orig{
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.ga_timestamp_orig ;;
  }

  dimension_group: marketing {
    convert_tz: no
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
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.marketing_time ;;
  }
  dimension: invoca_profile_campaign {
    type: string
    sql: ${TABLE}.invoca_profile_campaign;;
  }
  dimension:marketing_cost_campaign_name{
    type: string
    sql: ${TABLE}.marketing_cost_campaign_name ;;
  }

  dimension:marketing_cost_type{
    type: string
    sql: ${TABLE}.marketing_cost_type ;;
  }



  dimension: marketing_cost_market_id {
    type: string
    sql: case when lower(${marketing_cost_campaign_name}) like '%den%' then 159
           when lower(${marketing_cost_campaign_name}) like '%colo%' or  lower(${marketing_cost_campaign_name}) like '%springs%' then 160
           when lower(${marketing_cost_campaign_name}) like '%phoe%'or lower(${marketing_cost_campaign_name}) like '%phx%' then 161
           when lower(${marketing_cost_campaign_name}) like '%ric%'  then 164
           when lower(${marketing_cost_campaign_name})  like '%las%' or lower(${marketing_cost_campaign_name})  like '%las%' then 162
           when lower(${marketing_cost_campaign_name})  like '%hou%' then 165
           when lower(${marketing_cost_campaign_name})  like '%okla%' or lower(${marketing_cost_campaign_name})  like '%okc%' then 166
           else null
        end;;
  }

  dimension: invoca_market_id
  {
    type:  number
    sql:  case when lower(${invoca_profile_campaign}) like '%den%' then 159
           when lower(${invoca_profile_campaign}) like '%colo%' then 160
           when lower(${invoca_profile_campaign}) like '%phoe%' then 161
           when lower(${invoca_profile_campaign}) like '%ric%'  then 164
           when lower(${invoca_profile_campaign})  like '%las%' then 162
           when lower(${invoca_profile_campaign})  like '%hou%' then 165
           else null end ;;
  }

  dimension: pageview_market_id {
    type: number
    sql: case when lower(${full_url}) like '%den%'  then 159
         when lower(${full_url})  like '%colo%' then 160
         when lower(${full_url})  like '%pho%' then 161
         when lower(${full_url})  like '%ric%' then 164
         when lower(${full_url})  like '%las%' then 162
         when lower(${full_url})  like '%hou%' then 165
         when lower(${full_url})  like '%okl%' then 166
         else null end ;;
  }

  dimension: market_id{
    type: number
    sql: case when ${care_requests.market_id} is not null then ${care_requests.market_id}
              when ${web_care_requests.market_id} is not null then ${web_care_requests.market_id}
              when ${invoca_market_id} is not null then ${invoca_market_id}
              when ${marketing_cost_market_id} is not null then ${marketing_cost_market_id}
              when ${ga_geodata_clone.market_id} is not null then ${ga_geodata_clone.market_id}
              when ${pageview_market_id} is not null then ${pageview_market_id}
              else null end
              ;;
  }

  dimension: high_level_category
  {
    type: string
    sql: case
            when ${source_final} in('google', 'google.com') and (${campaign_final} in('[agt] remarketing', '[agt] look a like audiences') or lower(${campaign_final}) like '%display%') then 'Google Display'
            when ${source_final} in('google', 'bing', 'ask', 'yahoo') and ${medium_final} = 'organic' then 'Organic Search'
            when ((${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%') and (lower(${ad_group_final}) like '%brand%' or lower(${invoca_promo_number_description}) like '%brand%') then 'SEM: Brand'
            when (${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%' then 'SEM: Non-Brand'
            when ${source_final} in('google', 'bing', 'ask', 'yahoo') and ${medium_final} = 'organic' then 'SEM: Brand or Organic Search'
            when ${medium_final} in('local') or ${source_final} = 'yelp.com' or lower(${source_final}) like '%local%' then 'Local Listings'
            when ${medium_final} in('self report') then 'Self Report Direct to Consumer'
            when ${dtc_ff_patients.patient_id} is not null then 'Other'
            else 'Other' end;;
  }


  dimension: source_category
  {
    type: string
    sql: case
            when ${source_final} in('google', 'google.com') and (${campaign_final} in('[agt] remarketing', '[agt] look a like audiences') or lower(${campaign_final}) like '%display%') then 'Google Display'
            when ((${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%') and (lower(${ad_group_final}) like '%brand%' or lower(${invoca_promo_number_description}) like '%brand%') then 'SEM: Brand'
            when (${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%' then 'SEM: Non-Brand'
            when (${source_final} in('facebook', 'instagram') and ${medium_final} in('paidsocial', 'ctr', 'image_carousel', 'static_image', 'cpc')) or lower(${source_final}) like '%fb click to call%' then 'Paid Social'
            when ${source_final} in('google', 'bing', 'ask', 'yahoo') and ${medium_final} = 'organic' then 'Organic Search'
            when ${source_final} in('(direct)')  then 'Direct Traffic'
            when ${medium_final} in('local') or ${source_final} = 'yelp.com' or lower(${source_final}) like '%local%' then 'Local Listings'
            when (${source_final} like '%facebook%' or  ${source_final} like '%instagram%' or  ${source_final} like '%linkedin%') and ${medium_final} = 'referral' then 'Organic Social'
            when lower(${medium_final}) like '%email%' then 'Email'
            when ${medium_final} in('nativedisplay') then 'Native Display'
            when ${medium_final} in('display') then 'Display'
            when ${medium_final} in('referral') then 'Referral'
            when ${source_final} in('shannon') then null
            when ${medium_final} in('self report') then 'Self Report Digital'
            else ${source_medium} end;;
  }

  dimension: source_medium {
    type: string
    sql: concat(${source_final}, ': ', ${medium_final}) ;;

  }

  measure: care_request_rate {
    type: number
    value_format: "0.0%"
    sql:round((${total_care_requests}::float/nullif(${count_distinct_sessions}::float,0))::numeric,3) ;;
  }

  measure: count_distinct_sessions {
    type: number
    sql: count(distinct ${ga_client_id}) ;;
  }

  measure: complete_rate {
    type: number
    value_format: "0.0%"
    sql:round((${total_complete}::float/nullif(${count_distinct_sessions}::float,0))::numeric,3) ;;
  }

  dimension: low_intent{
    type: yesno
    sql:  source_category in('Native Display','Display', 'Paid Social', 'Organic Social', 'Direct Traffic') ;;
  }

  dimension: high_low_intent
  {
    type: string
    sql: case when ${source_category} in('Google Display', 'Paid Social', 'Organic Social', 'Native Display', 'Display', 'Direct Traffic', 'Local Listings') or lower(${medium_final}) like '%google%' or  lower(${source_final}) like '%bing ad extension%'  then 'Low Intent'
      else 'High Intent' end;;
  }

  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }


  dimension: care_request_id_final {
    type: number
    sql:  coalesce(${care_requests.id},${web_care_requests.id}) ;;
  }

  dimension: complete_care_request_id {
    type: number
    sql:  coalesce(case when ${care_request_flat.complete}  then ${care_requests.id} else null end,
      case when ${web_care_request_flat.complete} then ${web_care_requests.id} else null end) ;;
  }

  dimension: resolved_care_request_id {
    type: number
    sql:  coalesce(case when ${care_request_flat.archive_comment} is not null and ${care_request_flat.complete_comment} is null  then ${care_requests.id} else null end,
      case when ${web_care_request_flat.archive_comment} is not null and ${web_care_request_flat.complete_comment} is null  then ${web_care_requests.id} else null end) ;;
  }

  measure: total_care_requests {
    type: number
    sql: count(distinct ${care_request_id_final})  ;;
  }

  measure: total_complete {
    type: number
    sql:count(distinct ${complete_care_request_id});;
  }

  measure: total_resolved {
    type: number
    sql:count(distinct ${resolved_care_request_id});;
  }

  measure: sum_impressions{
    type: sum_distinct
    sql_distinct_key: concat(${marketing_cost_campaign_name}, ${marketing_date}, ${marketing_cost_type}, ${marketing_cost_ad_group_name}) ;;
    sql: ${ad_impressions}  ;;
  }

  measure: sum_ad_clicks{
    type: sum_distinct
    sql_distinct_key: concat(${marketing_cost_campaign_name}, ${marketing_date}, ${marketing_cost_type}, ${marketing_cost_ad_group_name}) ;;
    sql: ${ad_clicks}  ;;
  }

  measure: sum_marketing_cost{
    type: sum_distinct
    value_format: "$#,##0"
    sql_distinct_key: concat(${marketing_cost_campaign_name}, ${marketing_date}, ${marketing_cost_type}, ${marketing_cost_ad_group_name}) ;;
    sql: ${marketing_cost}  ;;
  }
  measure: invoca_calls {
    type: count_distinct
    sql: ${call_record_ikd} ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month,date]
    sql: current_date - interval '1 day';;
  }

  dimension:  same_day_of_week_marketing {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${marketing_day_of_week_index};;
  }

  dimension: until_today_marketing {
    type: yesno
    sql: ${marketing_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${marketing_day_of_week_index} >= 0 ;;
  }

  dimension: month_to_date_marketing  {
    type:  yesno
    sql: ${marketing_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }


  measure: sessions_to_calls_rate {
    type: number
    value_format: "0%"
    sql: ${invoca_calls}::float /nullif(${count_distinct_sessions}::float,0) ;;
  }

  measure: calls_to_complete{
    type: number
    value_format: "0%"
    sql: ${total_complete}::float /nullif(${invoca_calls}::float,0);;
  }

  measure: month_percent {
    type: number
    sql:

        case when ${marketing_month} != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }

  measure: sessions_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${count_distinct_sessions}/${month_percent} ;;
  }

  measure: care_request_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${total_care_requests}/${month_percent} ;;
  }

  measure: complete_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${total_complete}/${month_percent} ;;
  }


  measure: resolved_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${total_resolved}/${month_percent} ;;
  }

  measure: cost_run_rate{
    type: number
    value_format: "$0"
    sql: ${sum_marketing_cost}/${month_percent} ;;
  }

  measure: cost_per_care_complete {
    type: number
    value_format:"$#;($#)"
    sql:  ${sum_marketing_cost}cost}/NULLIF(${total_complete}, 0) ;;
  }











}

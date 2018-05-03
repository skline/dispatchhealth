view: ga_pageviews_clone {
  sql_table_name: looker_scratch.ga_pageviews_clone ;;

  dimension: adcontent {
    type: string
    sql: ${TABLE}.adcontent ;;
  }

  dimension: bounces {
    type: number
    sql: ${TABLE}.bounces ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }

  dimension: full_url {
    type: string
    sql: ${TABLE}.full_url ;;
  }

  dimension: fullreferrer {
    type: string
    sql: ${TABLE}.fullreferrer ;;
  }

  dimension: goal2completions {
    type: number
    sql: ${TABLE}.goal2completions ;;
  }

  dimension: goal3completions {
    type: number
    sql: ${TABLE}.goal3completions ;;
  }

  dimension: goal4completions {
    type: number
    sql: ${TABLE}.goal4completions ;;
  }

  dimension: goal5completions {
    type: number
    sql: ${TABLE}.goal5completions ;;
  }

  dimension: goal6completions {
    type: number
    sql: ${TABLE}.goal6completions ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  dimension: medium {
    type: string
    sql: ${TABLE}.medium ;;
  }

  dimension: pageviews {
    type: number
    sql: ${TABLE}.pageviews ;;
  }

  dimension: sessionduration {
    type: number
    sql: ${TABLE}.sessionduration ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  measure: count_distinct_sessions {
    type: number
    sql: count(distinct ${client_id}) ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: timeonpage {
    type: number
    sql: ${TABLE}.timeonpage ;;
  }

  dimension_group: timestamp {
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
    sql: ${TABLE}.timestamp ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }
  dimension: adwords {
    type: yesno
    sql: ${full_url} like '%gclid%';;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: facebook_market_id {
    type: number
    sql: case when lower(${campaign}) like '%den%'  then 159
         when lower(${campaign})  like '%colo%' then 160
         when lower(${campaign})  like '%pho%' then 161
         when lower(${campaign})  like '%ric%' then 164
         when lower(${campaign})  like '%las%' then 162
         when lower(${campaign})  like '%hou%' then 165
         when lower(${campaign})  like '%okl%' then 166
         else null end ;;
  }

  dimension: facebook_market_id_final{
    type: number
    sql: case when ${care_requests.market_id} is not null and lower(${source}) in ('facebook', 'facbeook.com', 'instagram', 'instagram.com') then ${care_requests.market_id}
              when ${web_care_requests.market_id} is not null and lower(${source}) in ('facebook', 'facbeook.com', 'instagram', 'instagram.com') then ${web_care_requests.market_id}
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              when ${facebook_market_id} is not null then ${facebook_market_id}
              when ${facebook_paid_performance_clone.market_id} is not null then ${facebook_paid_performance_clone.market_id}
              else null end
              ;;
  }

  dimension: source_medium {
    type: string
    sql: concat(${source_final}, ': ', ${medium_final}) ;;

  }

  measure: call_rate {
    type: number
    value_format: "0.0%"
    sql:round((${invoca_clone.count}::float/nullif(${count_distinct_sessions}::float,0))::numeric,3) ;;
  }

  measure: care_request_rate {
    type: number
    value_format: "0.0%"
    sql:round((${total_care_requests}::float/nullif(${count_distinct_sessions}::float,0))::numeric,3) ;;
  }

  measure: complete_rate {
    type: number
    value_format: "0.0%"
    sql:round((${total_complete}::float/nullif(${count_distinct_sessions}::float,0))::numeric,3) ;;
  }

  dimension: timezone_proc {
    type: string
    sql: case when ${markets.id} in(159, 160) then 'US/Mountain'
              when ${markets.id} in(161) then 'US/Arizona'
              when ${markets.id} in(162) then 'US/Pacific'
              when ${markets.id} in (164) then 'US/Eastern'
              when ${markets.id} in(165, 166) then 'US/Central'
              when ${timezone} in ('GMT-0400', '-0400 (Eastern Daylight Time)', '-0400 (EDT)') then 'US/Eastern'
              else 'US/Mountain' end;;

  }

  dimension: mountain_time  {
    type: date_raw
    sql:   ${timestamp_raw} AT TIME ZONE ${timezone_proc} AT TIME ZONE 'US/Mountain'  ;;

  }


dimension: source_category
  {
    type: string
    sql: case
            when ((${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%') and lower(${ad_group_final}) like '%brand%' then 'Paid Search: Brand'
            when (${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%' then 'Paid Search: Non-Brand'
            when (${source_final} in('facebook', 'instagram') and ${medium_final} in('paidsocial', 'ctr', 'image_carousel', 'static_image')) or lower(${source_final}) like '%fb click to call%' then 'Paid Social'
            when ${source_final} in('google', 'bing', 'ask', 'yahoo') and ${medium_final} = 'organic' then 'Organic Search'
            when ${source_final} in('(direct)')  then 'Direct Traffic'
            when ${medium_final} in('local') or ${source_final} = 'yelp.com' or lower(${source_final}) like '%local%' then 'Local Listings'
            when (${source_final} like '%facebook%' or  ${source_final} like '%instagram%' or  ${source_final} like '%linkedin%') and ${medium_final} = 'referral' then 'Organic Social'
            when lower(${medium_final}) like '%email%' then 'Email'
            when ${medium_final} in('nativedisplay') then 'Native Display'
            when ${medium_final} in('display') then 'Display'
            when ${medium_final} in('referral') then 'Referral'
            when ${source_final} in('shannon') then null
            when ${source_final} in('self report') then 'Self Report Digital'
            else ${source_medium} end;;
  }

  dimension: high_level_category
  {
    type: string
    sql: case
            when ((${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%') and lower(${ad_group_final}) like '%brand%' then 'Paid Search: Brand'
            when (${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%' then 'Paid Search: Non-Brand'
            when ${source_final} in('google', 'bing', 'ask', 'yahoo') and ${medium_final} = 'organic' then 'Organic Search'
            when ${medium_final} in('local') or ${source_final} = 'yelp.com' or lower(${source_final}) like '%local%' then 'Local Listings'
            when ${medium_final} in('self report') then 'Self Report Direct to Consumer'
            else 'Other' end;;
  }

  dimension: low_intent{
    type: yesno
    sql:  source_category in('Native Display','Display', 'Paid Social', 'Organic Social') ;;
  }

  dimension: high_low_intent
  {
    type: string
    sql: case when ${source_category} in('Paid Social', 'Organic Social', 'Native Display', 'Display') then 'Low Intent'
              else 'High Intent' end;;
  }

  measure: total_care_requests {
    type: number
    sql: ${care_requests.count_distinct} + ${web_care_requests.count_distinct}  ;;
  }

  measure: total_complete {
    type: number
    sql:${care_request_flat.complete_count} + ${web_care_request_flat.complete_count};;
  }

  measure: total_resolved {
    type: number
    sql:  ${care_request_flat.resolved_count} + ${web_care_request_flat.resolved_count};;
  }
  dimension: ga_date{

    type: date
    sql: case
              when ${timestamp_date} is not null then ${timestamp_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
         else null end;;

    }

  dimension_group: ga_time{
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
    type: time
    sql: case
              when ${timestamp_date} is not null then ${timestamp_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
         else null end;;

    }
    dimension: source_final {
      type: string
      sql: coalesce(${source}, ${invoca_clone.utm_source}) ;;
    }

  dimension: medium_final {
    type: string
    sql: coalesce(${medium}, ${invoca_clone.utm_medium}) ;;
  }
  dimension: content {
    type: string
    sql: split_part(substring(${full_url} from 'utm_content=\w+'), '=', 2) ;;

  }

  dimension: content_final {
    type: string
    sql: coalesce(${content}, ${invoca_clone.utm_content}) ;;
  }

  dimension: ad_group_final {
    type: string
    sql: coalesce(${ad_groups_clone.ad_group_name}, ${content_final}) ;;
  }



  dimension: term {
    type: string
    sql: split_part(substring(${full_url} from 'utm_term=\w+'), '=', 2) ;;

  }

  dimension: term_final {
    type: string
    sql: coalesce(${term}, ${invoca_clone.utm_term}) ;;
  }


  dimension: campaign_final {
    type: string
    sql: coalesce(${campaign}, ${invoca_clone.utm_campaign}) ;;
  }

  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  dimension:  same_day_of_week_adwords {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${ga_time_day_of_week_index};;
  }

  dimension: until_today_adwords {
    type: yesno
    sql: ${ga_time_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${ga_time_day_of_week_index} >= 0 ;;
  }

  dimension: month_to_date_adwords {
    type:  yesno
    sql: ${ga_time_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension: channel_id_coalesce {
    type: number
    sql: coalese(${care_requests.channel_item_id}, ${web_care_requests.channel_item_id})::int;;
  }
  measure: impressions_to_adclicks_rate {
    type: number
    value_format: "0.0%"
    sql: ${marketing_cost_clone.sum_ad_clicks}::float /nullif(${marketing_cost_clone.sum_impressions}::float,0) ;;
  }


  measure: session_to_adclicks_rate {
    label: "Adclick to Sessions Rate"
    type: number
    value_format: "0%"
    sql:  ${count_distinct_sessions}::float/nullif(${marketing_cost_clone.sum_ad_clicks}::float ,0) ;;
  }

  measure: adclicks_to_complete_rate {
    type: number
    value_format: "0.0%"
    sql: ${total_complete}::float /nullif(${marketing_cost_clone.sum_ad_clicks}::float,0) ;;
  }


  measure: cost_per_call {
    type: number
    value_format:"$#;($#)"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${invoca_clone.count},0) ;;
  }

  measure: cost_per_care_request {
    type: number
    value_format:"$#;($#)"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${total_care_requests},0) ;;
  }

  measure: cost_per_care_complete {
    type: number
    value_format:"$#;($#)"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${total_complete}, 0) ;;
  }

  measure: cost_per_clicks {
    type: number
    value_format:"$#;($#)"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${marketing_cost_clone.sum_ad_clicks}, 0) ;;
  }

  measure: cost_per_impressions {
    type: number
    value_format:"$#.00;($#).00"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${marketing_cost_clone.sum_impressions}, 0) ;;
  }

  measure: cost_per_sessions {
    type: number
    value_format:"$#;($#)"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${count_distinct_sessions}, 0) ;;
  }





  measure: sessions_to_calls_rate {
    type: number
    value_format: "0%"
    sql: ${invoca_clone.count}::float /nullif(${count_distinct_sessions}::float,0) ;;
  }

  measure: sessions_to_complete_rate {
    type: number
    value_format: "0.0%"
    sql: ${total_complete}::float /nullif(${count_distinct_sessions}::float,0) ;;
  }

  measure: calls_to_care_request_rate {
    type: number
    value_format: "0%"
    sql: ${total_care_requests}::float /nullif(${invoca_clone.count}::float,0) ;;
  }

  measure: calls_to_complete{
    type: number
    value_format: "0%"
    sql: ${total_complete}::float /nullif(${invoca_clone.count}::float,0);;
  }

  measure: care_requests_to_complete_rate{
    type: number
    value_format: "0%"
    sql: ${total_complete}::float /nullif(${total_care_requests}::float,0) ;;
  }


}

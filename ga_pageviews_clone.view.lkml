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

  dimension_group: timestamp_mst {
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
    sql: ${TABLE}.timestamp_mst ;;
  }

  dimension: timezone {
    type: string
    sql: trim(${TABLE}.timezone) ;;
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





dimension: source_category
  {
    type: string
    sql: case
            when ((${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%') and (lower(${ad_group_final}) like '%brand%' or lower(${invoca_clone.promo_number_description}) like '%brand%') then 'SEM: Brand'
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

  dimension: high_level_category
  {
    type: string
    sql: case
            when ((${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%') and (lower(${ad_group_final}) like '%brand%' or lower(${invoca_clone.promo_number_description}) like '%brand%') then 'SEM: Brand or Organic Search'
            when (${source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${medium_final} in('cpc', 'paid search')) or lower(${medium_final}) like '%google%' or lower(${source_final}) like '%bing ad extension%' then 'SEM: Non-Brand'
            when ${source_final} in('google', 'bing', 'ask', 'yahoo') and ${medium_final} = 'organic' then 'SEM: Brand or Organic Search'
            when ${medium_final} in('local') or ${source_final} = 'yelp.com' or lower(${source_final}) like '%local%' then 'Local Listings'
            when ${medium_final} in('self report') then 'Self Report Direct to Consumer'
            when ${dtc_ff_patients.patient_id} is not null then 'Other'
            else 'Other' end;;
  }


  dimension: projection_category
  {
    type: string
    sql: case
            when ${high_level_category} in ('SEM: Non-Brand') then 'SEM: Non-Brand'
            when ${high_level_category} in ('Local Listings', 'Organic Search', 'SEM: Brand') then 'Organic'
            when ${source_category} in ('Paid Social') then 'Paid Social'
            else 'Other' end;;
  }

  dimension: low_intent{
    type: yesno
    sql:  source_category in('Native Display','Display', 'Paid Social', 'Organic Social', 'Direct Traffic') ;;
  }

  dimension: high_low_intent
  {
    type: string
    sql: case when ${source_category} in('Paid Social', 'Organic Social', 'Native Display', 'Display', 'Direct Traffic', 'Local Listings') or lower(${medium_final}) like '%google%' or  lower(${source_final}) like '%bing ad extension%'  then 'Low Intent'
              else 'High Intent' end;;
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

  dimension: ga_date{

    type: date
    sql: case
              when ${web_care_request_flat.on_scene_date} is not null then ${web_care_request_flat.on_scene_date}
              when ${care_request_flat.on_scene_date} is not null then ${care_request_flat.on_scene_date}
              when ${web_care_request_flat.created_date} is not null then ${web_care_request_flat.created_date}
              when ${care_request_flat.created_date} is not null then ${care_request_flat.created_date}
              when ${timestamp_mst_date} is not null then ${timestamp_mst_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
              when ${marketing_cost_clone.date_date} is not null then ${marketing_cost_clone.date_date}
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
              when ${web_care_request_flat.on_scene_date} is not null then ${web_care_request_flat.on_scene_date}
              when ${care_request_flat.on_scene_date} is not null then ${care_request_flat.on_scene_date}
              when ${web_care_request_flat.created_date} is not null then ${web_care_request_flat.created_date}
              when ${care_request_flat.created_date} is not null then ${care_request_flat.created_date}
              when ${timestamp_mst_date} is not null then ${timestamp_mst_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
              when ${marketing_cost_clone.date_date} is not null then ${marketing_cost_clone.date_date}
         else null end;;
    }
    dimension: source_final {
      type: string
      sql: lower(coalesce(${invoca_clone.utm_source}, ${source}, ${marketing_cost_clone.type})) ;;
    }

  dimension: medium_final {
    type: string
    sql: lower(coalesce(${invoca_clone.utm_medium}, ${medium}, ${marketing_cost_clone.medium})) ;;
  }
  dimension: content {
    type: string
    sql: split_part(substring(${full_url} from 'utm_content=\w+'), '=', 2) ;;

  }

  dimension: exp_id {
    type: string
    sql: right(left((lower(split_part(substring(${full_url} from 'utm_expid=[\w.-]+'), '=', 2))),-2),-1) ;;

  }
  dimension: test_exp_condition_num {
    type: number
    sql: right((lower(split_part(substring(${full_url} from 'utm_expid=[\w.-]+'), '=', 2))),1)::int;;
  }

  dimension: test_exp_condition {
    type: string
    sql:  case when ${test_exp_condition_num} = 1 then 'Experimental'
               when ${test_exp_condition_num} = 0 then 'Control'
          else null end;;
  }

  dimension: content_final {
    type: string
    sql: coalesce(${invoca_clone.utm_content}, ${content}) ;;
  }

  dimension: ad_group_final {
    type: string
    sql: lower(coalesce(${ad_groups_clone.ad_group_name}, ${content_final})) ;;
  }


  dimension: term {
    type: string
    sql: split_part(substring(${full_url} from 'utm_term=\w+'), '=', 2) ;;

  }

  dimension: term_final {
    type: string
    sql: coalesce(${invoca_clone.utm_term}, ${term}) ;;
  }


  dimension: campaign_final {
    type: string
    sql: lower(coalesce(${adwords_campaigns_clone.campaign_name},  ${marketing_cost_clone.campaign_name}, ${invoca_clone.utm_campaign}, ${campaign})) ;;
  }

  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }

  dimension: sem_category {
    type: string
    sql: case when ${source_final} = 'google' and ${medium_final} = 'cpc' and ${campaign_final} like '%call only%' then 'Call Only'
              when ${source_final} = 'google' and ${medium_final} = 'cpc' and ${campaign_final} not like '%call only%' then 'Regular'
              when ${medium_final} = 'google call extension' and ${source_final} like '%new%' then 'Call Only'
              when ${medium_final} = 'google call extension' and ${source_final} not like '%new%' then 'Regular'
          else null end;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month,date]
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
    value_format:"$#;($#).0"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${marketing_cost_clone.sum_ad_clicks}, 0) ;;
  }

  measure: cost_per_impressions {
    type: number
    value_format:"$#.00;($#).00"
    sql:  ${marketing_cost_clone.sum_cost}/NULLIF(${marketing_cost_clone.sum_impressions}, 0) ;;
  }

  measure: cost_per_sessions {
    type: number
    value_format:"$#;($#).0"
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


  measure: month_percent {
    type: number
    sql:

        case when ${ga_time_month} != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }





}

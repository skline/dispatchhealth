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
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              when ${facebook_market_id} is not null then ${facebook_market_id}
              when ${facebook_paid_performance_clone.market_id} is not null then ${facebook_paid_performance_clone.market_id}
              else null end
              ;;
  }

  dimension: source_medium {
    type: string
    sql: concat(${source}, ': ', ${medium}) ;;

  }

  measure: call_rate {
    type: number
    value_format: "0.0%"
    sql:round((${invoca_clone.count}::float/${count_distinct_sessions}::float)::numeric,3) ;;
  }

  measure: care_request_rate {
    type: number
    value_format: "0.0%"
    sql:round((${care_requests.count_distinct}::float/${count_distinct_sessions}::float)::numeric,3) ;;
  }

  measure: complete_rate {
    type: number
    value_format: "0.0%"
    sql:round((${care_request_complete.count_distinct}::float/${count_distinct_sessions}::float)::numeric,3) ;;
  }

  dimension: source_category
  {
    type: string
    sql: case when ${source} in('google', 'bing', 'ask', 'yahoo') and ${medium} = 'cpc' then 'Paid Search'
              when ${source} in('facebook', 'instagram') and ${medium} in('paidsocial', 'ctr', 'image_carousel', 'static_image') then 'Paid Social'
              when ${source} in('google', 'bing', 'ask', 'yahoo') and ${medium} = 'organic' then 'Organic Search'
              when ${source} in('(direct)')  then 'Direct Traffic'
              when ${medium} in('local') or ${source} = 'yelp.com' then 'Local Listings'
              when (${source} like '%facebook%' or  ${source} like '%instagram%' or  ${source} like '%linkedin%') and ${medium} = 'referral' then 'Organic Social'
              when ${medium} in('email') then 'Email'
              when ${medium} in('nativedisplay') then 'Native Display'
              when ${medium} in('display') then 'Display'
              when ${medium} in('referral') then 'Referral'
              when ${source} in('shannon') then null
              else ${source_medium} end;;
  }

  dimension: high_low_intent
  {
    type: string
    sql: case when ${source_category} in('Paid Social', 'Organic Social', 'Native Display', 'Display') then 'Low Intent'
              else 'High Intent' end;;
  }

  measure: total_care_requests {
    type: number
    sql: count(distinct coalesce(${care_requests.id}, ${web_care_requests.id})) ;;
  }

  measure: total_complete {
    type: number
    sql: count(distinct coalesce(${care_request_complete.id}, ${web_care_request_complete.id})) ;;
  }

  measure: total_resolved {
    type: number
    sql:  count(
                    distinct
                    coalesce
                    (
                      case when ${web_care_request_archived.comment} is not null then ${web_care_request_archived.care_request_id} else null end,
                      case when ${care_request_archived.comment} is not null then ${care_request_archived.care_request_id} else null end
                    )
                 )
        ;;
  }

  dimension: ga_date{
    type: date
    sql: case
              when ${timestamp_date} is not null then ${timestamp_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
         else null end;;

    }
}

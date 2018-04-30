view: ga_adwords_stats_clone {
  sql_table_name: looker_scratch.ga_adwords_stats_clone ;;

  dimension: admatchedquery {
    type: string
    sql: ${TABLE}.admatchedquery ;;
  }

  dimension: admatchtype {
    type: string
    sql: ${TABLE}.admatchtype ;;
  }

  dimension: adwordscampaignid {
    type: string
    sql: ${TABLE}.adwordscampaignid ;;
  }

  dimension: adwordsadgroupid {
    type: string
    sql: ${TABLE}.adwordsadgroupid ;;
  }

  dimension: adwordscreativeid {
    type: string
    sql: ${TABLE}.adwordscreativeid ;;
  }

  dimension: bounces {
    type: number
    sql: ${TABLE}.bounces ;;
  }

  measure: sum_bounces {
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.bounces  ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }

  dimension: goal2completions {
    type: number
    sql: ${TABLE}.goal2completions ;;
  }

  measure: sum_goal2completions {
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.goal2completions  ;;
  }

  dimension: goal3completions {
    type: number
    sql: ${TABLE}.goal3completions ;;
  }

  measure: sum_goal3completions{
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.goal3completions  ;;
  }

  dimension: goal4completions {
    type: number
    sql: ${TABLE}.goal4completions ;;
  }

  measure: sum_goal4completions{
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.goal4completions  ;;
  }

  dimension: goal5completions {
    type: number
    sql: ${TABLE}.goal5completions ;;
  }

  measure: sum_goal5completions{
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.goal5completions  ;;
  }


  dimension: goal6completions {
    type: number
    sql: ${TABLE}.goal6completions ;;
  }

  measure: sum_goal6completions{
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.goal6completions  ;;
  }


  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }

  dimension_group: page_timestamp {
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
    sql: ${TABLE}.page_timestamp ;;
  }

  dimension: pagepath {
    type: string
    sql: ${TABLE}.pagepath ;;
  }

  dimension: pageviews {
    type: number
    sql: ${TABLE}.pageviews ;;
  }

  measure: sum_pageviews{
    type: sum_distinct
    sql_distinct_key: concat(${page_timestamp_raw}, ${client_id}) ;;
    sql: ${TABLE}.pageviews  ;;
  }

  measure: distinct_sessions {
    type:number
    sql: count(distinct ${client_id})  ;;
  }


  dimension: sessionduration {
    type: number
    sql: ${TABLE}.sessionduration ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  dimension: timeonpage {
    type: number
    sql: ${TABLE}.timeonpage ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }
  dimension: market_id {
    type: number
    sql: case when ${care_requests.market_id} is not null and ${ga_pageviews_clone.adwords} then ${care_requests.market_id}
              when ${web_care_requests.market_id} is not null and ${ga_pageviews_clone.adwords} then ${web_care_requests.market_id}
              when ${adwords_campaigns_clone.market_id} is not null then ${adwords_campaigns_clone.market_id}
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              else null end
              ;;
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

  dimension: adwords_date{
    type: date
    sql: case
              when ${ga_adwords_cost_clone.date_date} is not null then ${ga_adwords_cost_clone.date_date}
              when ${page_timestamp_date} is not null then ${page_timestamp_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
         else null end;;

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
    sql:  ${yesterday_mountain_day_of_week_index} = ${adwords_time_day_of_week_index};;
  }

  dimension: until_today_adwords {
    type: yesno
    sql: ${adwords_time_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${adwords_time_day_of_week_index} >= 0 ;;
  }

  dimension: month_to_date_adwords {
    type:  yesno
    sql: ${adwords_time_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension_group: adwords_time{
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
    sql: ${adwords_date};;

    }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: channel_combined {
     type:string
     sql: coalesce(${web_channel_items.name}, ${channel_items.name});;
  }
  dimension: channel_id_coalesce {
    type: number
    sql: coalese(${care_requests.channel_item_id}, ${web_care_requests.channel_item_id});;
  }
  measure: impression_to_adclick_rate {
    type: number
    value_format: "0.0%"
    sql: ${ga_adwords_cost_clone.sum_total_adclicks} /nullif(${ga_adwords_cost_clone.sum_total_impressions},0) ;;
  }

  measure: adclick_to_sessions_rate {
    type: number
    value_format: "0%"
    sql: ${distinct_sessions} /nullif(${ga_adwords_cost_clone.sum_total_adclicks},0);;
  }

  measure: sessions_to_calls_rate {
    type: number
    value_format: "0%"
    sql: ${invoca_clone.count}::float /nullif(${distinct_sessions}::float,0) ;;
  }


  measure: adclick_to_calls_rate {
    type: number
    value_format: "0%"
    sql: ${invoca_clone.count}::float /nullif(${ga_adwords_cost_clone.sum_total_adclicks}::float,0) ;;
  }

  measure: adclick_to_complete_rate {
    type: number
    value_format: "0%"
    sql: ${total_complete}::float/nullif(${ga_adwords_cost_clone.sum_total_adclicks}::float,0);;
  }


  measure: calls_to_care_request_rate {
    type: number
    value_format: "0%"
    sql: ${total_care_requests}::float /nullif(${invoca_clone.count}::float,0);;
  }

  measure: calls_to_complete_rate {
    type: number
    value_format: "0%"
    sql: ${total_complete}::float /nullif(${invoca_clone.count}::float,0) ;;
  }

  measure: care_request_to_complete_rate {
    type: number
    value_format: "0%"
    sql: ${total_complete}::float /nullif(${total_care_requests}::float,0) ;;
  }


}

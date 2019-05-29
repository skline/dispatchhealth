view: marketing_cost_clone {
  sql_table_name: looker_scratch.marketing_cost_clone ;;

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: ad_group_name {
    type: string
    sql: lower(${TABLE}.ad_group_name) ;;
  }

  dimension: ad_clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }
  measure: sum_ad_clicks{
    type: sum_distinct
    sql_distinct_key: concat(${campaign_name}, ${date_raw}, ${type}, ${ad_group_name}) ;;
    sql: ${ad_clicks}  ;;
  }



  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: ad_group_name_final {
    type: string
    sql: case when ${ad_groups_clone.ad_group_name} is not null then ${ad_groups_clone.ad_group_name}
              else ${ga_pageviews_full_clone.adcontent_final} end;;

  }

  dimension: medium {
    type: string
    sql: 'cpc' ;;
  }


  measure: sum_cost{
    type: sum_distinct
    value_format: "$#,##0"
    sql_distinct_key: concat(${campaign_name}, ${date_raw}, ${type}, ${ad_group_name}) ;;
    sql: ${cost}  ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  measure: month_percent {
    type: number
    sql:

        case when ${date_month} != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }

  measure: cost_run_rate{
    type: number
    value_format: "$0"
    sql: ${sum_cost}/${care_request_flat.month_percent} ;;
  }


  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }


  dimension: prior_complete_week_flag {
    description: "The complete date is in the past complete week"
    type: yesno
    sql: ((((${date_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
      (${date_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_complete_month_flag {
    description: "The complete date is in the past complete month"
    type: yesno
    sql: ((((${date_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${date_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  measure: sum_impressions{
    type: sum_distinct
    sql_distinct_key: concat(${campaign_name}, ${date_raw}, ${type}, ${ad_group_name}) ;;
    sql: ${impressions}  ;;
  }

  measure: impressions_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${sum_impressions}/${care_request_flat.month_percent} ;;
  }

  measure: ad_clicks_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${sum_ad_clicks}/${care_request_flat.month_percent} ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
  dimension: market_id {
    type: string
    sql: case when lower(${campaign_name}) like '%den%' then 159
           when lower(${campaign_name}) like '%colo%' or  lower(${campaign_name}) like '%springs%' or  lower(${campaign_name}) like '%-cos%'  then 160
           when lower(${campaign_name}) like '%phoe%'or lower(${campaign_name}) like '%phx%' then 161
           when lower(${campaign_name}) like '%ric%'  then 164
           when lower(${campaign_name})  like '%las %' or lower(${campaign_name})  like '%las %' then 162
           when lower(${campaign_name})  like '%hou%' then 165
           when lower(${campaign_name})  like '%okla%' or lower(${campaign_name})  like '%okc%' then 166
             when lower(${campaign_name})  like '%springfield%' or lower(${campaign_name})  like 'spr%' or lower(${campaign_name})  like '%-spr%' then 168
     when lower(${campaign_name})  like '%dal%' then 169
    when lower(${campaign_name})  like '%tac%' then 170
           else null
        end;;
  }
}

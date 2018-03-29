view: facebook_paid_performance_clone {
  sql_table_name: looker_scratch.facebook_paid_performance_clone ;;

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_name {
    type: number
    sql: ${TABLE}.account_name ;;
  }

  dimension: actions {
    type: number
    sql: ${TABLE}.actions ;;
  }
  measure: sum_total_actions {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.actions  ;;
  }

  dimension: ad_id {
    type: number
    sql: ${TABLE}.ad_id ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}.ad_name ;;
  }

  dimension: ad_set_id {
    type: number
    sql: ${TABLE}.ad_set_id ;;
  }

  dimension: ad_set_name {
    type: string
    sql: ${TABLE}.ad_set_name ;;
  }

  dimension: attention_impressions {
    type: number
    sql: ${TABLE}.attention_impressions ;;
  }

  measure: sum_total_attention_impressions {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.attention_impressions  ;;
  }


  dimension: button_clicks {
    type: number
    sql: ${TABLE}.button_clicks ;;
  }

  measure: sum_total_button_clicks {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.button_clicks  ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: clicks_all {
    type: number
    sql: ${TABLE}.clicks_all ;;
  }

  measure: sum_total_clicks_all {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.clicks_all  ;;
  }

  dimension: cost {
    type: number
    value_format:"$#;($#)"
    sql: ${TABLE}.cost ;;
  }

  measure: sum_total_cost {
    type: sum_distinct
    value_format:"$#;($#)"
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.cost  ;;
  }

  dimension: delivery {
    type: string
    sql: ${TABLE}.delivery ;;
  }

  dimension_group: end {
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
    sql: ${TABLE}.end_date ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }
  measure: sum_total_impressions {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.impressions  ;;
  }

  dimension: people_taking_action {
    type: number
    sql: ${TABLE}.people_taking_action ;;
  }

  measure: sum_total_people_taking_action {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.people_taking_action  ;;
  }


  dimension: reach {
    type: number
    sql: ${TABLE}.reach ;;
  }

  measure: sum_total_reach {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.reach  ;;
  }


  dimension: relevance {
    type: number
    sql: ${TABLE}.relevance ;;
  }

  dimension: result {
    type: number
    sql: ${TABLE}.result ;;
  }

  measure: sum_total_result {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.result  ;;
  }




  dimension: result_indication {
    type: string
    sql: ${TABLE}.result_indication ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_date ;;
  }

  dimension: unique_link_clicks {
    type: number
    sql: ${TABLE}.unique_link_clicks ;;
  }

  measure: sum_total_unique_link_clicks {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.unique_link_clicks  ;;
  }


  dimension: unique_outbound_clicks {
    type: number
    sql: ${TABLE}.unique_outbound_clicks ;;
  }
  measure: sum_total_unique_outbound_clicks {
    type: sum_distinct
    sql_distinct_key: concat(${start_date}, ${end_date}, ${ad_id}) ;;
    sql: ${TABLE}.unique_outbound_clicks  ;;
  }
  dimension: market_id {
    type: number
    sql:  case when lower(${campaign_name}) like '%den%'  then 159
         when lower(${campaign_name})  like '%colo%' then 160
         when lower(${campaign_name})  like '%pho%' then 161
         when lower(${campaign_name})  like '%ric%' then 164
         when lower(${campaign_name})  like '%las%' then 162
         when lower(${campaign_name})  like '%hou%' then 165
         when lower(${campaign_name})  like '%okl%' then 166
         else  null end  ;;
  }
  dimension: facebook_date{
    type: date
    sql: case
              when ${start_date} is not null then ${start_date}
              when ${ga_pageviews_clone.timestamp_date} is not null then ${ga_pageviews_clone.timestamp_date}
              when ${invoca_clone.start_date} is not null then ${invoca_clone.start_date}
         else null end;;

    }


  measure: count {
    type: count
    drill_fields: [account_name, ad_set_name, campaign_name, ad_name]
  }
}

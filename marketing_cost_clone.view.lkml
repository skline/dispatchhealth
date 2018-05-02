view: marketing_cost_clone {
  sql_table_name: looker_scratch.marketing_cost_clone ;;

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: ad_clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }
  measure: sum_ad_clicks{
    type: sum_distinct
    sql_distinct_key: concat(${campaign_name}, ${date_raw}, ${type}) ;;
    sql: ${ad_clicks}  ;;
  }



  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }


  measure: sum_cost{
    type: sum_distinct
    value_format: "$0"
    sql_distinct_key: concat(${campaign_name}, ${date_raw}, ${type}) ;;
    sql: ${cost}  ;;
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

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  measure: sum_impressions{
    type: sum_distinct
    sql_distinct_key: concat(${campaign_name}, ${date_raw}, ${type}) ;;
    sql: ${impressions}  ;;
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
           when lower(${campaign_name}) like '%colo%' or  lower(${campaign_name}) like '%springs%' then 160
           when lower(${campaign_name}) like '%phoe%'or lower(${campaign_name}) like '%phx%' then 161
           when lower(${campaign_name}) like '%ric%'  then 164
           when lower(${campaign_name})  like '%las%' or lower(${campaign_name})  like '%las%' then 162
           when lower(${campaign_name})  like '%hou%' then 165
           when lower(${campaign_name})  like '%okla%' or lower(${campaign_name})  like '%okc%' then 166
           else null
        end;;
  }
}

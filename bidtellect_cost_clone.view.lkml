view: bidtellect_cost_clone {
  sql_table_name: looker_scratch.bidtellect_cost_clone ;;

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }

  measure: total_clicks {
    type: sum_distinct

    sql_distinct_key: concat(${campaign_name}, ${hour_raw}, ${insertion_order_name}, ${creative_url}, ${short_text}) ;;
    sql: ${TABLE}.clicks ;;
  }

  measure: total_spend {
    type: sum_distinct
    value_format:"$#;($#)"
    sql_distinct_key: concat(${campaign_name}, ${hour_raw}, ${insertion_order_name}, ${creative_url}, ${short_text}) ;;
    sql: ${TABLE}.spend ;;
  }

  measure: total_impressions {
    type: sum_distinct
    sql_distinct_key: concat(${campaign_name}, ${hour_raw}, ${insertion_order_name}, ${creative_url}, ${short_text}) ;;
    sql: ${TABLE}.impressions ;;
  }



  dimension: creative_url {
    type: string
    sql: ${TABLE}.creative_url ;;
  }

  dimension_group: hour {
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
    sql: ${TABLE}.hour_date ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: insertion_order_name {
    type: string
    sql: ${TABLE}.insertion_order_name ;;
  }

  dimension: short_text {
    type: string
    sql: ${TABLE}.short_text ;;
  }

  dimension: spend {
    type: number
    value_format:"$#;($#)"
    sql: ${TABLE}.spend ;;
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
         else  null end ;;
  }

  measure: count {
    type: count
    drill_fields: [id, insertion_order_name, campaign_name]
  }

}

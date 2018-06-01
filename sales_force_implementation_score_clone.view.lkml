view: sales_force_implementation_score_clone {
  sql_table_name: looker_scratch.sales_force_implementation_score_clone ;;

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: implementation_score {
    type: number
    sql: ${TABLE}.implementation_score ;;
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
  }

  measure: sum_implementation_score {
    type: sum_distinct
    sql_distinct_key: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
    sql: ${implementation_score} ;;
  }

  measure: average_implementation_score {
    type: average_distinct
    value_format: "0"
    sql_distinct_key: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
    sql: ${implementation_score} ;;
  }

  dimension:  sf_account_name {
    type: string
    sql: ${TABLE}.sf_account_name ;;

  }

  dimension:  sf_implementation_name {
    type: string
    sql: ${TABLE}.sf_implementation_name ;;
  }

  dimension: complete_care_requests_last_month {
    type: number
    sql:  ${TABLE}.complete_care_requests;;
  }

  dimension: projected_volume {
    type: number
    sql:  ${TABLE}.projected_volume;;
  }

  dimension: potential_volume {
    type: number
    sql:  ${TABLE}.potential_volume;;
  }


  measure: distinct_channels_mapped_in_sf  {
    type: count_distinct
    sql_distinct_key: ${channel_item_id} ;;
    sql: ${channel_item_id} ;;
  }

  measure: distinct_sf_accounts  {
    type: count_distinct
    sql_distinct_key: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
    sql: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
  }
  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: market_id {
    type: number
    sql:  case when lower(${market}) like '%den%' then 159
           when lower(${market}) like '%colo%' or  lower(${market}) like '%springs%' then 160
           when lower(${market}) like '%phoe%'or lower(${market}) like '%phx%' then 161
           when lower(${market}) like '%ric%'  then 164
           when lower(${market})  like '%las%' or lower(${market})  like '%las%' then 162
           when lower(${market})  like '%hou%' then 165
           when lower(${market})  like '%okla%' or lower(${market})  like '%okc%' then 166
           else null
        end;;
  }

  dimension: market_id_final {
    type: number
    sql: coalesce(${channels.market_id}, ${market_id}) ;;
  }

  dimension: type {
    type: string
    sql:  ${TABLE}.type ;;
  }

  dimension: zipcode {
    type: zipcode
    sql:  ${TABLE}.zipcode ;;
  }
  dimension: zipcode_final {
    type: zipcode
    sql:  coalesce(${zipcode}, ${channel_items.zipcode}) ;;
  }
}

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
              when ${adwords_campaigns_clone.market_id} is not null then ${adwords_campaigns_clone.market_id}
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              else null end
              ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

}

view: sales_force_implementation_score_recent {
    derived_table: {
      sql: select *
              from
              (select sf.created_at, sf.channel_item_id, sf.sf_account_name, sf.sf_implementation_name, sf.implementation_score as implementation_score, sf.projected_volume, sf.potential_volume, market,sf.zipcode, sf.type, sf.sf_created_at, count(distinct cs.care_request_id) as complete_care_requests
from (

   SELECT *
   FROM looker_scratch.sales_force_implementation_score_clone a
   where a.created_at=
   (select max(b.created_at)
     from looker_scratch.sales_force_implementation_score_clone b
     WHERE a.channel_item_id = b.channel_item_id)) sf
left join public.care_requests cr
on cr.channel_item_id=sf.channel_item_id
and (((cr.created_at ) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL)))
AND ((cr.created_at ) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL))))))
left join public.care_request_statuses cs
on cs.care_request_id=cr.id and cs.name='complete' and cs.deleted_at is  null
group by 1,2,3,4,5,6,7,8,9,10,11) sales_force_implementation_score_clone
                     ;;
    }

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

  dimension_group: sf_created {
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
    sql: ${TABLE}.sf_created_at ;;
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
  measure: sum_complete_care_requests_last_month {
    type: sum_distinct
    sql_distinct_key: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
    sql:  ${complete_care_requests_last_month};;
  }


  measure: average_complete_care_requests_last_month {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
    sql:  ${complete_care_requests_last_month};;
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
    sql_distinct_key: concat(${sf_account_name}, ${sf_implementation_name}) ;;
    sql: concat(${sf_account_name}, ${sf_implementation_name}) ;;
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
           when lower(${market})  like '%las %' or lower(${market})  like '%las %' then 162
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
  dimension: account_age_days {
    type: number
    sql: DATE_PART('day', current_date::timestamp - ${sf_created_date}::timestamp) ;;
  }

  dimension: account_age_cat {
    type: string
    sql: case when ${account_age_days} <= 30 then '0-30'
              when ${account_age_days} between 30 and 60 then '31-60'
              when ${account_age_days} between 60 and 90 then '61-90'
              when ${account_age_days} between 90 and 120 then '91-120'

              when ${account_age_days}>=120 then '120+'
              else null end;;
  }

  measure: avg_account_age_days {
    type: average_distinct
    value_format: "0"
    sql_distinct_key: concat(${channel_item_id}, ${sf_account_name}, ${sf_implementation_name}) ;;
    sql: ${account_age_days} ;;
  }

  dimension: implementation_cat {
    type: string
    sql: case when ${implementation_score} <= 20 then '0-20'
              when ${implementation_score} between 20 and 40 then '21-40'
              when ${implementation_score} between 40 and 60 then '41-60'
              when ${implementation_score} between 60 and 80 then '61-80'
              when ${implementation_score}>=80 then '80+'
              else null end;;
  }


  }

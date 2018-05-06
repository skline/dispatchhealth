view: sales_force_implementation_score_recent {
    derived_table: {
      sql: select *
              from
              (select sf.channel_item_id, sf.sf_account_name, sf.sf_implementation_name, max(sf.implementation_score) as implementation_score, count(distinct cs.care_request_id) as complete_care_requests
from looker_scratch.sales_force_implementation_score_clone sf
left join public.care_requests cr
on cr.channel_item_id=sf.channel_item_id
and (((cr.created_at ) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL)))
AND ((cr.created_at ) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL))))))
left join public.care_request_statuses cs
on cs.care_request_id=cr.id and cs.name='complete' and cs.deleted_at is  null
group by 1,2,3) sales_force_implementation_score_clone
                     ;;
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
    sql_distinct_key: ${channel_item_id} ;;
    sql: ${implementation_score} ;;
  }

  measure: average_implementation_score {
    type: average_distinct
    sql_distinct_key: ${channel_item_id} ;;
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
  measure: distinct_channels_mapped_in_sf  {
    type: count_distinct
    sql_distinct_key: ${channel_item_id} ;;
    sql: ${channel_item_id} ;;
  }



  }

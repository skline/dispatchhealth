include: "ga_pageviews_clone.view.lkml"
view: ga_pageviews_full_clone {
  extends: [ga_pageviews_clone]

  dimension: market_id{
    type: number
    sql: case when ${care_requests.market_id} is not null then ${care_requests.market_id}
              when ${web_care_requests.market_id} is not null then ${web_care_requests.market_id}
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              when ${marketing_cost_clone.market_id} is not null then ${marketing_cost_clone.market_id}
              when ${ga_geodata_clone.market_id} is not null then ${ga_geodata_clone.market_id}
              else null end
              ;;
  }

  dimension: timezone_proc {
    type: string
    sql: case when ${ga_geodata_clone.market_id} in(159, 160) then 'US/Mountain'
              when ${ga_geodata_clone.market_id} in(161) then 'US/Arizona'
              when ${ga_geodata_clone.market_id} in(162) then 'US/Pacific'
              when ${ga_geodata_clone.market_id} in (164) then 'US/Eastern'
              when ${ga_geodata_clone.market_id} in(165, 166) then 'US/Central'
              when ${timezone} in ('GMT-0400', '-0400 (Eastern Daylight Time)', '-0400 (EDT)') then 'US/Eastern'
              else 'US/Mountain' end;;

    }

    dimension: mountain_time  {
      type: date_raw
      sql:   ${timestamp_raw} AT TIME ZONE ${timezone_proc} AT TIME ZONE 'US/Mountain'  ;;

    }

  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: ga_pageviews_full_clone {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }

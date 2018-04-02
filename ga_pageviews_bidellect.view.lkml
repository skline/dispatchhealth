include: "ga_pageviews_clone.view.lkml"

view: ga_pageviews_bidellect {
    extends: [ga_pageviews_clone]

    dimension: market_id{
      type: number
      sql: case when ${care_requests.market_id} is not null then ${care_requests.market_id}
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              else null end
              ;;
    }
  dimension: market_id_final{
    type: number
    sql: case when ${care_requests.market_id} is not null then ${care_requests.market_id}
              when ${invoca_clone.market_id} is not null then ${invoca_clone.market_id}
              when ${bidtellect_cost.market_id} is not null then ${bidtellect_cost.market_id}
              else null end
              ;;
  }

}

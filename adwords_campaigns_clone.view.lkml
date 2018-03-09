view: adwords_campaigns_clone {
  sql_table_name: looker_scratch.adwords_campaigns_clone ;;

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}

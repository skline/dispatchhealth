view: market_market_dim_crosswalk {
  sql_table_name: looker_scratch.market_market_dim_crosswalk ;;

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}.market_name ;;
  }

  measure: count {
    type: count
    drill_fields: [market_name]
  }
}

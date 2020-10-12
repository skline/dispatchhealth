view: regional_markets {
  sql_table_name: looker_scratch.regional_markets ;;

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}."market_name" ;;
  }

  dimension: region_id {
    type: number
    sql: ${TABLE}."region_id" ;;
  }

  dimension: region_owner {
    type: string
    sql: ${TABLE}."region_owner" ;;
  }

  measure: count {
    type: count
    drill_fields: [market_name]
  }
}

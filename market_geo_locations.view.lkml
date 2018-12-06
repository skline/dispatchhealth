view: market_geo_locations {
  sql_table_name: looker_scratch.market_geo_locations ;;

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

view: growth_update_channels {
  sql_table_name: looker_scratch.growth_update_channels ;;

  dimension: identifier_id {
    type: number
    sql: ${TABLE}.identifier_id ;;
  }

  dimension: identifier_type {
    type: string
    sql: ${TABLE}.identifier_type ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: max_opportunity {
    type: string
    sql: ${TABLE}.max_opportunity ;;
  }

  dimension: partner_name {
    type: string
    sql: ${TABLE}.partner_name ;;
  }

  dimension: partner_type {
    type: string
    sql: ${TABLE}.partner_type ;;
  }
  dimension: partner_sub_type {
    type: string
    sql: ${TABLE}.partner_sub_type ;;
  }

  measure: count {
    type: count
    drill_fields: [partner_name]
  }
}

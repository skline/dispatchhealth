view: sales_force_implementation_score_clone {
  sql_table_name: looker_scratch.sales_force_implementation_score_clone ;;

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
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

  dimension: implementation_score {
    type: number
    sql: ${TABLE}.implementation_score ;;
  }

  dimension:  sf_account_name {
    type: string
    sql: ${TABLE}.sf_account_name ;;

  }

  dimension:  sf_implementation_name {
    type: string
    sql: ${TABLE}.sf_implementation_name ;;

  }

  measure: count {
    type: count
    drill_fields: []
  }
}

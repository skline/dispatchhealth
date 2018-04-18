view: mh_market_share {
  sql_table_name: looker_scratch.mh_market_share ;;

  dimension: market_share {
    type: number
    sql: ${TABLE}.market_share ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

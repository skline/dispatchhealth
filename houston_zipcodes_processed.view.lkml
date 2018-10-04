view: houston_zipcodes_processed {
  sql_table_name: looker_scratch.houston_zipcodes_processed ;;

  dimension: count_members {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }
  dimension: service_area_bool {
    type: yesno
    sql: ${zipcodes.market_id} is not null ;;
  }

  measure: sum_count {
    type: sum_distinct
    sql_distinct_key: concat(${zipcode}, ${type}) ;;
    sql: ${count_members} ;;
  }

}

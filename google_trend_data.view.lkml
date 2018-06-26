view: google_trend_data {
  sql_table_name: looker_scratch.google_trend_data ;;

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }

  dimension: search_volume {
    type: number
    sql: ${TABLE}.search_volume ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

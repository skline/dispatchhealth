view: seasonal_adj {
  sql_table_name: looker_scratch.seasonal_adj ;;

  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }

  measure: seasonal_adj {
    type: number
    sql: max(${TABLE}.seasonal_adj) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

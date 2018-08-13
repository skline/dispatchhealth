view: days_in_month_adj {
  sql_table_name: looker_scratch.days_in_month_adj ;;

  measure: days_in_month_adj {
    type: number
    sql: max(${TABLE}.days_in_month_adj) ;;
  }

  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

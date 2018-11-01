view: day_of_week_adj {
  sql_table_name: looker_scratch.day_of_week_adj ;;

  measure: day_of_week_adj {
    type: number
    sql: max(${TABLE}.day_of_week_adj) ;;
  }

  dimension: week_index {
    type: number
    sql: ${TABLE}.week_index ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

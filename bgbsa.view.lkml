view: bgbsa {
  sql_table_name: looker_scratch.bgbsa ;;

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: grand_total {
    type: number
    sql: ${TABLE}.grand_total ;;
  }

  dimension: medicaid {
    type: number
    value_format_name: id
    sql: ${TABLE}.medicaid ;;
  }

  dimension: rating_region {
    type: number
    sql: ${TABLE}.rating_region ;;
  }

  dimension: total_commercial {
    type: number
    sql: ${TABLE}.total_commercial ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

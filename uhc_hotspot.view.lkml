view: uhc_hotspot {
  sql_table_name: looker_scratch.uhc_hotspot ;;

  dimension: uhc_commercial {
    type: number
    sql: ${TABLE}.uhc_commercial ;;
  }

  dimension: uhc_mr {
    type: number
    sql: ${TABLE}.uhc_mr ;;
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

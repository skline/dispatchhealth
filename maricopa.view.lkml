view: maricopa {
  sql_table_name: looker_scratch.maricopa ;;

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count_rows {
    type: count
    drill_fields: []
  }
}

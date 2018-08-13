view: southwire {
  sql_table_name: looker_scratch.southwire ;;

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }


}
